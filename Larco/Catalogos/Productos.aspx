<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="BS.Larco.Catalogos.Productos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        #TareasProductos_table input[type=checkbox]  {margin: 0px 3px 0px 3px; height: 13px;}        
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
	                var title = oTable.column(0).header();
	            },
	            editEntityCallBack: function (oTable, options) {
	                $('#Productos_table').Catalog('editEntity',oTable, options);
	                $('#TareasProductos_table').css('width', '100%').DataTable().columns.adjust().draw();
	            }
	        });
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
	                        var wrap = '<input type="checkbox" name="chkTaskDATA" id="chkTaskDATA" class="ui-widget-content ui-corner-all">';
	                        jQuery('td:eq(' + getArrayIndexForKey(config.GridFields, 'ColumnName', 'TAS_Order') + ')', nRow).html(wrap.replace(/DATA/g, aData.Id));

	                        return nRow;
	                    }

	                });

	            }
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
