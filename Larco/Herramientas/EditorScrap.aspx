<%@ Page Title="Editor de Scrap" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditorScrap.aspx.cs" Inherits="BS.Larco.Herramientas.EditorScrap" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    const PAGE_NAME = 'Scrap';
	    const TABLE_SELECTOR = '#' + PAGE_NAME + '_table';
	    const DIALOG_SELECTOR = '#' + PAGE_NAME + '_dialog';
	    const BUTTONS_SELECTOR = TABLE_SELECTOR + '_wrapper_buttons button.disable';
	    const TIPS_SELECTOR = DIALOG_SELECTOR + ' p.validateTips';

	    $(document).ready(function () {
	        LOGIN_NAME = '14'; //TODO: removed this line, is only for testing
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
	        $('#ITE_Nombre').change(function () {
	            ordenChange();
	        });

	        $('#SCR_Parcial').click(function () {
	            if ($('#SCR_Parcial').is(':checked')) {
	                $('#SCR_Repro').prop('readonly', false).val('');
	            } else {
	                $('#SCR_Repro').prop('readonly', true);
	            }
	        });

	        $('#SCR_Cantidad,#SCR_Repro').keydown(function (event) {
	            if ($(this).val() == '' || isNaN(parseInt($(this).val()))) return;

	            if (event.which == 38) {
	                event.preventDefault();
	                $(this).val(parseInt($(this).val()) + 1);
	            } else if (event.which == 40 && parseInt($(this).val()) > 0) {
	                event.preventDefault();
	                $(this).val(parseInt($(this).val()) - 1);
	            }
	        });

	        var catalog = $('table.display').Catalog({
	            pageConfig: config,
	            serverSide: true,
	            showExport: true,
	            dialogWidth: 800,
	            validate: function (tips) {
	                var valid = validateDialog(config, tips);

	                valid = valid && checkInt(tips, $('#SCR_Cantidad'), 'Cantidad Scrapeada', 1, 999);
	                if ($('#SCR_Parcial').is(':checked')) {
	                    valid = valid && checkRequired(tips, $('#SCR_Repro'), 'A Reprogramar')
                                && checkInt(tips, $('#SCR_Repro'), 'A Reprogramar', 1, 999);

	                }

	                if (parseInt($('#SCR_Cantidad').val()) > parseInt($('#SCR_Cantidad').attr('prevQuantity'))) {
	                    tips.text('La cantidad scrapeada es mayor que la cantidad de la orden.').addClass('ui-state-highlight');
	                    return false;
	                }

                    //TODO: check with Daria if the quantity can be different than the order if the scrap is full
	                
	                return valid;
	            },
	            newEntityCallBack: function (oTable, options) {
	                catalog.Catalog('newEntity', oTable, options);
	                $('#SCR_Fecha').datepicker('setDate', new Date());
	                $('#SCR_Repro').prop('readonly', true).val('');
	            },
	            saveEntityCallBack: function (oTable, options) {
	                if ($('#SCR_ID').val()) {//Editing existing scrap order
	                    catalog.Catalog('saveEntity', oTable, options);
	                    return;
	                }

	                $.when(getOrden($('#ITE_Nombre').val())).done(function (json) {
	                    var scrap = getScrapEntity();
	                    var orden = json.aaData[0];
	                    var newOrden = $.evalJSON($.toJSON(orden)); //clonning current orden
	                    newOrden.OrdenId = ''; //setting id to empty so it will be inserted
	                    newOrden.ITE_ID = '';//TODO: removed this line when the table has been removed
	                    newOrden.ITE_Nombre = getNewOrdenNumber(orden.ITE_Nombre);

	                    addTransAttrs(newOrden, 'Save', 'Ordenes')

	                    var entities = [];
	                    $.when(getTasksByProductId(newOrden.ProductId), getItemTasks(orden.ITE_Nombre), getTaskList()).done(function (json1, json2, json3) {
	                        var tasks = json1[0].aaData;
	                        var currentOrdenTasks = json2[0].aaData;
	                        var taskList = json3.aaData;

	                        currentOrdenTasks.sort(function (a, b) {
	                            var a1 = parseInt(a['TAS_Order']), b1 = parseInt(b['TAS_Order']);
	                            return a1 > b1 ? 1 : -1;
	                        });

	                        //setting Plan Number so the new order is set to active in the second task
	                        if (!newOrden.PN_Id || newOrden.PN_Id == 'NULL') {
	                            newOrden.PN_Id = 'TEMP_VAL';
	                        }

	                        newOrden.StockParcial = '0'; //set stock parcial flag to false
	                        newOrden.StockParcialCantidad = '';

	                        if ($('#SCR_Parcial').is(':checked')) {
	                            newOrden.Requerida = scrap.SCR_Repro;
	                            newOrden.Ordenada = scrap.SCR_Repro;

	                            orden.Ordenada = parseInt(orden.Ordenada) - parseInt(scrap.SCR_Repro);
	                            entities.push(addTransAttrs(orden, 'Save', 'Ordenes'));

	                            var detectedTask = getTaskById(currentOrdenTasks, scrap.SCR_TareaDetectadoId);
	                            var greaterTasks = getTasksGreaterThan(currentOrdenTasks, detectedTask.TAS_Order);

	                            var it = { OperationType: 'Update', PageName: 'ItemTasks', ItemTaskId: detectedTask.ItemTaskId, ITS_Status: '1', ITS_DTStart: 'GETDATE()', ITS_DTStop: 'NULL' };
	                            entities.push(it);

                                //update current orden status in itemtasks
	                            for (var t = 0; t < greaterTasks.length; t++) {
	                                entities.push(getUpdateItemTasksEntity(greaterTasks[t]));
	                            }
	                        } else {
	                            //update current orden status in itemtasks
	                            for (var t = 0; t < currentOrdenTasks.length; t++) {
	                                var itemTask = currentOrdenTasks[t];
	                                if (itemTask.ITS_Status) {//ITS_Status not null
	                                    var it = { OperationType: 'Update', PageName: 'ItemTasks', ItemTaskId: itemTask.ItemTaskId, ITS_Status: '9' };
	                                    entities.push(it);
	                                }
	                            }
	                        }

	                        entities = entities.concat(getProdOrdenEntities(newOrden, tasks));

                            //return to prev val
	                        newOrden.PN_Id = newOrden.PN_Id == 'TEMP_VAL' ? 'NULL' : newOrden.PN_Id;
	                        entities.push(addTransAttrs(scrap, 'Save', PAGE_NAME));

	                        $.when(executeTransaction(entities)).done(function (json) {
	                            if (json.ErrorMsg == SUCCESS) {
	                                $(TABLE_SELECTOR).DataTable().ajax.reload();
	                                $(BUTTONS_SELECTOR).button('disable');
	                                $(DIALOG_SELECTOR).dialog('close');
	                            } else if (json.ErrorMsg.indexOf('already exists') != -1) {
	                                showError($(TIPS_SELECTOR), 'La Orden de Trabajo ya fue declara como scrap.');
	                            } else {
	                                showError($(TIPS_SELECTOR), 'No fue posible scrapear la Orden de Trabajo.');
	                            }
	                        });
	                    });

	                });
	            },
	            deleteEntityCallBack: function (oTable, options) {
	                var data = getSelectedRowData(oTable);

	                if (confirm('Estas seguro que quieres borrar la orden ' + data.ITE_Nombre + ' que fue marcada como scrap?') == false)
	                    return false;

	                if (confirm('De verdad estas seguro que quieres borrar la orden ' + data.ITE_Nombre + '?') == false)
	                    return false;

	                deleteScrap(data);
	            },
	            sorting: [[getArrayIndexForKey(config.GridFields, 'ColumnName', 'SCR_Fecha') || 0, 'desc'],
                         [getArrayIndexForKey(config.GridFields, 'ColumnName', 'ITE_Nombre') || 0, 'desc']]
	        });
	    }

	    function deleteScrap(scrap) {
	        $.when( getOrden(scrap.SCR_NewItem) ).done(function (json) {
	            var orden = json.aaData[0];
	            var entities = getDeleteOrdenTransEntities(orden);
	            entities.push(addTransAttrs(scrap, 'Delete', 'Scrap'))

	            executeDeleteTransaction(entities);
	        });
	    }

	    function executeDeleteTransaction(entities) {
	        $.when(executeTransaction(entities)).done(function (json) {
	            if (json.ErrorMsg == SUCCESS) {
	                $(TABLE_SELECTOR).DataTable().ajax.reload();
	                $(BUTTONS_SELECTOR).button('disable');
	            } else {
	                alert('No fue posible borrar la Orden.');
	            }
	        });
	    }

	    function getTasksGreaterThan(tasks, taskOrder) {
	        return $.grep(tasks, function (t) {
	            return parseInt(t.TAS_Order) > parseInt(taskOrder);
	        });
	    }

	    function getTaskById(tasks, taskId) {
	        var results = $.grep(tasks, function (t) {
	            return t.TAS_Id == taskId;
	        });

	        return results[0];
	    }

	    function getUpdateItemTasksEntity(task) {
	        var entity = {};
	        entity.ITS_DTStart = 'NULL';
	        entity.ITS_DTStop = 'NULL';
	        entity.ITS_Machine = 'NULL';
	        entity.ITS_Status = 'NULL';
	        entity.USE_Login = 'NULL';

	        entity.ItemTaskId = task.ItemTaskId;
	        addTransAttrs(entity, 'Update', 'ItemTasks')

	        return entity;
	    }

	    function getScrapEntity() {
	        var entity = getObject('#' + PAGE_NAME + '_dialog');
	        entity.Update_Date = 'GETDATE()';
	        entity.Update_User = LOGIN_NAME;

	        //TODO: remove this code, once the columns have been removed.
	        entity.SCR_Tarea = $('#SCR_TareaId option:selected').text();
	        entity.SCR_Detectado = $('#SCR_TareaDetectadoId option:selected').text();

	        return entity;
	    }

	    function ordenChange() {
	        $.when( getOrden($('#ITE_Nombre').val()) ).done(function (json) {
	            var tips = $('.validateTips');
	            tips.text('').removeClass('ui-state-highlight');
	            if (!json.aaData || json.aaData.length == 0) {
	                tips.text('La Orden de Trabajo : ' + $('#ITE_Nombre').val() + ' no existe.').addClass('ui-state-highlight');
	                return false;
	            }
	            var data = json.aaData[0];
	            var type = getOrdenType(data);
	            if (TYPE.STOCK == type || TYPE.MERGE == type) {
	                tips.text('La Orden de Trabajo : ' + $('#ITE_Nombre').val() + ' es una orden de stock o mezclada no se puede scrapear.').addClass('ui-state-highlight');
	                return false;
	            }
	            
	            $('#SCR_NewItem').val(getNewOrdenNumber(data.ITE_Nombre));
	            $('#SCR_Cantidad').attr('prevQuantity', data.Ordenada);
	            $('#SCR_Cantidad').val(data.Ordenada);
	        });
	    }

	    function getNewOrdenNumber(orden) {
	        var current = orden.substring(3, 4);
	        current = current == '0' ? '9' : parseInt(current) - 1

	        return orden.substring(0, 3) + current + orden.substring(4, 13);
	    }

	    function getOrden(orden) {
	        var entity = { ITE_Nombre: orden };
	        return $.getData(AJAX + '/PageInfo/GetPageEntityList?pageName=Ordenes&entity=' + $.toJSON(entity));
	    }

	    function getTaskList() {
	        return $.getData('AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Tareas');
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
