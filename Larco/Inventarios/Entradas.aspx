<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Entradas.aspx.cs" Inherits="BS.Larco.Inventarios.Entradas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
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
    const PAGE_NAME = 'Entradas';
    const TABLE_SELECTOR = '#' + PAGE_NAME + '_table';
    const DIALOG_SELECTOR = '#' + PAGE_NAME + '_dialog';
    const BUTTONS_SELECTOR = '#' + PAGE_NAME + 'table_wrapper_buttons button.disable';

    const DETALLE_PAGE_NAME = 'EntradasDetalle';
    const DETALLE_TABLE_SELECTOR = '#' + DETALLE_PAGE_NAME + '_table';
    const DETALLE_DIALOG_SELECTOR = '#' + DETALLE_PAGE_NAME + '_dialog';
    const DETALLE_BUTTONS_SELECTOR = '#' + DETALLE_PAGE_NAME + 'table_wrapper_buttons button.disable';

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
            showDelete: false,            
            dialogWidth: 1050,
            validate: function (tips) {
                var valid = validateDialog(config, tips);
                if (valid && CURRENT_DETAIL.length <= 0) {
                    tips.text('Tienes que agregar al menos un material a la Entrada.').addClass('ui-state-highlight');
                    valid = false;
                }

                return valid;
            },
            initCompleteCallBack: function () {
                createEntradasDetalle();
                $(DIALOG_SELECTOR + ' ul.ui-tabs-nav').remove();

                //createDownloadDocumentsButton();
                createPrintButton();
            },
            newEntityCallBack: function (oTable, options) {
                $(DETALLE_TABLE_SELECTOR).DataTable().clear().draw();
                CURRENT_DETAIL = [];
                $(TABLE_SEL).Catalog('newEntity', oTable, options);
                $('#ENT_Fecha').val(Date.today().toString('MM/dd/yyyy'));
            },
            editEntityCallBack: function (oTable, options) {
                var data = getSelectedRowData(oTable);
                $(TABLE_SEL).Catalog('editEntity', oTable, options);

                reloadEntradasDetalle(data);
            },
            deleteEntityCallBack: function (oTable, options) {
                deleteEntrada( getSelectedRowData(oTable) );
            },
            saveEntityCallBack: function (oTable, options) {
                saveEntrada( getSaveEntradaTransEntities() );
            }
        });
    }

    function saveEntrada(entities) {
        $.when(executeTransaction(entities)).done(function (json) {
            if (json.ErrorMsg == SUCCESS) {
                $(TABLE_SELECTOR).DataTable().ajax.reload();
                $(BUTTONS_SELECTOR).button('disable');
                $(DIALOG_SELECTOR).dialog('close');
            } else if (json.ErrorMsg.indexOf('already exists') != -1) {
                showError($(DIALOG_SELECTOR + ' p.validateTips'), 'Ya existe una Entrada.');
            } else {
                showError($(DIALOG_SELECTOR + ' p.validateTips'), 'No fue posible actualizar la Entrada.');
            }
        });
    }

    function getSaveEntradaTransEntities() {
        var entities = [];

        var entity = getObject(DIALOG_SELECTOR);
        entity.USER_ID = USER_ID;
        addTransAttrs(entity, 'Save', PAGE_NAME);

        entities.push(entity);

        if (entity.ENT_ID == '') { // is a new Entrada
            for (var i = 0; i < CURRENT_DETAIL.length; i++) {
                var detail = CURRENT_DETAIL[i];

                if (parseFloat(detail.ED_ID) < 0) {
                    detail.ED_ID = '';
                }

                entities.push(detail);
            }
        }

        return entities;
    }

    function deleteEntrada(data) {
        if (confirm('Estas seguro que quieres borrar esta Entrada?') == false)
            return false;

        var entities = getDeleteEntradaTransEntities(data)
        executeDeleteTransaction(entities);
    }

    function executeDeleteTransaction(entities) {
        $.when(executeTransaction(entities)).done(function (json) {
            if (json.ErrorMsg == SUCCESS) {
                $(TABLE_SELECTOR).DataTable().ajax.reload();
                $(BUTTONS_SELECTOR).button('disable');
            } else if (json.ErrorMsg.indexOf('because is being used.') != -1) {
                alert('No fue posible borrar la Entrada, porque ya se registro al menos una salida para alguno de los materiales.');
                log(json.ErrorMsg);
            } else {
                alert('No fue posible borrar la Entrada.');
                log(json.ErrorMsg);
            }
        });
    }

    function getDeleteEntradaTransEntities(data) {
        var entities = [];

        addTransAttrs(data, 'Delete', PAGE_NAME);

        entities.push({ ENT_ID: data.ENT_ID, OperationType: 'DeleteEntities', PageName: DETALLE_PAGE_NAME });
        entities.push(data);

        return entities;
    }

    function reloadEntradasDetalle(data) {
        var entity = { ENT_ID: data.ENT_ID };

        $.when(getEntradasDetalle(entity)).done(function (json1) {
            CURRENT_DETAIL = json1.aaData;
            CURRENT_DETAIL = $.map(CURRENT_DETAIL, function (item, i) {
                item.OperationType = 'Save';
                item.PageName = DETALLE_PAGE_NAME;
                item.Prev_Cantidad = item.ED_Cantidad;
                item.Total = parseFloat(parseFloat(item.ED_Cantidad) * parseFloat(item.ED_Costo)).toFixed(2);
                item.Salida = parseFloat(item.ED_Cantidad) - parseFloat(item.ED_Restante);

                return item;
            });

            $(DETALLE_TABLE_SELECTOR).DataTable().clear().rows.add(CURRENT_DETAIL).draw();
        });
    }

    function getEntradasDetalle(entity) {
        return $.ajax({
            url: AJAX + '/PageInfo/GetPageEntityList?pageName=' + DETALLE_PAGE_NAME + '&searchType=AND&entity=' + $.toJSON(entity)
        });
    }

    function createEntradasDetalle() {
        $('#tabs-1').append('<div id="EntradasDetalle_Container"><br/></div>');

        $('#EntradasDetalle_Container').Page({
            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + DETALLE_PAGE_NAME,
            dialogStyle: 'table',
            onLoadComplete: function (config) {
                var totalIndex = getArrayIndexForKey(config.GridFields, 'ColumnName', 'Total');

                $(DETALLE_TABLE_SELECTOR).Catalog({
                    pageConfig: config,
                    source: [],
                    showEdit: false,
                    showDelete: false,
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
                                tips.text('Ya se agrego el material [' + item.MAT_Descripcion + '] a esta Entrada.').addClass('ui-state-highlight');
                                valid = false;
                                break;
                            }
                        }

                        if (valid && parseFloat(data.ED_Cantidad) <= 0) {
                            tips.text('La Cantidad tiene que ser mayor que 0.').addClass('ui-state-highlight');
                            $('#ED_Cantidad').addClass("ui-state-error");
                            valid = false;
                        }

                        if (valid && parseFloat(data.ED_Costo) <= 0) {
                            tips.text('El Costo tiene que ser mayor que 0.').addClass('ui-state-highlight');
                            $('#ED_Costo').addClass("ui-state-error");
                            valid = false;
                        }

                        return valid;
                    },
                    initCompleteCallBack: detalleInitComplete,
                    newEntityCallBack: function (oTable, options) {
                        $('#MAT_ID').ComboBox('enable');
                        $(DETALLE_TABLE_SELECTOR).Catalog('newEntity', oTable, options);
                        $(DETALLE_DIALOG_SELECTOR + ' #ENT_ID').val($(DIALOG_SELECTOR + ' #ENT_ID').val());
                    },
                    deleteEntityCallBack: function (oTable, options) {
                        if (confirm('Estas seguro que quieres borrar esta entrada?') == false)
                            return false;

                        var data = getSelectedRowData(oTable);

                        if (data.ENT_ID == '') { //is NEW Entrada
                            data.OperationType = 'Delete';
                            updateCurrentDetail(data);
                        } else {
                            deleteEntradaDetalle(data);
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
                            if(json.aaData.length > 0) {
                                existencia = json.aaData[0].Existencia;
                            }

                            data.ED_Saldo = parseFloat(existencia) + parseFloat(data.ED_Cantidad);

                            if (data.ENT_ID == '') { //is NEW Entrada
                                saveEntradaDetalleInMemory(data);
                            } else {
                                data.ED_Restante = data.ED_Cantidad;
                                saveEntradaDetalle(data);
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

    function getExistencia(data) {
        var entity = { MAT_ID: data.MAT_ID };
        return $.ajax({
            url: AJAX + '/PageInfo/GetPageEntityList?pageName=ExistenciaMateriales&searchType=AND&entity=' + $.toJSON(entity)
        });
    }

    function deleteEntradaDetalle(entity) {
        $.ajax({
            type: 'POST',
            url: AJAX + '/PageInfo/DeletePageEntity?pageName=' + DETALLE_PAGE_NAME,
            data: 'entity=' + encodeURIComponent($.toJSON(entity))
        }).done(function (json) {
            if (json.ErrorMsg == SUCCESS) {
                reloadEntradasDetalle(entity);
                $(DETALLE_TABLE_SELECTOR + '_wrapper button.disable').button('disable');
            } else {
                if (json.ErrorMsg.indexOf('because is being used.') != -1) {
                    alert('No fue posible borrar el material de la Entrada, porque ya se registro una salida para este material.');
                    log(json.ErrorMsg);
                }
            }
        });
    }

    function saveEntradaDetalle(entity) {
        $.ajax({
            type: 'POST',
            url: AJAX + '/PageInfo/SavePageEntity?pageName=' + DETALLE_PAGE_NAME,
            data: 'entity=' + encodeURIComponent($.toJSON(entity))
        }).done(function () {
            reloadEntradasDetalle(entity);
            $(DETALLE_DIALOG_SELECTOR).dialog('close');
        });
    }

    function saveEntradaDetalleInMemory(data) {
        data.ED_ID = getUniqueId();
        data.ED_Restante = data.ED_Cantidad;
        data.Salida = 0;
        data.Prev_Cantidad = data.ED_Cantidad;

        var material = getMaterialData(data);
        if (material) {
            data.MAT_Descripcion = material.MAT_Descripcion;
            data.MAT_ProvNumero = material.MAT_ProvNumero;
            data.MAT_Numero = material.MAT_Numero;
        }

        data.Total = parseFloat(parseFloat(data.ED_Cantidad) * parseFloat(data.ED_Costo)).toFixed(2);
        data.OperationType = 'Save';
        data.PageName = DETALLE_PAGE_NAME;
        data.ENT_ID = $('#ENT_ID').val();

        updateCurrentDetail(data);
        $(DETALLE_DIALOG_SELECTOR).dialog('close');
    }

    function updateCurrentDetail(data) {
        var found = false;
        var i = 0;
        for (i = 0; i < CURRENT_DETAIL.length; i++) {
            var item = CURRENT_DETAIL[i];
            if (item.ED_ID == data.ED_ID) {                
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

    function createDownloadDocumentsButton() {
        var ul = $('<ul class="export-menu ui-corner-all" style="display:none;"></ul>').attr('id', 'export-menu-documents');
        //ul.append('<li class="ui-corner-all"><a href="#" id="export-memo" template-name="Memorandum" title="Download Memorandum">Memorandum</a></li>');
        ul.append('<li class="ui-corner-all"><a href="#" id="export-entradas-almacen" template-name="EntradasAlmacen" title="Download Entrdas Alamacen">Entradas Almacen</a></li>');

        $('body').append(ul);
        $(ul).menu();

        $('a', ul).click(function () {
            var _entity = getSelectedRowData($(TABLE_SELECTOR).DataTable());
            _entity.Date = Date.today().toString('MMM dd, yyyy');

            var templateName = $(this).attr('template-name');

            var _url = DOWNLOAD_HANDLER + '/Larco/CreateDocument?pageName=Entradas&csv=true&exportType=word&templateType=Document&templateName=' + templateName + '&entity=' + $.toJSON(_entity);

            $(this).attr('href', _url);
        });

        var expbtn = $('<button id="exportDocuments" title="Download Documentos" class="disable">Documentos</button>');
        var buttonOpts = { text: true };
        buttonOpts.icons = { primary: "ui-icon-arrowthickstop-1-s", secondary: "ui-icon-triangle-1-s" };

        expbtn.button(buttonOpts).click(function (event) {
            var menu = $(ul).show().position({
                my: "left top",
                at: "left bottom",
                of: this
            });

            $(document).one("click", function () {
                menu.hide();
            });

            return false;

        }).button('disable');

        $(TABLE_SELECTOR + '_wrapper_buttons').append(expbtn);
    }

    function createPrintButton() {
        var expbtn = $('<button id="printEntrada" title="Print Entrada" class="disable">Print</button>');
        var buttonOpts = { text: true };
        buttonOpts.icons = { primary: "ui-icon-print" };

        expbtn.button(buttonOpts).click(function (event) {
            var data = getSelectedRowData($(TABLE_SELECTOR).DataTable());
            data.Date = Date.today().toString('MMM dd, yyyy');
            var entity = { ENT_ID: data.ENT_ID };

            $.when(getTemplate('EntradasAlmacen'), getEntradasDetalle(entity)).done(function (json1, json2) {
                var template = json1[0].aaData[0];
                var content = template[TINYMCE_ELE];
                content = addDetail(content, data, json2[0].aaData);
                calculateTotals(data);
                content = replaceEntityValues(content, data);

                tinymce.get(TINYMCE_ELE).setContent(unescape(content));

                $('#template_container').html('');
                $('#mceu_27 button').click();
            });

            return false;
        }).button('disable');

        $(TABLE_SELECTOR + '_wrapper_buttons').append(expbtn);
    }

    function calculateTotals(data) {
        var iva = parseFloat(data.ENT_IVA) || 10.00;
        data.IVA = parseFloat(parseFloat(data.SubTotal) * parseFloat(iva / 100)).toFixed(2);
        data.GrandTotal = parseFloat(parseFloat(data.SubTotal) + parseFloat(data.IVA)).toFixed(2);
    }

    function addDetail(content, data, detailList) {
        const DETAIL_MIN = 35;
        var container = $('#template_container');
        container.html('').html(content);

        var templateRow = $('#printdetail tbody', container).html();
        templateRow = templateRow.replace('id="templaterow"', '');

        $('#printdetail tbody', container).html('');
        var subtotal = 0.0;
        for (var i = 0; i < detailList.length; i++) {
            var detail = detailList[i];
            detail.Total = parseFloat(parseFloat(detail.ED_Cantidad) * parseFloat(detail.ED_Costo)).toFixed(2);

            $('#printdetail tbody', container).append(replaceEntityValues(templateRow, detail));
            subtotal += parseFloat(detail.Total);
        }

        if (detailList.length < DETAIL_MIN) {
            addEmptyRows(templateRow, (DETAIL_MIN - detailList.length))
        }

        data.SubTotal = subtotal.toFixed(2);
        return container.html();
    }

    function getEmptyObject() {
        var empty = {};
        empty.MAT_Numero = '&nbsp;';
        empty.MAT_ProvNumero = '&nbsp;';
        empty.MAT_Descripcion = '&nbsp;';
        empty.ED_Cantidad = '&nbsp;';
        empty.ED_Costo = '&nbsp;';
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
