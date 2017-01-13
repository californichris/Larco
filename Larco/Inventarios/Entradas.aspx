<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Entradas.aspx.cs" Inherits="BS.Larco.Inventarios.Entradas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<script type="text/javascript">
    const PAGE_NAME = 'Entradas';
    const TABLE_SELECTOR = '#' + PAGE_NAME + '_table';
    const DIALOG_SELECTOR = '#' + PAGE_NAME + '_dialog';
    const BUTTONS_SELECTOR = '#' + PAGE_NAME + 'table_wrapper_buttons button.disable';

    const DETALLE_PAGE_NAME = 'EntradasDetalle';
    const DETALLE_TABLE_SELECTOR = '#' + DETALLE_PAGE_NAME + '_table';
    const DETALLE_DIALOG_SELECTOR = '#' + DETALLE_PAGE_NAME + '_dialog';
    const DETALLE_BUTTONS_SELECTOR = '#' + DETALLE_PAGE_NAME + 'table_wrapper_buttons button.disable';

    var CURRENT_DETAIL = [];

    $(document).ready(function () {
        $('div.catalog').Page({
            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
            dialogStyle: 'table',
            onLoadComplete: function (config) {
                $('h2').text(config.Title);
                document.title = config.Title;
                initializeCatalog(config);
            }
        });
    });

    function initializeCatalog(config) {
        $(TABLE_SELECTOR).Catalog({
            pageConfig: config,
            serverSide: true,
            showExport: true,
            dialogWidth: 1000,
            validate: function (tips) {
                var valid = validateDialog(config, tips);
                return valid;
            },
            initCompleteCallBack: function () {
                createEntradasDetalle();                
            },
            newEntityCallBack: function (oTable, options) {
                $(DETALLE_TABLE_SELECTOR).DataTable().clear().draw();
                CURRENT_DETAIL = [];
                $(TABLE_SELECTOR).Catalog('newEntity', oTable, options);
            },
            editEntityCallBack: function (oTable, options) {
                var data = getSelectedRowData(oTable);
                $(TABLE_SELECTOR).Catalog('editEntity', oTable, options);

                reloadEntradasDetalle(data);
            },
            deleteEntityCallBack: function (oTable, options) {
                deleteEntrada( getSelectedRowData(oTable) );
            },
            saveEntityCallBack: function (oTable, options) {
                saveEntrada(getSaveEntradaTransEntities());
            }
        });
    }

    function saveEntrada(entities) {
        log(entities);

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

        for (var i = 0; i < CURRENT_DETAIL.length; i++) {
            var detail = CURRENT_DETAIL[i];

            if (parseFloat(detail.ED_ID) < 0) {
                detail.ED_ID = '';
            }

            entities.push(detail);
        }

        return entities;
    }

    function deleteEntrada(data) {
        if (confirm('Estas seguro que quieres borrar esta Entrada?') == false)
            return false;

        var entities = getDeleteEntradaTransEntities(data)
        log(entities);

        executeDeleteTransaction(entities);
    }

    function executeDeleteTransaction(entities) {
        $.when(executeTransaction(entities)).done(function (json) {
            if (json.ErrorMsg == SUCCESS) {
                $(TABLE_SELECTOR).DataTable().ajax.reload();
                $(BUTTONS_SELECTOR).button('disable');
            } else if (json.ErrorMsg.indexOf('because is being used.') != -1) {
                alert('No fue posible borrar la Entrada, porque ya se registro una salida');
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

            log(CURRENT_DETAIL);

            $(DETALLE_TABLE_SELECTOR).DataTable().clear().rows.add(CURRENT_DETAIL).draw();
        });
    }

    function getEntradasDetalle(entity) {
        return $.ajax({
            url: AJAX + '/PageInfo/GetPageEntityList?pageName=' + DETALLE_PAGE_NAME + '&searchType=AND&entity=' + $.toJSON(entity),
            dataType: 'json'
        });
    }

    function createEntradasDetalle() {
        $('#tabs-1').append('<div id="EntradasDetalle_Container"><br/></div>');

        $('#EntradasDetalle_Container').Page({
            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=' + DETALLE_PAGE_NAME,
            dialogStyle: 'table',
            onLoadComplete: function (config) {
                var totalIndex = getArrayIndexForKey(config.GridFields, 'ColumnName', 'Total');

                $(DETALLE_TABLE_SELECTOR).Catalog({
                    pageConfig: config,
                    source: [],
                    //filter: false,
                    paginate: false,
                    scrollY: '250px',
                    info: false,
                    dialogWidth: 800,
                    validate: function (tips) {
                        var valid = validateDialog(config, tips);

                        //add quantity validation must be > 0

                        return valid;
                    },
                    newEntityCallBack: function (oTable, options) {
                        $('#MAT_ID').ComboBox('enable');
                        $(DETALLE_TABLE_SELECTOR).Catalog('newEntity', oTable, options);
                    },
                    editEntityCallBack: function (oTable, options) {
                        $('#MAT_ID').ComboBox('disable');                        

                        var data = getSelectedRowData(oTable);
                        $(DETALLE_TABLE_SELECTOR).Catalog('editEntity', oTable, options);

                        $('#ED_Cantidad').focus();
                    },
                    deleteEntityCallBack: function (oTable, options) {
                        if (confirm('Estas seguro que quieres borrar esta entrada?') == false)
                            return false;

                        var data = getSelectedRowData(oTable);
                        data.OperationType = 'Delete';

                        updateCurrentDetail(data);
                    },
                    saveEntityCallBack: function (oTable, options) {
                        var data = getObject(DETALLE_DIALOG_SELECTOR);

                        if (data.ED_ID == '') {//new
                            data.ED_ID = getUniqueId();
                            data.ED_Restante = data.ED_Cantidad;
                            data.Salida = 0;
                            data.Prev_Cantidad = data.ED_Cantidad;
                        }

                        //calculate restante
                        var diff = parseFloat(data.ED_Cantidad) - parseFloat(data.Prev_Cantidad);
                        data.ED_Restante = parseFloat(data.ED_Restante) + parseFloat(diff);

                        //calculate salida
                        data.Salida = parseFloat(data.ED_Cantidad) - parseFloat(data.ED_Restante);
                        
                        if (parseFloat(data.ED_Restante) < 0) {
                            $(DETALLE_DIALOG_SELECTOR + ' p.validateTips').text('La cantida tiene que ser al menos ' + data.Salida + ', ya se le dio salida a esta cantidad de material').addClass("ui-state-highlight");

                            return false;
                        }

                        //update prev_cantidad to current after validation
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
                        
                        log(data);
                        updateCurrentDetail(data);

                        $(DETALLE_DIALOG_SELECTOR).dialog('close');
                    },
                });

            }
        });
    }

    function updateCurrentDetail(data) {
        var found = false;
        for (var i = 0; i < CURRENT_DETAIL.length; i++) {
            var item = CURRENT_DETAIL[i];
            if (item.ED_ID == data.ED_ID) {                
                CURRENT_DETAIL[i] = data;

                found = true;
                break;
            }
        }

        if (!found) CURRENT_DETAIL.push(data);
                
        var updatedDetail = $.map(CURRENT_DETAIL, function (item, i) {
            if (item.OperationType != 'Delete') return item;
        });

        log(CURRENT_DETAIL);
        log(updatedDetail);

        $(DETALLE_TABLE_SELECTOR).DataTable().clear().rows.add(updatedDetail).draw();
    }

    function getUniqueId() {
        var id = new Date().getTime();
        return '' + (-1 * id);
    }

    function getMaterialData(material) {
        var matList = $('#MAT_ID').ComboBox('getList');

        for (var i = 0; i < matList.length; i++) {
            if (material.MAT_ID == matList[i].MAT_ID) {
                return matList[i];
            }
        }

    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
