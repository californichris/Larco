<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Empleados.aspx.cs" Inherits="BS.Larco.Catalogos.Empleados" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=Empleados',
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
	        $('table.display').Catalog({
	            pageConfig: config, serverSide: true,
	            viewOnly: !EDIT_ACCESS, showEdit: true,
	            showExport: true, dialogWidth: 700,
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
