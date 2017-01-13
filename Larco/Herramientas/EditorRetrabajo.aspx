<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditorRetrabajo.aspx.cs" Inherits="BS.Larco.Herramientas.EditorRetrabajo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript">
        const PAGE_NAME = 'Scrap';
        const TABLE_SELECTOR = '#' + PAGE_NAME + '_table';
        const DIALOG_SELECTOR = '#' + PAGE_NAME + '_dialog';
        const BUTTONS_SELECTOR = TABLE_SELECTOR + '_wrapper_buttons button.disable';
        const TIPS_SELECTOR = DIALOG_SELECTOR + ' p.validateTips';

        $(document).ready(function () {
            LOGIN_NAME = '14'; //TODO: removed this line, is only for testing
            $('div.catalog').Page({
                source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
                dialogStyle: 'table',
                onLoadComplete: function (config) {
                    $('h2').text(config.Title);
                    document.title = config.Title;
                    initializeCatalog(config);
                }
            });
        });
	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
