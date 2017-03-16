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
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
	            onFilterInitComplete: function(config) {
	                var clients = '010,060,062,162,699,799,862,899,999,960'.split(',');
	                var options = $('#ClientIdFilter option');

	                for (var i = 0; i < options.length; i++) {
	                    if (clients.indexOf($(options[i]).val()) == -1) {
	                        $(options[i]).attr('selected', 'selected');
	                    }
	                }

	                $.page.refreshMultiselect($('#ClientIdFilter'));

	                $('select.multiselect', $(FILTER_SEL)).multiselect({
	                    close: function () {
	                        $(FILTER_SEL).Filter('refresh');
	                    }
	                });

	            },
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
           
	        $(TABLE_SEL).Catalog({
                serverSide : true,
                pageConfig: config,
	            processing: true,
                paginate: true,
                //filter : false,
                //viewOnly:true,
	            showEdit: false,
	            showNew: false,
                showDelete:false,
                showExport: true,
                //scrollY: '600px',
                scrollX: '100%',
                scrollXInner: '200%',
                initCompleteCallBack: function () {
                    $(TABLE_SEL + '_processing').css('z-index', '10').css('color', 'black');

                    $(TABLE_SEL).on('draw.dt', function () {
                        //TODO: calculate totals
                        console.log('Redraw occurred at: ' + new Date().getTime());
                    });

                }
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br/>
    <div class="catalog"></div>
</asp:Content>
