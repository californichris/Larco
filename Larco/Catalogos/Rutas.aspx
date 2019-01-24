<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Rutas.aspx.cs" Inherits="BS.Larco.Catalogos.Rutas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    const PAGE_NAME = 'Routing';
	    const TABLE_SEL = '#' + PAGE_NAME + '_table';

	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                if (config.Filter != null) $('div.catalog').before('<br/>');
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        $(TABLE_SEL).Catalog({
	            pageConfig: config, serverSide: true, showExport: true,
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            },
	            saveEntityCallBack: function (oTable, options) {
                    //TODO: removed this code when the Nombre column is deleted from table
	                var entity = getObject(options.dialogSelector);
	                entity.Nombre = $('#ProdId option:selected').text();

	                $(TABLE_SEL).Catalog('saveEntity', oTable, options, entity);
	            }
	        });
	    }
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
