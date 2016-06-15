<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rutas.aspx.cs" Inherits="BS.Larco.Catalogos.Rutas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    var PRODUCTS = [];
	    $.when($.getData('AjaxController.ashx/PageInfo/GetPageEntityList?pageName=Productos')).done(function (json) {
	        PRODUCTS = json.aaData;
	    });

	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=Routing',
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        var catalog = $('table.display').Catalog({
	            pageConfig: config,
	            serverSide: true,
	            showExport: true,
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            },
	            saveEntityCallBack: function (oTable, options) {
                    //TODO: removed this code when the Nombre column is deleted from table
	                var entity = getObject('#' + $(options.dialogSelector).attr('id'));

	                var arr = jQuery.grep(PRODUCTS, function (p) {
	                    return p.Nombre == entity.Nombre;
	                });

	                entity.ProductId = arr[0].Id;
	                catalog.Catalog('saveEntity', oTable, options, entity);
	            }
	        });
	    }
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
