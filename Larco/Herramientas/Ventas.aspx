<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Ventas.aspx.cs" Inherits="BS.Larco.Herramientas.Ventas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <style type="text/css">
            #StockParcial {display:inline;}
            #StockParcialCantidad {float: right; margin-right:1px; width:80%; display:inline;}
            table.ventas-detail div.dataTables_scrollBody table.dataTable tbody td,
            table.ventas-detail div.dataTables_scrollHead table.dataTable thead th ,
            table.ventas-detail div.dataTables_wrapper table.dataTable thead th,
            table.ventas-detail div.dataTables_wrapper table.dataTable tbody td
            {
                padding:2px 2px 2px 4px;
            }        
        </style>
    <script type="text/javascript" src="<%= Page.ResolveUrl("~/Scripts/jquery.mask.js") %>"></script>
	<script type="text/javascript">
	    const PAGE_NAME = 'Ordenes';
	    const TABLE_SELECTOR = '#' + PAGE_NAME + '_table';
	    const DIALOG_SELECTOR = '#' + PAGE_NAME + '_dialog';
	    const BUTTONS_SELECTOR = '#' + PAGE_NAME + 'table_wrapper_buttons button.disable';

	    var LAST_PROD_ORDERS_BY_PLAN = [];
	    var LAST_PROD_ORDERS_BY_PART = [];

        //Preloading MergeOrdenes page config
	    $.getData(AJAX + '/PageInfo/GetPageConfig?pageName=MergeOrdenes');

	    $(document).ready(function () {
	        LOGIN_NAME = '14'; //TODO: removed this line, is only for testing
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        createEventHandlers();
	        appendAdditionalInfoSection();

	        var ventasCtlg = $(TABLE_SELECTOR).Catalog({
	            pageConfig: config,
	            serverSide: true,
	            showExport: true,
	            dialogWidth: 1100,
	            validate: function (tips) {
	                var valid = validateDialog(config, tips);

                    //TODO: validate cliente: maybe the foreign key can take care of this
	                if ($('#Stock').is(':checked')) {
	                    valid = valid && checkRequired(tips, $('#PN_Id'), 'Numero de Plano');

	                    if ($('#OrdenId').val() == '') { //new
	                        var list = $('#popularidad_plano_table').DataTable().data();
	                        if (list.length <= 0) {//No rows in the table
	                            tips.text('La Cantidad de Cliente debe de ser menor o igual que la cantidad en Stock para este plano.').addClass("ui-state-highlight");
	                            return false;
	                        }

	                        var stock = $('#popularidad_plano_table').DataTable().rows(0).data()[0].Stock;
	                        if (parseInt($('#Requerida').val()) > parseInt(stock)) {
	                            tips.text('La Cantidad de Cliente debe de ser menor o igual que la cantidad en Stock(' + stock + ') para este plano.').addClass("ui-state-highlight");
	                            return false;
	                        }
	                    } else {
	                        var data = getSelectedRowData($(TABLE_SELECTOR).DataTable());
	                        if (parseInt(data.Requerida) != parseInt($('#Requerida').val()) && parseInt($('#Requerida').val()) > parseInt(data.Requerida)) {
	                            var diff = parseInt($('#Requerida').val()) - parseInt(data.Requerida);
	                            var list = $('#popularidad_plano_table').DataTable().data();
	                            if (list.length <= 0) {
	                                tips.text('El aumento en la Cantidad de Cliente (cambio de ' + data.Requerida + ' a ' + $('#Requerida').val() + ') debe de ser menor o igual que la cantidad en Stock.').addClass("ui-state-highlight");
	                                return false;
	                            }

	                            var stock = $('#popularidad_plano_table').DataTable().rows(0).data()[0].Stock;
	                            if (parseInt(diff) > parseInt(stock)) {
	                                tips.text('El aumento en la Cantidad de Cliente (cambio de ' + data.Requerida + ' a ' + $('#Requerida').val() + ') debe de ser menor o igual que la cantidad en Stock(' + stock + ').').addClass("ui-state-highlight");
	                                return false;
	                            }
	                        }
	                    }
	                }

	                if ($('#StockParcial').is(':checked')) {
	                    valid = valid && checkRequired(tips, $('#StockParcialCantidad'), 'Cantidad Stock Parcial');
	                    valid = valid && checkInt(tips, $('#StockParcialCantidad'), 'Cantidad Stock Parcial', 1, parseInt($('#Requerida').val()));
	                    valid = valid && checkRequired(tips, $('#PN_Id'), 'Numero de Plano');

	                    if ($('#OrdenId').val() == '') { //new
	                        var list = $('#popularidad_plano_table').DataTable().data();
	                        if (list.length <= 0) {
	                            tips.text('La Cantidad de Stock Parcial debe de ser menor o igual que la cantidad en Stock para este plano.').addClass("ui-state-highlight");
	                            return false;
	                        }

	                        var stock = $('#popularidad_plano_table').DataTable().rows(0).data()[0].Stock;
	                        if (parseInt($('#StockParcialCantidad').val()) > parseInt(stock)) {
	                            tips.text('La Cantidad de Stock Parcial debe de ser menor o igual que la cantidad en Stock para este plano.').addClass("ui-state-highlight");
	                            return false;
	                        }
	                    } else { //edit
	                        var data = getSelectedRowData($(TABLE_SELECTOR).DataTable());
	                        if (parseInt(data.StockParcialCantida) != parseInt($('#StockParcialCantidad').val()) && parseInt($('#StockParcialCantidad').val()) > parseInt(data.StockParcialCantida)) {
	                            var diff = parseInt($('#StockParcialCantidad').val()) - parseInt(data.StockParcialCantida);
	                            var list = $('#popularidad_plano_table').DataTable().data();
	                            if (list.length <= 0) {
	                                tips.text('El aumento en la Cantidad de Stock Parcial (cambio de ' + data.StockParcialCantida + ' a ' + $('#StockParcialCantidad').val() + ') debe de ser menor o igual que la cantidad en Stock.').addClass("ui-state-highlight");
	                                return false;
	                            }

	                            var stock = $('#popularidad_plano_table').DataTable().rows(0).data()[0].Stock;
	                            if (parseInt(diff) > parseInt(stock)) {
	                                tips.text('El aumento en la Cantidad de Cliente (cambio de ' + data.StockParcialCantidad + ' a ' + $('#StockParcialCantidad').val() + ') debe de ser menor o igual que la cantidad en Stock(' + stock + ').').addClass("ui-state-highlight");
	                                return false;
	                            }
	                        }
	                    }
	                }

	                if ($('#Mezclado').is(':checked')) {
	                    var mergeOrders = $('#MergeOrdenes_table').DataTable().data();
	                    if (mergeOrders.length <= 0) {
	                        tips.text('Es necesario agregar al menos una Orden con la que se va a Mezclar.').addClass("ui-state-highlight");
	                        return false;
	                    }

	                    var cantidad = 0;
	                    for (var i = 0; i < mergeOrders.length; i++) {
	                        cantidad += parseInt(mergeOrders[i].MO_Cantidad);
	                    }

	                    if (cantidad != parseInt($('#Requerida').val())) {
	                        tips.text('La Cantidad Cliente debe de ser igual que la sumatoria de las ordenes a mezclar.').addClass("ui-state-highlight");
	                        return false;
	                    }
	                }

	                if ($('#Alerta').is(':checked')) {
	                    valid = valid && checkRequired(tips, $('#AlertaMsg'), 'El Mensaje en Orden de Trabajo');
	                    valid = valid && checkRequired(tips, $('#Instrucciones'), 'Instrucciones adicionales')	                    
	                }

	                return valid;
	            },
	            newEntityCallBack: function (oTable, options) {
	                ventasCtlg.Catalog('newEntity', oTable, options);
	                setDefaults();
	            },
	            editEntityCallBack: function (oTable, options) {
	                var data = getSelectedRowData(oTable);
	                setDefaults();
	                ventasCtlg.Catalog('editEntity', oTable, options);

	                clearAdditionalInfoTables();
	                setPlanId(data);
	                reloadAdditionalInfoSection();

	                //$('#Stock, #StockParcial, #Mezclado').prop('disabled', true);

	                if(isTrue(data.Mezclado)) {
	                    $('#PN_Id, #Numero').prop('readonly', true);
	                }

	                if (isTrue(data.StockParcial)) {
	                    $('#StockParcialCantidad').prop('readonly', false);
	                    $('#PN_Id, #Numero').prop('readonly', true);
	                }
	            },
	            deleteEntityCallBack: function (oTable, options) {
	                deleteOrden( getSelectedRowData(oTable) );
	            },
	            saveEntityCallBack: function (oTable, options) {
	                saveOrden( getOrdenEntity() );
	            },
	            sorting: [[getArrayIndexForKey(config.GridFields, 'ColumnName', 'Recibido') || 0, 'desc'],
	                      [getArrayIndexForKey(config.GridFields, 'ColumnName', 'OrdenId') || 0, 'desc']
	                     ]
	        });
	    }

	    function saveOrden(entity) {
	        addTransAttrs(entity, 'Save', PAGE_NAME);
	        if (entity.OrdenId == '') {
	            saveNewOrden(entity);//new Orden
	        } else {
	            editOrden(entity);//existing Orden update
	        }
	    }

	    function saveNewOrden(entity) {
	        $.when( getSaveOrdenEntities(entity) ).done( function(entities) {
	            executeSaveOrdenTransaction(entities);
	        });
	    }

	    function editOrden(entity) {
	        var prev = getSelectedRowData($(TABLE_SELECTOR).DataTable());
	        if (getOrdenType(entity) != getOrdenType(prev)) {
	            // Orden type changed so delete the prev one and create anew one.
	            var deleteTranEntities = getDeleteOrdenTransEntities(prev);
                //reset id's, they will be created again
	            entity.OrdenId = '';
	            entity.ST_ID = '';
	            entity.ITE_ID = '';

	            $.when(getSaveOrdenEntities(entity)).done(function (_entities) {
	                var entities = deleteTranEntities.concat(_entities);
	                executeEditOrdenTransaction(entities);
	            });
	        } else {
                // Orden type did not change so performed a normal update
	            if (isTrue(entity.Stock) || isTrue(entity.Mezclado)) {
	                editStockMergeOrden(entity);
	            } else {
	                editProdOrden(entity);
	            }
	        }
	    }

	    function editProdOrden(entity) {
	        var prevData = getSelectedRowData($(TABLE_SELECTOR).DataTable());

	        $.when( getItemTasks(entity.ITE_Nombre) ).done(function (json) {
	            var entities = [];

	            //if the name change or the product change
                //TODO: this would not be necesary once the table is removed
	            if (prevData.ITE_Nombre != entity.ITE_Nombre || prevData.ProductId != entity.ProductId) {
	                entities.push(getSaveItemsEntity(entity));
	            }

                // if it's a partial stock order and the quantity changed update the stock record
	            if (entity.ST_ID && prevData.StockParcialCantidad != entity.StockParcialCantidad) {
	                entities.push(getSaveStockParcialEntity(entity));
	            }

                //sorting tasks by task order
	            var tasks = json.aaData;
	            tasks.sort(function (a, b) {
	                var a1 = parseInt(a['TAS_Order']), b1 = parseInt(b['TAS_Order']);
	                return a1 > b1 ? 1 : -1;
	            });

	            for (var i = 0; i < tasks.length; i++) {
	                var update = false;
	                var itemTask = { OperationType: 'Update', PageName: 'ItemTasks', ItemTaskId: tasks[i].ItemTaskId, ITE_Nombre: entity.ITE_Nombre };

                    //if the planid was null and now is been defined move order to the next task ready 
	                if (!prevData.PN_Id && (entity.PN_Id != '' && entity.PN_Id != 'NULL')) {
	                    if (tasks[i].TAS_Id == '1') { //TAS_Id ==1 is Ventas//&& tasks[i].ITS_Status == '1'
	                        itemTask.ITS_Status = '2';
	                        itemTask.ITS_DTStart = 'GETDATE()';
	                        itemTask.ITS_DTStop = 'GETDATE()';
	                        itemTask.USE_Login = LOGIN_NAME;
	                    }

	                    if (i == 1) { //next task
	                        itemTask.ITS_Status = '0';
	                        itemTask.ITS_DTStart = 'GETDATE()';
	                        itemTask.USE_Login = LOGIN_NAME;
	                    }
	                    update = true;
	                }
	                
	                //move order back to active in ventas when planid goes back to null
	                if (prevData.PN_Id && (!entity.PN_Id || entity.PN_Id == 'NULL')) {
	                    if (tasks[i].TAS_Id == '1') {//TAS_Id ==1 is Ventas//&& tasks[i].ITS_Status == '1'
	                        itemTask.ITS_Status = '1';
	                        itemTask.ITS_DTStart = 'GETDATE()';
	                        itemTask.ITS_DTStop = 'NULL';
	                        itemTask.USE_Login = LOGIN_NAME;
	                    } else {
	                        itemTask.ITS_Status = 'NULL';
	                        itemTask.ITS_DTStart = 'NULL';
	                        itemTask.ITS_DTStop = 'NULL';
	                        itemTask.USE_Login = 'NULL';
	                    }
	                    update = true;
	                }
                    
	                if (prevData.ITE_Nombre != entity.ITE_Nombre) update = true;

	                if (update) {
	                    entities.push(itemTask);
	                }	                
	            }

	            entities.push(entity);

	            executeEditOrdenTransaction(entities);
	        });
	    }

	    function editStockMergeOrden(entity) {
	        var entities = [];

	        if (isTrue(entity.Stock)) {
	            entities.push(getSaveStockEntity(entity));
	            entities.push(entity);	            
	        } else { // Mezclado
	            entities.push(entity);
	            entities.push({ ITE_Nombre: entity.ITE_Nombre, OperationType: 'DeleteEntities', PageName: 'MergeOrdenes' });
	            addMergeOrders(entities, entity);
	        }

	        executeEditOrdenTransaction(entities);
	    }

	    function getSaveOrdenEntities(entity) {
	        var dfd = jQuery.Deferred();
	        var entities = [];

	        if (isTrue(entity.Stock) || isTrue(entity.Mezclado)) {
	            entities = getStockMergeOrdenEntities(entity);
	            dfd.resolve(entities);
	        } else {
	            $.when(getTasksByProduct()).done(function (json) {
	                entities = getProdOrdenEntities(entity, json.aaData);
	                dfd.resolve(entities);
	            });
	        }

	        return dfd.promise();
	    }

	    function getStockMergeOrdenEntities(entity) {
	        //TODO: add logic to save instructions
	        var entities = [];

	        if (isTrue(entity.Stock)) {
	            entities.push(getSaveStockEntity(entity));
	            entities.push(entity);
	        } else { //Merge Orders       
	            entities.push(entity);
	            //TODO: add foreign key to tblMergeOrders ITE_nombre with tblOrdenes
	            addMergeOrders(entities, entity);
	        }

	        return entities;
	    }
  
	    function addMergeOrders(entities, entity) {
	        var mergeOrders = $('#MergeOrdenes_table').DataTable().data();
	        for (var i = 0; i < mergeOrders.length; i++) {
	            var merge = mergeOrders[i];
	            addTransAttrs(merge, 'Save', 'MergeOrdenes');
	            merge.Order_ITE_Nombre = entity.ITE_Nombre;
	            merge.MO_ID = '';

	            entities.push(merge);
	        }
	    }

	    function getOrden() {
	        var entity = { ITE_Nombre: $('#ITE_Nombre').val() };
	        return $.ajax({
	            url: AJAX + '/PageInfo/GetPageEntityList?pageName=' + PAGE_NAME + '&entity=' + $.toJSON(entity),
	            dataType: 'json'
	        });
	    }

	    function getTasksByProduct() {
	        return getTasksByProductId($('#ProductId').val());
	    }

	    function getLatestOrderByClient(_clientId) {
	        var entity = { ClientId: _clientId };
	        return $.ajax({
	            url: AJAX + '/Larco/GetLatestOrderByClient?pageName=' + PAGE_NAME + '&entity=' + $.toJSON(entity),
	            dataType: 'json'
	        });
	    }

	    function getOrdenEntity() {
	        var entity = getObject(DIALOG_SELECTOR);
	        entity.PN_Id = ($('#PN_Id').val() && $('#PN_Id').attr('PlanId')) || 'NULL';
	        
	        entity.Update_Date = 'GETDATE()';
	        entity.Update_User = LOGIN_NAME;
	        entity.ClientId = $('#ITE_Nombre').val().split('-')[1];
	        //TODO: remove this code, once the columns have been removed.
	        entity.Nombre = $('#EmployeeId option:selected').text();
	        entity.Producto = $('#ProductId option:selected').text();

	        return entity;
	    }

	    function getSaveStockParcialEntity(data) {
	        var stock = getStockParcialEntity(data);
	        return addTransAttrs(stock, 'Save', 'Stock');
	    }

	    function getStockParcialEntity(data) {
	        var entity = getStockEntity(data);
	        entity.ST_Cantidad = data.StockParcialCantidad;

	        return entity;
	    }

	    function getSaveStockEntity(data) {
	        var stock = getStockEntity(data);
	        return addTransAttrs(stock, 'Save', 'Stock');
	    }

	    function getStockEntity(data) {
	        var entity = {};
	        entity.PN_Id = data.PN_Id;
	        entity.ITE_Nombre = data.ITE_Nombre;
	        entity.ST_Cantidad = data.Requerida;
            entity.ST_Fecha = 'GETDATE()';
	        entity.ST_Tipo = 'Salida';
	        entity.Update_Date = 'GETDATE()';
	        entity.Update_User = LOGIN_NAME;
	        entity.ST_ID = data.ST_ID;

	        return entity;
	    }

	    function saveStockOrden(entity) {
	        return saveEntity(entity, PAGE_NAME);
	    }

	    function saveStock(stock) {
	        return saveEntity(stock, 'Stock');
	    }

	    function saveItems(item) {
	        return saveEntity(item, 'Items');
	    }

	    function saveEntity(entity, pageName) {
	        return $.ajax({
	            type: "POST",
	            url: AJAX + '/PageInfo/SavePageEntity?pageName=' + pageName,
	            data: "entity=" + encodeURIComponent($.toJSON(entity))
	        });
	    }

	    function deleteStock(stock) {
	        return deleteEntity(stock, 'Stock');
	    }

	    function deleteItems(item) {
	        return deleteEntity(item, 'Items');
	    }

	    function deleteEntity(entity, pageName) {
	        return $.ajax({
	            type: "POST",
	            url: AJAX + '/PageInfo/DeletePageEntity?pageName=' + pageName,
	            data: "entity=" + encodeURIComponent($.toJSON(entity))
	        });
	    }

	    function deleteOrden(data) {
	        if (confirm('Estas seguro que quieres borrar la orden?') == false)
	            return false;

	        if (confirm('En verdad estas seguro que quieres borrar la orden?') == false)
	            return false;

	        var entities = getDeleteOrdenTransEntities(data)
	        executeDeleteTransaction(entities);
	    }

	    function executeDeleteTransaction(entities) {
	        $.when( executeTransaction(entities) ).done(function (json) {
	            if (json.ErrorMsg == SUCCESS) {
	                $(TABLE_SELECTOR).DataTable().ajax.reload();
	                $(BUTTONS_SELECTOR).button('disable');
	            } else {
                    //TODO: add logic to display proper error when order is in used
	                alert('No fue posible borrar la Orden de Trabajo.');
	            }
	        });
	    }

	    function executeSaveOrdenTransaction(entities) {
	        $.when( executeTransaction(entities) ).done(function (json) {
	            if (json.ErrorMsg == SUCCESS) {
	                $(TABLE_SELECTOR).DataTable().ajax.reload();
	                $(BUTTONS_SELECTOR).button('disable');
	                $(DIALOG_SELECTOR).dialog('close');
	            } else if (json.ErrorMsg.indexOf('already exists') != -1) {
	                showError($(DIALOG_SELECTOR + " p.validateTips"), 'Ya existe una Orden de Trabajo con este numero.');
	            } else {
	                showError($(DIALOG_SELECTOR + 'p.validateTips'), 'No fue posible crear la Orden de Trabajo.');
	            }
	        });
	    }

	    function executeEditOrdenTransaction(entities) {
	        $.when(executeTransaction(entities)).done(function (json) {
	            if (json.ErrorMsg == SUCCESS) {
	                $(TABLE_SELECTOR).DataTable().ajax.reload();
	                $(BUTTONS_SELECTOR).button('disable');
	                $(DIALOG_SELECTOR).dialog('close');
	            } else if (json.ErrorMsg.indexOf('already exists') != -1) {
	                showError($(DIALOG_SELECTOR + ' p.validateTips'), 'Ya existe una Orden de Trabajo con este numero.');
	            } else {
	                showError($(DIALOG_SELECTOR + ' p.validateTips'), 'No fue posible actualizar la Orden de Trabajo.');
	            }
	        });
	    }

	    function setPlanId(data) {
	        if ($('#PN_Id').val() != '') {
	            $('#PN_Id').attr('PlanId', $('#PN_Id').val());
	            $('#PN_Id').val(data.PN_Numero).prop('readonly', false);
	        }
	    }

	    function setDefaults() {
	        $('#Recibido,#Interna,#Entrega').datepicker("setDate", new Date());
	        $('#EmployeeId').val(LOGIN_NAME).selectmenu('refresh');
	        $('#PN_Id').attr('PlanId', '');
	        $('#StockParcialCantidad').prop('readonly', !$('#StockParcial').is(':checked'));
	        clearAdditionalInfoTables();
	        $('#newMergeOrdenes_table').button('disable');
	        $('#AlertaMsg,#Instrucciones').prop('readonly', true);
	        $('#Stock,#StockParcial,#Mezclado').prop('disabled', false);

	        $('#Numero,#PN_Id').prop('readonly', false);
	    }

	    function clearAdditionalInfoTables() {
	        $('#popularidad_numero_parte_table').DataTable().clear().draw();
	        $('#popularidad_plano_table').DataTable().clear().draw();
	        $('#prod_orders_part_number_table').DataTable().clear().draw();
	        $('#prod_orders_plan_table').DataTable().clear().draw();
	        $('#MergeOrdenes_table').DataTable().clear().draw();

	        $(DIALOG_SELECTOR + ' td.dataTables_empty').remove();
	    }

	    function appendAdditionalInfoSection() {
	        var table = $(DIALOG_SELECTOR + ' #tabs-1 table.table-style');
	        $('#additional_info').insertAfter(table).show();

	        var options = {
	            data: [],
	            paginate: false,
	            filter: false,
	            jQueryUI: true,
	            info: false,
	            columns: [
                    { title: "Ordenes", data: 'Ordenes', bSortable: false },
                    { title: "Piezas", data: 'Piezas', bSortable: false },
                    { title: "Stock", data: 'Stock', bSortable: false },
                    { title: "Sug.", data: 'Sugerida', bSortable: false }
	            ]
	        }
	        $('#popularidad_numero_parte_table').DataTable(options);
	        $('#popularidad_numero_parte_table_wrapper div.fg-toolbar').remove();
	        $('#popularidad_plano_table').DataTable(options);
	        $('#popularidad_plano_table_wrapper div.fg-toolbar').remove();

	        var prodOptions = {
	            data: [],
	            paginate: false,
	            filter: false,
	            jQueryUI: true,
	            info: false,
	            scrollY: '75px',
	            columns: [
                    { title: "Orden", data: 'ITE_Nombre', bSortable: false },
                    { title: "Larco", data: 'Ordenada', bSortable: false, width: '35px' },
                    { title: "Cliente", data: 'Requerida', bSortable: false, width: '35px' },
                    { title: "Disp.", data: 'Disp', bSortable: false, width: '35px' },
                    { title: "Tarea", data: 'Tarea', bSortable: false },
                    { title: "Status", data: 'TaskStatus', bSortable: false, width: '35px' }
	            ]
	        }

	        $('#prod_orders_part_number_table').DataTable(prodOptions);
	        $('#prod_orders_part_number_table_wrapper div.fg-toolbar').remove();
	        $('#prod_orders_plan_table').DataTable(prodOptions);
	        $('#prod_orders_plan_table_wrapper div.fg-toolbar').remove();

	        $('table.ventas-detail span.DataTables_sort_icon').remove();
	        
	        $('#merge_orders_info').show();

	        var td = $('label[for=MezclarOrders]').parent();
	        var mergeTD = $('#MezclarOrders').parent();
	        $('label[for=MezclarOrders]').remove();
	        td.append($('#merge_orders_info'));
	        mergeTD.remove();
	        td.attr('rowspan', '2');
	        //td.attr('colspan', '2');

	        $.when($.getData(AJAX + '/PageInfo/GetPageConfig?pageName=MergeOrdenes')).done(function (json) {
	            $('#merge_orders_info').Page({
	                source: json,
	                dialogStyle: 'table',
	                onLoadComplete: function (config) {
	                    $('#Order_ITE_Nombre').attr('name','ITE_Nombre');
	                    $.page.initSelectMenu('#MO_ITE_Nombre');

	                    var mergeCtlg = $('#MergeOrdenes_table').Catalog({
	                        pageConfig: config,
	                        source: [],
	                        filter: false,
	                        paginate: false,
	                        scrollY: '35px',
                            showEdit:false,
	                        initCompleteCallBack: function () {
	                            $('#merge_orders_info div.ui-corner-br').remove();
	                            $('#merge_orders_info td.dataTables_empty').remove();
	                        },
	                        validate: function (tips) {
	                            var valid = validateDialog(config, tips);

	                            if (LAST_PROD_ORDERS_BY_PART.length > 0) {
	                                var index = getArrayIndexForKey(LAST_PROD_ORDERS_BY_PLAN, 'ITE_Nombre', $('#MO_ITE_Nombre').val());
	                                if (index != -1) { //this should never happend the index must always be != than -1
	                                    if (parseInt($('#MO_Cantidad').val()) > parseInt(LAST_PROD_ORDERS_BY_PLAN[index].Disp)) {
	                                        showError(tips, 'La cantidad es mayor que lo disponible en esta orden.');
	                                        valid = false;
	                                    }

	                                }
	                            }
	                            if (LAST_PROD_ORDERS_BY_PART.length > 0) {
	                                var index = getArrayIndexForKey(LAST_PROD_ORDERS_BY_PART, 'ITE_Nombre', $('#MO_ITE_Nombre').val());
	                                if (valid && index != -1) { //this should never happend the index must always be != than -1
	                                    if (parseInt($('#MO_Cantidad').val()) > parseInt(LAST_PROD_ORDERS_BY_PART[index].Disp)) {
	                                        showError(tips, 'La cantidad es mayor que lo disponible en esta orden.');
	                                        valid = false;
	                                    }
	                                }
	                            }

	                            return valid;
	                        },
	                        newEntityCallBack: function (oTable, options) {
	                            $('#MergeOrdenes_dialog').attr('originaltitle', 'Mezclar Orden');	                            
	                            mergeCtlg.Catalog('newEntity', oTable, options);
	                        },
	                        saveEntityCallBack: function (oTable, options) {	                            
	                            var tips = $("#MergeOrdenes_dialog p.validateTips");
	                            var entity = getObject('#MergeOrdenes_dialog');
	                            entity.Order_ITE_Nombre = $('#ITE_Nombre').val();
	                            entity.Update_Date = 'GETDATE()';
	                            entity.Update_User = LOGIN_NAME;

	                            var list = oTable.data();
                                var results = $.grep(list, function (mo) {
                                    return mo.MO_ITE_Nombre == entity.MO_ITE_Nombre;
                                });

                                if (results.length > 0) {
                                    showError(tips, 'No se puede mezclar con la misma orden.');
                                    return;
                                }

	                            list.push(entity);                               
	                            oTable.clear().rows.add(list).draw();
	                            $('#MergeOrdenes_dialog').dialog('close');

	                            index = getArrayIndexForKey(LAST_PROD_ORDERS_BY_PLAN, 'ITE_Nombre', entity.MO_ITE_Nombre);
	                            if (index != -1) { //this should never happend the index must always be != than -1
	                                LAST_PROD_ORDERS_BY_PLAN[index].Disp = parseInt(LAST_PROD_ORDERS_BY_PLAN[index].Disp) - parseInt(entity.MO_Cantidad);
	                                $('#prod_orders_plan_table').DataTable().clear().rows.add(LAST_PROD_ORDERS_BY_PLAN).draw();
	                            }

	                            index = getArrayIndexForKey(LAST_PROD_ORDERS_BY_PART, 'ITE_Nombre', entity.MO_ITE_Nombre);
	                            if (index != -1) { //this should never happend the index must always be != than -1
	                                LAST_PROD_ORDERS_BY_PART[index].Disp = parseInt(LAST_PROD_ORDERS_BY_PART[index].Disp) - parseInt(entity.MO_Cantidad);
	                                $('#prod_orders_part_number_table').DataTable().clear().rows.add(LAST_PROD_ORDERS_BY_PART).draw();
	                            }

	                            if (list.length > 0) {
	                                $('#PN_Id,#Numero').prop('readonly', true);
	                            }
	                        },
	                        deleteEntityCallBack: function (oTable, options) {
	                            if (confirm('Estas seguro que quieres borrar esta orden mezclada?') == false)
	                                return false;

	                            var entity = getSelectedRowData(oTable);
	                            var list = oTable.data();
	                            var index = getArrayIndexForKey(list, 'MO_ITE_Nombre', entity.MO_ITE_Nombre);
	                            if (index != -1) { //this should never happend the index must always be != than -1
	                                oTable.rows(index).remove().draw();
	                            }

	                            index = getArrayIndexForKey(LAST_PROD_ORDERS_BY_PLAN, 'ITE_Nombre', entity.MO_ITE_Nombre);
	                            if (index != -1) { //this should never happend the index must always be != than -1
	                                LAST_PROD_ORDERS_BY_PLAN[index].Disp = parseInt(LAST_PROD_ORDERS_BY_PLAN[index].Disp) + parseInt(entity.MO_Cantidad);
	                                $('#prod_orders_plan_table').DataTable().clear().rows.add(LAST_PROD_ORDERS_BY_PLAN).draw();
	                            }

	                            index = getArrayIndexForKey(LAST_PROD_ORDERS_BY_PART, 'ITE_Nombre', entity.MO_ITE_Nombre);
	                            if (index != -1) { //this should never happend the index must always be != than -1
	                                LAST_PROD_ORDERS_BY_PART[index].Disp = parseInt(LAST_PROD_ORDERS_BY_PART[index].Disp) + parseInt(entity.MO_Cantidad);
	                                $('#prod_orders_part_number_table').DataTable().clear().rows.add(LAST_PROD_ORDERS_BY_PART).draw();
	                            }

	                            list = oTable.data();
	                            if (list.length <= 0) {
	                                $('#PN_Id,#Numero').prop('readonly', false);
	                            }
	                        }
	                    });
	                }
	            });

	        });
	    }

	    function reloadAdditionalInfoSection() {
	        reloadPartNumberAdditionalInfo(false);
	        reloadPlanAdditionalInfo();
	        if ($('#Mezclado').is(':checked')) {
	            reloadMergeOrders();
	            $('#newMergeOrdenes_table').button('enable');
	        }
	        $(DIALOG_SELECTOR + ' td.dataTables_empty').remove();
	    }

	    function reloadMergeDrop() {
	        var groupData = getProdOrdersData();

            $.page.createSelectMenuOptions($('#MO_ITE_Nombre'), { aaData: groupData }, { textField: 'ITE_Nombre', valField: 'ITE_Nombre' });
	    }

	    function getProdOrdersData() {
	        var list = []
	        $.merge(list, $('#prod_orders_part_number_table').DataTable().data());
	        $.merge(list, $('#prod_orders_plan_table').DataTable().data());
	        var fieldName = 'ITE_Nombre';

	        list.sort(function (a, b) {
	            var a1 = a[fieldName], b1 = b[fieldName];
	            if (a1 == b1) return 0;
	            return a1 > b1 ? 1 : -1;
	        });

	        var groupData = [];
	        var prevVal = '';

	        for (var i = 0; i < list.length; i++) {
	            var data = list[i];
	            if (prevVal != data[fieldName]) {
	                groupData.push(data);
	            }
	            prevVal = data[fieldName];
	        }

            //TODO: removed orders that have 0 available pieces
	        return groupData;
	    }

	    function reloadMergeOrders() {
	        var entity = { Order_ITE_Nombre: $('#ITE_Nombre').val() };
	        var _url = AJAX + '/PageInfo/GetPageEntityList?pageName=MergeOrdenes&entity=' + encodeURIComponent($.toJSON(entity));
	        $('#MergeOrdenes_table').DataTable().ajax.url(_url).load();
	        $('#MergeOrdenes_table').css('width', '100%').DataTable().columns.adjust().draw(); //Fix column width bug in datatables.
	    }

	    function reloadPartNumberAdditionalInfo(updateQuantity) {
	        reloadPartNumberPopularity(updateQuantity);
	        reloadProdOrdersByPartNumber();
	        $('#prod_orders_part_number_table').css('width', '100%').DataTable().columns.adjust().draw();	        
	    }

	    function reloadPlanAdditionalInfo() {
	        reloadPlanPopularity();
	        reloadProdOrdersByPlan();
	        $('#prod_orders_plan_table').css('width', '100%').DataTable().columns.adjust().draw();
	    }

	    function getPopularityAggregate() {
	        var aggregate = { GroupByFields: '', Functions: [] };
	        aggregate.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
	        aggregate.Functions.push({ Function: 'SUM', FieldName: 'Requerida', Alias: 'Piezas' });

	        return aggregate;
	    }

	    function reloadPartNumberPopularity(updateQuantity) {
	        if ($.trim($('#Numero').val()) == '') return;
	        
	        var aggregate = getPopularityAggregate();
	        var entity = { Recibido: getPopularityDateRange(), Numero: $.trim($('#Numero').val()) };

	        var stockAggregate = { GroupByFields: 'PN_Id,PA_Alias,ST_Tipo', Functions: [] };
	        stockAggregate.Functions.push({ Function: 'SUM', FieldName: 'ST_Cantidad', Alias: 'Cantidad' });
	        var entityStock = { PA_Alias: $.trim($('#Numero').val()) };
	        
	        $.when(getAggreateData(PAGE_NAME, aggregate, entity), getAggreateData('PlanoAliasStock', stockAggregate, entityStock)).done(function (json1, json2) {
	            var dataSet = createPopularityDataSet(json1, json2);
	            $('#popularidad_numero_parte_table').DataTable().clear().rows.add(dataSet).draw();
	            if (updateQuantity) $('#Requerida').val($('#popularidad_numero_parte_table tbody tr td:last').html());
	        });
	    }

	    function reloadPlanPopularity() {
	        if ($.trim($('#PN_Id').val()) == '') return;

	        var aggregate = getPopularityAggregate();
	        var entity = { Recibido: getPopularityDateRange(), PN_Id: $.trim($('#PN_Id').attr('PlanId')) };

	        var stockAggregate = { GroupByFields: 'PN_Id,PN_Numero,ST_Tipo', Functions: [] };
	        stockAggregate.Functions.push({ Function: 'SUM', FieldName: 'ST_Cantidad', Alias: 'Cantidad' });
	        var entityStock = { PN_Id: $.trim($('#PN_Id').attr('PlanId')) };

	        $.when(getAggreateData(PAGE_NAME, aggregate, entity), getAggreateData('PlanoStock', stockAggregate, entityStock)).done(function (json1, json2) {
	            var dataSet = createPopularityDataSet(json1, json2);
	            $('#popularidad_plano_table').DataTable().clear().rows.add(dataSet).draw();
	        });
	    }

	    function getProdOrdersAggregate() {
	        var aggregate = { GroupByFields: 'ITE_Nombre,Ordenada,Requerida,Tarea,TaskStatus,StockParcialCantidad', Functions: [] };
	        aggregate.Functions.push({ Function: 'SUM', FieldName: 'MO_Cantidad', Alias: 'Usadas' });
            
	        return aggregate;
	    }

	    function reloadProdOrdersByPartNumber() {
	        if ($.trim($('#Numero').val()) == '') return;

	        var aggregate = getProdOrdersAggregate();
	        var entity = { Numero: $.trim($('#Numero').val()), ITS_DTStart: 'NOT_NULL', ITS_DTStop: 'NULL', ITS_Status: 'NOT_9' };

	        $.when(getAggreateData('OrdenesInProd', aggregate, entity)).done(function (json) {
	            LAST_PROD_ORDERS_BY_PART = createProdDataSet(json);
	            if (json.aaData && json.aaData.length > 0) {
	                $('#prod_orders_part_number_table').DataTable().clear().rows.add(LAST_PROD_ORDERS_BY_PART).draw();
	                reloadMergeDrop();
	            } else {
	                $('table.ventas-detail td.dataTables_empty').remove();
	            }
	        });
	    }

	    function reloadProdOrdersByPlan() {
	        if ($.trim($('#PN_Id').val()) == '') return;

	        var aggregate = getProdOrdersAggregate();
	        var entity = { PN_Id: $.trim($('#PN_Id').attr('PlanId')), ITS_DTStart: 'NOT_NULL', ITS_DTStop: 'NULL', ITS_Status: 'NOT_9' };

	        $.when(getAggreateData('OrdenesInProd', aggregate, entity)).done(function (json) {
	            if (json.aaData && json.aaData.length > 0) {
	                LAST_PROD_ORDERS_BY_PLAN = createProdDataSet(json);
	                $('#prod_orders_plan_table').DataTable().clear().rows.add(LAST_PROD_ORDERS_BY_PLAN).draw();
	                reloadMergeDrop();
	            } else {
	                $('table.ventas-detail td.dataTables_empty').remove();
	            }
	        });
	    }

	    function createProdDataSet(json) {
	        for (var i = 0; i < json.aaData.length; i++) {
	            var data = json.aaData[i];
	            var stockParcial = data.StockParcialCantida || 0.0;
	            var usadas = data.Usadas || 0.0;

	            var disp = (parseInt(data.Ordenada) + parseInt(stockParcial)) - (parseInt(data.Requerida) + parseInt(usadas));
	            data.Disp = disp;
	        }

	        return json.aaData;
	    }

	    function createPopularityDataSet(json1, json2) {
	        json1 = json1[0];
	        json2 = json2[0];

	        var stock = 0;
	        if (json2.aaData && json2.aaData.length > 0) {
	            for (var i = 0; i < json2.aaData.length; i++) {
	                if (json2.aaData[i].ST_Tipo == 'Entrada') stock += parseInt(json2.aaData[i].Cantidad);
	                if (json2.aaData[i].ST_Tipo == 'Salida') stock -= parseInt(json2.aaData[i].Cantidad);
	            }
	        }

	        var dataSet = [];
	        if (json1.aaData && json1.aaData.length > 0) {
	            json1.aaData[0].Stock = stock;
	            json1.aaData[0].Ordenes = json1.aaData[0].Ordenes || 0;
	            json1.aaData[0].Piezas = json1.aaData[0].Piezas || 0;
	            json1.aaData[0].Sugerida = Math.ceil((json1.aaData[0].Piezas || 0) * .50);//TODO: get percentage from config
	            dataSet.push(json1.aaData[0]);
	        } else {
	            dataSet.push({ Stock: stock, Ordenes: 0, Requerida: 0, Sugerida: 0 });
	        }

	        return dataSet;
	    }

	    function getPopularityDateRange() {
	        //TODO: add time to configuration, rigth now default to 6 months

	        var start = Date.today().addMonths(-6).toString('MM/dd/yyyy');
	        var end = Date.today().toString('MM/dd/yyyy');
	        return start + '_RANGE_' + end;
	    }

	    function getAggreateData(pageName, aggregate, entity) {
	        return $.ajax({
	            url: AJAX + '/PageInfo/GetAggreateEntities?pageName=' + pageName + '&searchType=AND&aggregateInfo=' + $.toJSON(aggregate) + '&entity=' + $.toJSON(entity),
	            dataType: 'json'
	        });
	    }

	    function createEventHandlers() {
	        addOrdenHandler();

	        $('#Requerida').blur(function () {
	            if ($('#Ordenada').val() == '') {
	                $('#Ordenada').val($('#Requerida').val());
	            }
	        });

	        $('#ProductId').change(function () {
	            $('#Otras').val($('#ProductId option:selected').text());
	        });

	        $('#StockParcialCantidad').prop('type', 'text').prop('readonly', true).insertAfter($('#StockParcial')).addClass('text ui-widget-content ui-corner-all');

	        $('#StockParcial').click(function () {
	            $('#Mezclado,#Stock').prop('checked', false);
	            $('#newMergeOrdenes_table').button('disable');
	            $('#MergeOrdenes_table').DataTable().clear().draw();
	            $('#StockParcialCantidad').prop('readonly', !$('#StockParcial').is(':checked'));
	            if ($('#StockParcial').is(':checked')) {
	                $('#StockParcialCantidad').focus();
	            } else {
	                $('#StockParcialCantidad').val('');
	            }
	        });

	        $('#Stock').click(function () {
	            if ($('#Stock').is(':checked')) {
	                $('#Mezclado,#StockParcial').prop('checked', false);
	                $('#StockParcialCantidad').prop('readonly', true).val('');
	                $('#newMergeOrdenes_table').button('disable');
	                $('#MergeOrdenes_table').DataTable().clear().draw();
	            }
	        });

	        $('#Mezclado').click(function () {
	            if ($('#Mezclado').is(':checked')) {
	                $('#Stock,#StockParcial').prop('checked', false);
	                $('#newMergeOrdenes_table').button('enable');
	                reloadAdditionalInfoSection();
	            } else {
	                $('#newMergeOrdenes_table').button('disable');
	            }
	        });

	        $('#Interna').change(function () {
	            if ($('#OrdenId').val() != '' || $('#Interna').val() == '') return;

	            $('#Entrega').datepicker("setDate", $('#Interna').datepicker('getDate').addDays(1));
	        });

	        $('#Interna,#Entrega').keydown(function (event) {
	            if ($.trim($(this).val()) == '') return;

	            if (event.which == 38) {
	                event.preventDefault();
	                $(this).datepicker("setDate", $(this).datepicker('getDate').addDays(1));
	                $(this).change();
	            } else if (event.which == 40) {
	                event.preventDefault();
	                $(this).datepicker("setDate", $(this).datepicker('getDate').addDays(-1));
	                $(this).change();
	            }
	        });

	        $('#Requerida,#Ordenada').keydown(function (event) {
	            if ($(this).val() == '' || isNaN(parseInt($(this).val()))) return;

	            if (event.which == 38) {
	                event.preventDefault();
	                $(this).val(parseInt($(this).val()) + 1);
	            } else if (event.which == 40 && parseInt($(this).val()) > 0) {
	                event.preventDefault();
	                $(this).val(parseInt($(this).val()) - 1);
	            }
	        });

	        $('#Requerida, #Unitario').change(function () {
	            var req = parseFloat($('#Requerida').val()) || 0.0;
	            var uni = parseFloat($('#Unitario').val()) || 0.0;

	            $('#Total').val((req * uni).toFixed(2));
	        });

	        $('#Numero').change(function () {
	            reloadPartNumberAdditionalInfo(true);
                //TODO: get latest intructions
	        });


	        $('#PN_Id').autocomplete({
	            minLength: 3,
	            source: function (request, response) {
	                var entity = { label: 'LIKE_' + request.term };
	                var _url = AJAX + '/PageInfo/GetPageEntityList?pageName=PlanosList&entity=' + $.toJSON(entity);

	                $.when($.getData(_url)).done(function (json) {
	                    response(json.aaData);
	                });
	            },
	            select: function (event, ui) {
	                $('#PN_Id').val(ui.item.label);
	                $('#PN_Id').attr('PlanId', ui.item.value);
	                
	                reloadPlanAdditionalInfo();

	                if ($('#OrdenId').val() == '') {//new
	                    $('#Numero').val(ui.item.label);

	                    var options = $('#ProductId option');
	                    var length = options.length
	                    for (var i = 0; i < length; i++) {
	                        var opt = $(options[i]);
	                        if ($.trim(opt.text().toUpperCase()) == $.trim(ui.item.desc.toUpperCase())) {
	                            $('#ProductId').ComboBox('value', opt.val());
	                            $('#Otras').val($('#ProductId option:selected').text());
	                            break;
	                        }
	                    }

	                    $('#Numero').focus();
	                }

	                return false;
	            },
	            focus: function (event, ui) {
	                $('#PN_Id').val(ui.item.label);
	                return false;
	            }
	        }).autocomplete("instance")._renderMenu = function (ul, items) {
	            var that = this;
	            var length = items.length;
	            for (var i = 0; i < length; i++) {
	                that._renderItemData(ul, items[i]); //TODO: implement _renderItemData to increase performance
	            }
	        };

	        $('#Alerta').click(function () {
	            $('#AlertaMsg').prop('readonly', true);
	            $('#Instrucciones').prop('readonly', true);

	            if ($('#Alerta').is(':checked')) {
	                $('#AlertaMsg').val('Atención: INSTRUCCIONES ESPECIALES');
	                $('#AlertaMsg').prop('readonly', false);
	                $('#Instrucciones').prop('readonly', false);
	            } else {
	                $('#AlertaMsg').val('');
	                $('#Instrucciones').val('');
	            }
	        });
	    }

	    function addOrdenHandler() {
	        var year = Date.today().toString('yy');

	        $('#ITE_Nombre').mask('99-999-999-99', {
	            placeholder: year + '-___-___-__',
	            selectOnFocus: true,
	            onChange: function (_value) {

	                if ($('#OrdenId').val() == '' && _value.length == 6) {//only in new
	                    var numbers = _value.split('-');
	                    if (numbers.length >= 1) {
	                        $.when(getLatestOrderByClient(numbers[1])).done(function (json) {
	                            if (json.aaData && json.aaData.length > 0) {
	                                populateDialog(json.aaData[0], DIALOG_SELECTOR);
	                                numbers = json.aaData[0].ITE_Nombre.split('-');
	                                numbers[numbers.length - 1] = padDigits(parseInt(numbers[numbers.length - 1]) + 1, 2);
	                                $('#ITE_Nombre').val(numbers.join('-'));

	                                setDefaults();
	                            }
	                        });
	                    }
	                }
	            }
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br />
    <div class="catalog"></div>
    <div id="merge_orders_info" style="display:none;">
    </div>
    <div id="additional_info" style="display:none;">
        <h3 style="margin-top:2px;">Informacion Adicional</h3>
        <table  width="100%" cellspacing="0" cellpadding="2" class="ventas-detail">
            <tbody>
                <tr>
                    <td width="20%" valign="top">
                        <h3 style="margin-top:2px;font-size: 11px;">Popularidad por Numero de Parte</h3>
                        <table id="popularidad_numero_parte_table" width="100%" cellspacing="0" cellpadding="0" style="font-size:10px;">
                            <thead>
                                <tr>
                                    <th>Ordenes</th>
                                    <th>Piezas</th>
                                    <th>Stock</th>
                                    <th>Sugerida</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </td>
                    <td width="40%" rowspan="2" valign="top">
                        <h3 style="margin-top:2px;font-size: 11px;">Ordenes en Produccion por Numero de Parte</h3>
                        <table id="prod_orders_part_number_table" width="100%" cellspacing="0" cellpadding="0" style="font-size:10px;">
                            <thead>
                                <tr>
                                    <th>Orden</th>
                                    <th>Larco</th>
                                    <th>Cliente</th>
                                    <th>Disp.</th>
                                    <th>Tarea</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </td>
                    <td width="40%" rowspan="2" valign="top">
                        <h3 style="margin-top:2px;font-size: 11px;">Ordenes en produccion por Numero de Plano</h3>
                        <table id="prod_orders_plan_table" width="100%" cellspacing="0" cellpadding="0" style="font-size:10px;">
                            <thead>
                                <tr>
                                    <th>Orden</th>
                                    <th>Larco</th>
                                    <th>Cliente</th>
                                    <th>Disp.</th>
                                    <th>Tarea</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="20%" valign="top">
                        <h3 style="margin-top:2px;font-size: 11px;">Popularidad por Numero de Plano</h3>                        
                        <table id="popularidad_plano_table" width="100%" cellspacing="0" cellpadding="0" style="font-size:10px;">
                            <thead>
                                <tr>
                                    <th>Ordenes</th>
                                    <th>Piezas</th>
                                    <th>Stock</th>
                                    <th>Sugerida</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </td>

                </tr>
            </tbody>
        </table>
    </div>
</asp:Content>
