<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Materiales.aspx.cs" Inherits="BS.Larco.Catalogos.Materiales" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    const PAGE_NAME = 'Materiales';
	    const TABLE_SELECTOR = '#' + PAGE_NAME + '_table';
	    const DIALOG_SELECTOR = '#' + PAGE_NAME + '_dialog';

	    $(document).ready(function () {
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
	        $(TABLE_SELECTOR).Catalog({
	            pageConfig: config,
	            serverSide: true,
	            showExport: true,
	            dialogWidth: 800,
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
