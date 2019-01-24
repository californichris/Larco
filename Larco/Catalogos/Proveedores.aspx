<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Proveedores.aspx.cs" Inherits="BS.Larco.Catalogos.Proveedores" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    const PAGE_NAME = 'Provedores';
	    const TABLE_SEL = '#' + PAGE_NAME + '_table';

	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                if (config.Filter != null) $('div.catalog').before('<br/>');
	                document.title = config.Title;
	                initCatalog(config);
	            }
	        });
	    });

	    function initCatalog(config) {
	        $(TABLE_SEL).Catalog({
	            pageConfig: config, serverSide: true, showExport: true,
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            }
	        });
	    }
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
