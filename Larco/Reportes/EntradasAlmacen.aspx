<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EntradasAlmacen.aspx.cs" Inherits="BS.Larco.Reportes.EntradasAlmacen" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Styles/extra_widgets_css") %>
    <%: Scripts.Render("~/Scripts/extra_widgets_js") %>  
    <script type="text/javascript">
        const PAGE_NAME = 'EntradasAlmacen';
        const TABLE_SEL = '#' + PAGE_NAME + '_table'
        const FILTER_SEL = '#' + PAGE_NAME + '_filter';

        $(document).ready(function () {

            $('div.catalog').Page({
                source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
                onLoadComplete: function (config) {
                    $('h2').text(config.Title);
                    document.title = config.Title;
                    initializeCatalog(config);
                }
            });
        });

        function initializeCatalog(config) {
            $(TABLE_SEL).Catalog({
                serverSide: true,
                pageConfig: config,
                processing: true,
                paginate: true,
                //viewOnly:true,
                showEdit: false,
                showNew: false,
                showDelete: false,
                showExport: true,
                //scrollY: '600px',
                scrollX: '100%',
                scrollXInner: '120%',
            });
        }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br/>
    <div class="catalog"></div>
</asp:Content>
