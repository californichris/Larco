const PAGE_NAME = 'Materiales';
const TABLE_SEL = '#' + PAGE_NAME + '_table';
const DIALOG_SEL = '#' + PAGE_NAME + '_dialog';

$(document).ready(function () {
    $('div.catalog').Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
        dialogStyle: 'table',
        onLoadComplete: function (config) {
            $('h2').text(config.Title);
            document.title = config.Title;
            initCatalog(config);
        },
        onBeforeCreateFilter: beforeCreateFilter
    });
});

function beforeCreateFilter(config) {
    var field = config.FilterFieldNameMap['ActivoFilter'];
    if (field) {
        field.ControlType = 'selectmenu';
        field.DropDownInfo = getCheckFlagJSON();
    }
}

function initCatalog(config) {
    $(TABLE_SEL).Catalog({
        pageConfig: config, serverSide: true,
        showExport: true, dialogWidth: 800,
        viewOnly: !EDIT_ACCESS, showEdit: true,
        newEntityCallBack: newEntity,
        appendNextPrevButtons: true,
        validate: function (tips) {
            return validateDialog(config, tips);
        }
    });
}

function newEntity(oTable, options) {
    $.when(getNextMaterialId()).done(function (json) {
        var id = ''
        if (json.aaData && json.aaData.length > 0) {
            id = json.aaData[0].NextMaterialId;
        }

        $(TABLE_SEL).Catalog('newEntity', oTable, options);
        $('#MAT_Numero').val(id + '-');
        $('#MAT_Numero').focus();
    });
}

function getNextMaterialId() {
    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=NextMaterialId', cache:false
    });
}