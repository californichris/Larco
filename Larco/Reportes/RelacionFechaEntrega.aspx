<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RelacionFechaEntrega.aspx.cs" Inherits="BS.Larco.Reportes.RelacionFechaEntrega" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Styles/extra_widgets_css") %>
    <%: Scripts.Render("~/Scripts/extra_widgets_js") %>  
    <script type="text/javascript">
        const PAGE_NAME = 'FechaEntrega';
        const TABLE_SEL = '#' + PAGE_NAME + '_table'
        const FILTER_SEL = '#' + PAGE_NAME + '_filter';

	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
	            onBeforeCreateFilter: beforeCreateFilter,
	            onFilterInitComplete: filterInitComplete,
	            onLoadComplete: loadComplete
	        });
	    });

	    function beforeCreateFilter(config) {
	        var field = config.FilterFieldNameMap['ITS_StatusFilter'];
	        if (field) {
	            field.Label = '';
	        }
	    }

	    function loadComplete(config) {
	        $('h2').text(config.Title);
	        document.title = config.Title;
	        initCatalog(config);
	    }

	    function filterInitComplete(config) {
	        var options = $('#ClienteFilter option');
	        for (var i = 0; i < options.length; i++) {
	            if (NOT_SELECTED_CLIENTS.indexOf($(options[i]).val()) == -1) {
	                $(options[i]).attr('selected', 'selected');
	            }
	        }

	        $.page.refreshMultiselect($('#ClienteFilter'));
	    }

	    function initCatalog(config) {
	        $(TABLE_SEL).Catalog({
                serverSide : true, pageConfig: config,
	            processing: true, paginate: true,
                showExport: true, 
                //scrollY: '600px',
                scrollX: '100%',
                scrollXInner: '150%',
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br/>
    <div class="catalog"></div>
</asp:Content>
