<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Preview.aspx.cs" Inherits="BS.Common.Preview" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="<%= Page.ResolveUrl("~/Scripts/jquery.multiselect.js") %>"></script>
	<script type="text/javascript">
	    var PAGE_NAME = '<%= HttpUtility.HtmlEncode(Request.QueryString["pageName"]) %>';
	    $(document).ready(function () {
	        if (PAGE_NAME == '' || PAGE_NAME == null || !PAGE_NAME.match(/^\w+$/)) {
	            $('div.catalog').html('<b>Invalid page name.</b>');
	            return;
	        }

	        $('div.catalog').Page({
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
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
	            showExport: true
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
