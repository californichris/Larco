const PAGE_NAME = 'Motivos_vw';
const TABLE_SEL = '#' + PAGE_NAME + '_table';
const DIALOG_SEL = '#' + PAGE_NAME + '_dialog';

const MOTIVOS_PAGE = 'Motivos';

$(document).ready(function () {
    $('div.catalog').Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
        dialogStyle: 'table',
        onLoadComplete: function (config) {
            $('h2').text(config.Title);
            if (config.Filter != null) $('div.catalog').before('<br/>');
            document.title = config.Title;
            initCatalog(config);
        }
    });
});

function initCatalog(config) {
    $(TABLE_SEL).Catalog({
        pageConfig: config, serverSide: true, showExport: true,
        saveRequest: AJAX + '/PageInfo/SavePageEntity?pageName=' + MOTIVOS_PAGE,
        deleteRequest: AJAX + '/PageInfo/DeletePageEntity?pageName=' + MOTIVOS_PAGE,
        viewOnly: !EDIT_ACCESS, showEdit: true, dialogWidth: 600,
        validate: function (tips) {
            return validateDialog(config, tips);
        },
        appendNextPrevButtons: true
    });
}