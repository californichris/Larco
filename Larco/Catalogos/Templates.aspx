<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Templates.aspx.cs" Inherits="BS.Larco.Catalogos.Templates" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="<%= Page.ResolveUrl("~/Scripts/tinymce/tinymce.min.js") %>"></script>
    <script type="text/javascript">
        const PAGE_NAME = 'Templates';
        const DIALOG = '#' + PAGE_NAME + '_dialog';
        const TABLE = '#' + PAGE_NAME + '_table';
        const TINYMCE_ELE = 'Template';

        $(document).ready(function () {
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

        $(document).on('focusin', function (e) {
            if ($(e.target).closest(".mce-window, .moxman-window").length) {
                e.stopImmediatePropagation();
            }
        });

        function initializeCatalog(config) {
            var catalog = $(TABLE).Catalog({
                pageConfig: config,
                showExport: true,
                dialogWidth: 1000,
                serverSide: true,
                saveRequest: AJAX + '/Larco/SaveTemplate?pageName=' + PAGE_NAME,
                newEntityCallBack: function (oTable, options) {
                    catalog.Catalog('newEntity', oTable, options);
                    tinymce.get(TINYMCE_ELE).setContent('');
                },
                editEntityCallBack: function (oTable, options) {
                    catalog.Catalog('editEntity', oTable, options);

                    var data = getSelectedRowData(oTable);
                    tinymce.get(TINYMCE_ELE).setContent(unescape(data[TINYMCE_ELE]));
                },
                saveEntityCallBack: function (oTable, options) {
                    var entity = getObject(DIALOG);
                    entity[TINYMCE_ELE] = escape(tinymce.get(TINYMCE_ELE).getContent());

                    catalog.Catalog('saveEntity', oTable, options, entity);
                },
                deleteEntityCallBack: function (oTable, options) {
                    if (confirm('Are you sure you want to delete this ' + $(options.dialogSelector).attr('originalTitle') + '?') == false)
                        return false;

                    var data = getSelectedRowData(oTable);
                    var entity = { NotId: data.TemplateId };

                    $.ajax({
                        type: 'POST',
                        url: options.deleteRequest,
                        data: 'entity=' + encodeURIComponent($.toJSON(entity))
                    }).done(function (json) {
                        if (json.ErrorMsg == SUCCESS) {
                            oTable.ajax.reload();
                            $('#' + PAGE_NAME + '_table_wrapper button.disable').button('disable');
                        } else {
                            alert(json.ErrorMsg);
                        }
                    });
                }
            });

            tinymce.init({
                selector: '#' + TINYMCE_ELE,
                height: 275,
                plugins: [
                            'link image anchor code preview table contextmenu textcolor print'
                ],
                menubar: false,
                toolbar_items_size: 'small',
                toolbar1: 'bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | styleselect formatselect fontselect fontsizeselect | cut copy paste | bullist numlist',
                toolbar2: 'undo redo | link unlink image code preview | forecolor backcolor | table | print'
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
