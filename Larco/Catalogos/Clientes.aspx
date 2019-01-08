<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Clientes.aspx.cs" Inherits="BS.Larco.Catalogos.Clientes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=Clientes',
                dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                if (config.Filter != null) $('div.catalog').before('<br/>');
	                document.title = config.Title;
	                initCatalog(config);

	                $('#Clave').blur(function () {
	                    $('#Clave').val(padDigits($('#Clave').val(), 3));
	                });
	            }
	        });
	    });

	    function initCatalog(config) {
	        $('table.display').Catalog({
	            pageConfig: config, serverSide: true, showExport: true,
	            viewOnly: !EDIT_ACCESS, showEdit: true, dialogWidth: 800,
	            validate: function (tips) {
	                var valid = validateDialog(config, tips);
	                valid = valid && checkInt(tips, $('#Clave'),'Codigo');

	                return valid;
	            }
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
