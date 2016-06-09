<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Empleados.aspx.cs" Inherits="BS.Larco.Catalogos.Empleados" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=Empleados',
	            dialogStyle: 'table',
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
	            serverSide: true,
	            showExport: true,
	            dialogWidth: 700,
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            },
	            rowCallback: function (nRow, aData, iDisplayIndex) {
	                var wrap = '<div style="white-space:nowrap;overflow:hidden;width:220px;" title="DATA">DATA</div>';
	                jQuery('td:eq(' + getArrayIndexForKey(config.GridFields, 'ColumnName', 'Nombre') + ')', nRow).html(wrap.replace(/DATA/g, aData.Nombre));
	                jQuery('td:eq(' + getArrayIndexForKey(config.GridFields, 'ColumnName', 'Departamento') + ')', nRow).html(wrap.replace(/DATA/g, aData.Departamento));
	                jQuery('td:eq(' + getArrayIndexForKey(config.GridFields, 'ColumnName', 'Puesto') + ')', nRow).html(wrap.replace(/DATA/g, aData.Puesto));

	                return nRow;
	            }
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
