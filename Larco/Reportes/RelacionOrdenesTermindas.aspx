<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RelacionOrdenesTermindas.aspx.cs" Inherits="BS.Larco.Reportes.RelacionOrdenesTermindas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    var PAGE_NAME = 'RelacionOrdenesTermindas_vw';
	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
                dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                if (config.Filter != null) $('div.catalog').before('<br/>')
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        $('table.display').Catalog({
	            pageConfig: config, showExport: true, serverSide: true,
	            scrollX: '100%', scrollXInner: '150%'
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
