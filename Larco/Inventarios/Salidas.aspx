<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Salidas.aspx.cs" Inherits="BS.Larco.Inventarios.Salidas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<script type="text/javascript" src="<%= Page.ResolveUrl("~/Scripts/jquery.mask.js") %>"></script>
<script type="text/javascript" src="<%= Page.ResolveUrl("~/Scripts/tinymce/tinymce.min.js") %>"></script>
<style type="text/css">
    div.ui-tabs-panel{
        padding-top:2px!important;
        padding-bottom:2px!important;
        padding-left:5px!important;
        padding-right:5px!important;
    }
</style>
<script type="text/javascript">
    const PAGE_NAME = 'Salidas';
    const TABLE_SELECTOR = '#' + PAGE_NAME + '_table';
    const DIALOG_SELECTOR = '#' + PAGE_NAME + '_dialog';
    const BUTTONS_SELECTOR = '#' + PAGE_NAME + 'table_wrapper_buttons button.disable';

    const DETALLE_PAGE_NAME = 'SalidasDetalle';
    const DETALLE_TABLE_SELECTOR = '#' + DETALLE_PAGE_NAME + '_table';
    const DETALLE_DIALOG_SELECTOR = '#' + DETALLE_PAGE_NAME + '_dialog';
    const DETALLE_BUTTONS_SELECTOR = '#' + DETALLE_PAGE_NAME + 'table_wrapper_buttons button.disable';

    const ENTRADAS_SALIDAS_PAGE_NAME = 'EntradasSalidas';
    const TINYMCE_ELE = 'Template';

    var CURRENT_DETAIL = [];

    $(document).ready(function () {
        $('div.catalog').Page({
            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
            dialogStyle: 'table',
            onLoadComplete: function (config) {
                $('h2').text(config.Title);
                document.title = config.Title;
                initializeCatalog(config);

                tinymce.init({
                    selector: '#' + TINYMCE_ELE,
                    height: 275,
                    plugins: [
                                'link image anchor code preview table contextmenu textcolor print'
                    ],
                    menubar: false,
                    toolbar_items_size: 'small',
                    toolbar1: 'bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | styleselect formatselect fontselect fontsizeselect | cut copy paste | bullist numlist',
                    toolbar2: 'undo redo | link unlink image code preview | forecolor backcolor | table | print'
                });
            }
        });
    });

    function initializeCatalog(config) {
        $(TABLE_SELECTOR).Catalog({
            pageConfig: config,
            serverSide: true,
            showExport: true,
            dialogWidth: 1050,
            validate: function (tips) {
                var valid = validateDialog(config, tips);
                if (valid && CURRENT_DETAIL.length <= 0) {
                    tips.text('Tienes que agregar al menos un material a la Salida.').addClass('ui-state-highlight');
                    valid = false;
                }

                return valid;
            },
            initCompleteCallBack: function () {
                createSalidasDetalle();
				$(DIALOG_SELECTOR + ' ul.ui-tabs-nav').remove();
				addOrdenHandler();
				createPrintButton();
            },
            newEntityCallBack: function (oTable, options) {
                $(DETALLE_TABLE_SELECTOR).DataTable().clear().draw();
                CURRENT_DETAIL = [];
                $(TABLE_SELECTOR).Catalog('newEntity', oTable, options);
            },
            editEntityCallBack: function (oTable, options) {
                var data = getSelectedRowData(oTable);
                $(TABLE_SELECTOR).Catalog('editEntity', oTable, options);

                reloadSalidasDetalle(data);
            },
            deleteEntityCallBack: function (oTable, options) {
                deleteSalida( getSelectedRowData(oTable) );
            },
            saveEntityCallBack: function (oTable, options) {
                saveSalida(getSaveSalidaTransEntities());
            }
        });
    }

    function saveSalida(entities) {
        var entity = getObject(DIALOG_SELECTOR);
        $.when(getOrden(entity.SAL_Orden)).done(function (_json) {
            if (_json.aaData.length <= 0) {
                alert('La Orden de Trabajo no existe');
                return;
            }

            $.when(executeTransaction(entities)).done(function (json) {
                if (json.ErrorMsg == SUCCESS) {
                    $(TABLE_SELECTOR).DataTable().ajax.reload();
                    $(BUTTONS_SELECTOR).button('disable');
                    $(DIALOG_SELECTOR).dialog('close');
                } else if (json.ErrorMsg.indexOf('already exists') != -1) {
                    showError($(DIALOG_SELECTOR + ' p.validateTips'), 'Ya existe una Salida.');
                } else {
                    showError($(DIALOG_SELECTOR + ' p.validateTips'), 'No fue posible actualizar la Salida.');
                }
            });

        });
    }

    function getSaveSalidaTransEntities() {
        var entities = [];

        var entity = getObject(DIALOG_SELECTOR);
        entity.USER_ID = USER_ID;
        addTransAttrs(entity, 'Save', PAGE_NAME);

        entities.push(entity);

        if (entity.SAL_ID == '') { // is a new Salida
            for (var i = 0; i < CURRENT_DETAIL.length; i++) {
                var detail = CURRENT_DETAIL[i];

                if (parseFloat(detail.SD_ID) < 0) {
                    detail.SD_ID = '';
                }

                entities.push(detail);
            }
        }

        return entities;
    }

    function deleteSalida(data) {
        if (confirm('Estas seguro que quieres borrar esta Salida?') == false)
            return false;

        var entity = { SAL_ID: data.SAL_ID };

        $.when(getSalidasDetalle(entity)).done(function (json1) {
            var _salidasDetalle = json1.aaData;

            var entities = getDeleteSalidasTransEntities(data, _salidasDetalle);
            executeDeleteTransaction(entities);
        });
    }

    function executeDeleteTransaction(entities) {
        $.when(executeTransaction(entities)).done(function (json) {
            if (json.ErrorMsg == SUCCESS) {
                $(TABLE_SELECTOR).DataTable().ajax.reload();
                $(BUTTONS_SELECTOR).button('disable');
            } else if (json.ErrorMsg.indexOf('because is being used.') != -1) {
                alert('No fue posible borrar la Salida, porque esta ligada a una entrada.');
                log(json.ErrorMsg);
            } else {
                alert('No fue posible borrar la Salida.');
                log(json.ErrorMsg);
            }
        });
    }

    function getDeleteSalidasTransEntities(data, salidaDetalle) {
        var entities = [];

        addTransAttrs(data, 'Delete', PAGE_NAME);

        if (salidaDetalle) {
            for (var i = 0; i < salidaDetalle.length; i++) {
                entities.push({ SD_ID: salidaDetalle[i].SD_ID, OperationType: 'DeleteEntities', PageName: ENTRADAS_SALIDAS_PAGE_NAME });
            }
        }
        
        entities.push({ SAL_ID: data.SAL_ID, OperationType: 'DeleteEntities', PageName: DETALLE_PAGE_NAME });
        entities.push(data);

        return entities;
    }

    function reloadSalidasDetalle(data) {
        var entity = { SAL_ID: data.SAL_ID };

        $.when(getSalidasDetalle(entity)).done(function (json1) {
            CURRENT_DETAIL = json1.aaData;
            CURRENT_DETAIL = $.map(CURRENT_DETAIL, function (item, i) {
                item.OperationType = 'Save';
                item.PageName = DETALLE_PAGE_NAME;

                return item;
            });

            $(DETALLE_TABLE_SELECTOR).DataTable().clear().rows.add(CURRENT_DETAIL).draw();
        });
    }

    function getSalidasDetalle(entity) {
        return $.ajax({
            url: AJAX + '/PageInfo/GetPageEntityList?pageName=' + DETALLE_PAGE_NAME + '&searchType=AND&entity=' + $.toJSON(entity)
        });
    }

    function createSalidasDetalle() {
        $('#tabs-1').append('<div id="SalidasDetalle_Container"><br/></div>');

        $('#SalidasDetalle_Container').Page({
            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + DETALLE_PAGE_NAME,
            dialogStyle: 'table',
            onLoadComplete: function (config) {
                var totalIndex = getArrayIndexForKey(config.GridFields, 'ColumnName', 'Total');

                $(DETALLE_TABLE_SELECTOR).Catalog({
                    pageConfig: config,
                    source: [],
                    showEdit: false,
                    paginate: false,
                    scrollY: '250px',
                    info: false,
                    dialogWidth: 800,
                    validate: function (tips) {
                        var valid = validateDialog(config, tips);

                        var data = getObject(DETALLE_DIALOG_SELECTOR);
                        for (var i = 0; i < CURRENT_DETAIL.length; i++) {
                            var item = CURRENT_DETAIL[i];
                            if (item.MAT_ID == data.MAT_ID) {
                                tips.text('Ya se agrego el material [' + item.MAT_Descripcion + '] a esta Salida.').addClass('ui-state-highlight');
                                valid = false;
                                break;
                            }
                        }

                        if (valid && parseFloat(data.SD_Cantidad) <= 0) {
                            tips.text('La Cantidad tiene que ser mayor que 0.').addClass('ui-state-highlight');
                            $('#SD_Cantidad').addClass("ui-state-error");
                            valid = false;
                        }

                        return valid;
                    },
                    initCompleteCallBack: detalleInitComplete,
                    newEntityCallBack: function (oTable, options) {
                        $('#MAT_ID').ComboBox('enable');
                        $(DETALLE_TABLE_SELECTOR).Catalog('newEntity', oTable, options);
                        $(DETALLE_DIALOG_SELECTOR + ' #SAL_ID').val($(DIALOG_SELECTOR + ' #SAL_ID').val());
                    },
                    deleteEntityCallBack: function (oTable, options) {
                        if (confirm('Estas seguro que quieres borrar esta salida?') == false)
                            return false;

                        var data = getSelectedRowData(oTable);

                        if (data.SAL_ID == '') { //is NEW Entrada
                            data.OperationType = 'Delete';
                            updateCurrentDetail(data);
                        } else {
                            deleteSalidaDetalle(data);
                        }                        
                    },
                    saveEntityCallBack: function (oTable, options) {
                        var data = getObject(DETALLE_DIALOG_SELECTOR);
                        $.when(getExistencia(data)).done(function (json) {
                            if (json.ErrorMsg) {
                                alert('No fue posible validar la existencia en almacen de este material.');
                                return;
                            }

                            var existencia = 0.0;
                            if (json.aaData.length > 0) {
                                existencia = json.aaData[0].Existencia;
                            }

                            if (parseFloat(data.SD_Cantidad) > parseFloat(existencia)) {
                                alert('La cantidad especificada es mayor que la cantidad en el almacen[' + existencia + '].');
                                return;
                            }

                            data.SD_Saldo = parseFloat(existencia) - parseFloat(data.SD_Cantidad);

                            if (data.SAL_ID == '') { //is NEW Entrada
                                saveSalidaDetalleInMemory(data);
                            } else {
                                saveSalidaDetalle(data);
                            }

                        });
                    },
                });

            }
        });
    }

    function detalleInitComplete(oTable, oSettings, json, options) {
        attachProveedorIdEventHandler()
    }

    function deleteSalidaDetalle(entity) {
        $.when(executeTransaction(getDeleteSalidaDetalleTransEntities(entity))).done(function (json) {
            if (json.ErrorMsg == SUCCESS) {
                reloadSalidasDetalle(entity);
                $(DETALLE_TABLE_SELECTOR + '_wrapper button.disable').button('disable');
            } else {
                alert(json.ErrorMsg);
            }
        });
    }

    function saveSalidaDetalle(entity) {
        $.ajax({
            type: 'POST',
            url: AJAX + '/PageInfo/SavePageEntity?pageName=' + DETALLE_PAGE_NAME,
            data: 'entity=' + encodeURIComponent($.toJSON(entity))
        }).done(function () {
            reloadSalidasDetalle(entity);
            $(DETALLE_DIALOG_SELECTOR).dialog('close');
        });
    }

    function saveSalidaDetalleInMemory(data) {
        data.SD_ID = getUniqueId();

        var material = getMaterialData(data);
        if (material) {
            data.MAT_Descripcion = material.MAT_Descripcion;
            data.MAT_ProvNumero = material.MAT_ProvNumero;
            data.MAT_Numero = material.MAT_Numero;
        }

        data.OperationType = 'Save';
        data.PageName = DETALLE_PAGE_NAME;
        data.SAL_ID = $('#SAL_ID').val();

        updateCurrentDetail(data);
        $(DETALLE_DIALOG_SELECTOR).dialog('close');
    }

    function updateCurrentDetail(data) {
        var found = false;
        var i = 0;
        for (i = 0; i < CURRENT_DETAIL.length; i++) {
            var item = CURRENT_DETAIL[i];
            if (item.SD_ID == data.SD_ID) {                
                CURRENT_DETAIL[i] = data;

                found = true;
                break;
            }
        }

        if (!found) {
            CURRENT_DETAIL.push(data);
        } else {
            if (data.OperationType == 'Delete') {
                CURRENT_DETAIL.splice(i, 1);
            }
        }
        
        $(DETALLE_TABLE_SELECTOR).DataTable().clear().rows.add(CURRENT_DETAIL).draw();
    }

    function getDeleteSalidaDetalleTransEntities(data) {
        var entities = [];

        addTransAttrs(data, 'Delete', DETALLE_PAGE_NAME);
        entities.push({ SD_ID: data.SD_ID, OperationType: 'DeleteEntities', PageName: ENTRADAS_SALIDAS_PAGE_NAME });
        entities.push(data);

        return entities;
    }

    function getExistencia(data) {
        var entity = { MAT_ID: data.MAT_ID };
        return $.ajax({
            url: AJAX + '/PageInfo/GetPageEntityList?pageName=ExistenciaMateriales&searchType=AND&entity=' + $.toJSON(entity)
        });
    }

    function getOrden(_ite_nombre) {
        var entity = { ITE_Nombre: _ite_nombre };
        return $.ajax({
            url: AJAX + '/PageInfo/GetPageEntityList?pageName=ValidateOrden&searchType=AND&entity=' + $.toJSON(entity)
        });
    }

    function addOrdenHandler() {
        var year = Date.today().toString('yy');

        $('#SAL_Orden').mask('99-999-999-99', {
            placeholder: year + '-___-___-__',
            selectOnFocus: true
        });

        $('#SAL_OrdenFilter').mask('99-999-999-99', {
            placeholder: year + '-___-___-__',
            selectOnFocus: true
        });
    }

    function createPrintButton() {
        var expbtn = $('<button id="printSalida" title="Print Salida" class="disable">Print</button>');
        var buttonOpts = { text: true };
        buttonOpts.icons = { primary: "ui-icon-print" };

        expbtn.button(buttonOpts).click(function (event) {
            var data = getSelectedRowData($(TABLE_SELECTOR).DataTable());
            data.Date = Date.today().toString('MMM dd, yyyy');
            var entity = { SAL_ID: data.SAL_ID };

            $.when(getTemplate('SalidasAlmacen'), getSalidasDetalle(entity)).done(function (json1, json2) {
                var template = json1[0].aaData[0];
                var content = template[TINYMCE_ELE];
                content = addDetail(content, data, json2[0].aaData);                
                content = replaceEntityValues(content, data);

                tinymce.get(TINYMCE_ELE).setContent(unescape(content));

                $('#template_container').html('');
                $('#mceu_27 button').click();
            });

            return false;
        }).button('disable');

        $(TABLE_SELECTOR + '_wrapper_buttons').append(expbtn);
    }

    function addDetail(content, data, detailList) {
        const DETAIL_MIN = 40;
        var container = $('#template_container');
        container.html('').html(content);

        var templateRow = $('#printdetail tbody', container).html();
        templateRow = templateRow.replace('id="templaterow"', '');

        $('#printdetail tbody', container).html('');
        var subtotal = 0.0;
        for (var i = 0; i < detailList.length; i++) {
            var detail = detailList[i];

            $('#printdetail tbody', container).append(replaceEntityValues(templateRow, detail));
            subtotal += parseFloat(detail.SD_Cantidad);
        }

        if (detailList.length < DETAIL_MIN) {
            addEmptyRows(templateRow, (DETAIL_MIN - detailList.length))
        }

        data.GrandTotal = subtotal.toFixed(2);
        return container.html();
    }

    function getEmptyObject() {
        var empty = {};
        empty.MAT_Descripcion = '&nbsp;';
        empty.SD_Cantidad = '&nbsp;';
        empty.MAT_Numero = '&nbsp;';
        empty.ES_Costo = '&nbsp;';
        empty.Total = '&nbsp;';

        return empty;
    }

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br />
    <div class="catalog"></div>
    <div style="display:none;" id="plugin_container">
        <textarea cols="20" rows="10" id="Template"></textarea>
    </div>
    <div style="display:none;" id="template_container">       
    </div>
</asp:Content>
