<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="BS.Larco.Catalogos.Productos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        #TareasProductos_table input[type=checkbox]  {margin: 0px 4px 0px 4px; height: 13px;}        
        #TareasProductos_table input[type=text]  {margin: 0px 2px 0px 2px; height: 12px; padding:2px;}        
    </style>
    
    <script type="text/javascript">
	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=Productos',
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        createTasks();

	        $('#Productos_table').Catalog({
	            pageConfig: config,
	            showExport: true,
	            dialogWidth: 600,
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            },
	            newEntityCallBack: function (oTable, options) {
	                $('#Productos_table').Catalog('newEntity',oTable, options);
	                $('#TareasProductos_table').css('width', '100%').DataTable().columns.adjust().draw();
	                $('#TareasProductos_table input[type=checkbox]').prop('checked', false).attr('ProdTaskId', '');
	                $('#TareasProductos_table input[type=text]').val('').hide();
	            },
	            editEntityCallBack: function (oTable, options) {
	                $('#TareasProductos_table input[type=checkbox]').prop('checked', false).attr('ProdTaskId','');
	                $('#TareasProductos_table input[type=text]').val('').hide();

	                var data = getSelectedRowData(oTable);
	                $.when(getAggregatedValue(data)).done(function (json) {
	                    var tasks = json.aaData;
	                    var length = tasks.length;

	                    $('#TareasProductos_table input[type=text]').hide();
	                    for (var i = 0; i < length; i++) {
	                        $('#chkTask' + tasks[i].TaskId).prop('checked', true);
	                        $('#chkTask' + tasks[i].TaskId).attr('ProdTaskId', tasks[i].ProdTaskId);
	                        $('#txtAggreVal' + tasks[i].TaskId).val(tasks[i].Value);
	                        $('#txtAggreVal' + tasks[i].TaskId).show();
	                    }
	                });

	                $('#Productos_table').Catalog('editEntity', oTable, options);
	                $('#TareasProductos_table').css('width', '100%').DataTable().columns.adjust().draw();
	            },
	            deleteEntityCallBack: function (oTable, options) {
	                if (confirm('Are you sure you want to delete this Producto?') == false)
	                    return false;

	                var entity = getSelectedRowData(oTable);
	                var aggre = { Product_ID: entity.Id, OperationType: 'DeleteEntities', PageName: 'AggregateValue' };
	                var routing = { Nombre: entity.Nombre, OperationType: 'DeleteEntities', PageName: 'Routing' };
	                entity.OperationType = 'Delete';
	                entity.PageName = 'Productos';	                               

	                var entities = [];
	                entities.push(aggre);
	                entities.push(routing);
	                entities.push(entity);

	                $.ajax({
	                    type: "POST",
	                    url: AJAX_CONTROLER_URL + '/PageInfo/ExecuteTransaction',
	                    data: "entities=" + encodeURIComponent($.toJSON(entities))
	                }).done(function (json) {
	                    if (json.ErrorMsg == SUCCESS) {
	                        oTable.ajax.reload();
	                        $('#Productos_wrapper button.disable').button('disable');
	                    } else {
	                        alert(json.ErrorMsg);
	                    }
	                })
	            },
	            saveEntityCallBack: function (oTable, options) {
	                if ($('#Id').val() == '') {
	                    //new product
	                    saveNewProduct();


	                } else {
	                    //existing product update
	                    log('not implemented');
	                }
	            }
	        });
	    }

	    function saveNewProduct() {
            // TODO: validate, aggregate must be number
	        var checks = $('#TareasProductos_table input[type=checkbox]:checked');
	        if (checks.length == 1) {
	            alert('Al menos tienes que seleccionar dos tareas por las cuales va a pasar este producto.');
	            return false;
	        }

	        var product = { Id: $('#Id').val(), Nombre: $('#Nombre').val() };

	       

	        log(product);
	        log(getSaveNewEntities(product));
	    }

	    function getSaveNewEntities(product) {
	        var entities = [];
	        for (var i = 0; i < checks.length; i++) {
	            entities.push(getSaveAggregateEntity(product, $(checks[i]).attr('TaskId')));

	            if (i < (checks.length - 1)); {
	                entities.push(getSaveRoutingEntity(product, $(checks[i]).attr('TaskId'), $(checks[i + 1]).attr('TaskId')));
	            }
	        }

	        return entities;
	    }

	    function getSaveAggregateEntity(entity, _taskId) {
	        var _value = $('#txtAggreVal' + _taskId).val() || '1.0';

	        return { ProductId: entity.Id, TaskId: _taskId, Value: _value, OperationType: 'Save', PageName: 'AggregateValue' };
	    }

	    function getSaveRoutingEntity(entity, _fromTaskId, _toTaskId) {
	        return { Nombre: entity.Nombre, Rou_From: _fromTaskId, Rou_To: _toTaskId, Rou_Code: 'OK', OperationType: 'Save', PageName: 'Routing' };
	    }

	    function createTasks() {
	        $('#Productos_dialog #tabs-1').append('<div id="tareas_container"></div>');

	        $('#tareas_container').Page({
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=TareasProductos',
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {

	                var _columns = columnsDefinition(config);
	                _columns[0].bSortable = false;
	                _columns[1].bSortable = false;

	                $('#TareasProductos_table').Catalog({
	                    pageConfig: config,
	                    showNew: false,
	                    showEdit: false,
	                    showDelete: false,
	                    paginate: false,
	                    scrollY: '300px',
	                    sorting: [[0, 'asc']],
	                    columns: _columns,
	                    rowCallback: function (nRow, aData, iDisplayIndex) {
	                        var wrap = '<input type="checkbox" taskId="DATA" name="chkTaskDATA" id="chkTaskDATA" class="ui-widget-content ui-corner-all">';
	                        var aggre = '<input type="text" name="txtAggreValDATA" id="txtAggreValDATA" class="text ui-widget-content ui-corner-all">';
	                        jQuery('td:eq(' + getArrayIndexForKey(config.GridFields, 'ColumnName', 'TAS_Order') + ')', nRow).html(wrap.replace(/DATA/g, aData.Id));
	                        jQuery('td:eq(' + getArrayIndexForKey(config.GridFields, 'ColumnName', 'Id') + ')', nRow).html(aggre.replace(/DATA/g, aData.Id));

	                        return nRow;
	                    }, initCompleteCallBack: function () {
	                        var title = $('#TareasProductos_table').DataTable().column(0).header();
	                        $(title).html('');

                            //Show/Hide textbox for aggregated value
	                        $('#TareasProductos_table').delegate('input[type=checkbox]').on('click', function () {
	                            event.stopPropagation();

	                            var check = event.target;
	                            if (check) {
	                                $('#txtAggreVal' + $(check).attr('taskId')).hide();
	                                if ($(check).prop('checked')) {
	                                    $('#txtAggreVal' + $(check).attr('taskId')).show();
	                                }	                                
	                            }
	                            
	                        });
	                    }

	                });

	            }
	        });
	    }

	    function getAggregatedValue(_data) {
	        var entity = { ProductId: _data.Id };
	        return $.ajax({
	            url: AJAX + '/PageInfo/GetPageEntityList?pageName=AggregateValue&searchType=AND&entity=' + $.toJSON(entity),
	            dataType: 'json'
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
