<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MenuEditor.aspx.cs" Inherits="BS.Larco.Catalogos.MenuEditor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=Modules',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        $('table.display').Catalog({
	            pageConfig: config,
	            showExport: true,
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            },
	            sorting: [[getArrayIndexForKey(config.GridFields, 'ColumnName', 'ParentModuleText') || 3, 'asc'], [getArrayIndexForKey(config.GridFields, 'ColumnName', 'ModuleOrder') || 4, 'asc']]
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
