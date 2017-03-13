<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Preview.aspx.cs" Inherits="BS.Common.Preview" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Styles/multiselect_css") %>
    <%: Scripts.Render("~/Scripts/multiselect_js") %>
	<script type="text/javascript">
	    var PAGE_NAME = '<%= HttpUtility.HtmlEncode(Request.QueryString["pageName"]) %>';
	    $(document).ready(function () {
	        if (PAGE_NAME == '' || PAGE_NAME == null || !PAGE_NAME.match(/^\w+$/)) {
	            $('div.catalog').html('<b>Invalid page name.</b>');
	            return;
	        }

	        $('div.catalog').Page({
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
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
	            pageConfig: config,
	            showExport: true,
	            serverSide: true,
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
