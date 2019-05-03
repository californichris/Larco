const PAGE_VW_NAME = 'Retrabajo_vw';
const TABLE_SEL = '#' + PAGE_VW_NAME + '_table';
const DIALOG_SEL = '#' + PAGE_VW_NAME + '_dialog';
const BUTTONS_SEL = PAGE_VW_NAME + '_wrapper_buttons button.disable';

const PAGE_NAME = 'Retrabajo';

$(document).ready(function () {
    $('div.catalog').Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_VW_NAME,
        dialogStyle: 'table',
        onLoadComplete: function (config) {
            $('h2').text(config.Title);
            document.title = config.Title;
            initCatalog(config);

            maskITENombre('#ITE_NombreFilter', {});
        }
    });
});

function initCatalog(config) {
    $(TABLE_SEL).Catalog({
        pageConfig: config, serverSide: true, showExport: true,
        saveRequest: AJAX + '/PageInfo/SavePageEntity?pageName=' + PAGE_NAME,
        deleteRequest: AJAX + '/PageInfo/DeletePageEntity?pageName=' + PAGE_NAME,
        viewOnly: !EDIT_ACCESS, showEdit: true, dialogWidth: 600,
        sorting: getSorting(config),
        validate: validateEntity,
        initCompleteCallBack: initComplete,
        appendNextPrevButtons: true
    });
}

function validateEntity(tips) {
    var valid = true;

    valid = validateDialog(getCtlgConfig(), tips);

    return valid;
}

function initComplete() {
    maskITENombre('#ITE_Nombre', {});
    $('#ITE_NombreFilter').prop('disabled', false);
    $('#RET_Empleado option:first').text('0000 - Desconocido');
    $('#RET_Empleado').selectmenu('refresh');

    $('#RET_EmpleadoDetectado option:first').text('0000 - Desconocido');
    $('#RET_EmpleadoDetectado').selectmenu('refresh');
}

function getSorting(config) {
    var sorting = [];
    sorting.push([config.ColIdxs.RET_Start, 'desc']);

    return sorting;
}