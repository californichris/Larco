const PAGE_VW_NAME = 'EditorOrdenes';
const TABLE_SEL = '#' + PAGE_VW_NAME + '_table';
const DIALOG_SEL = '#' + PAGE_VW_NAME + '_dialog';

const PAGE_NAME = 'ItemTasks';

var STATUS = [];
var EMPLOYEES = [];

$(document).ready(function () {
    $.when(getStatus(), getEmployees()).done(function (json, json2) {
        STATUS = normalizeResponse(json);
        EMPLOYEES = normalizeResponse(json2);
        log(STATUS);
        log(EMPLOYEES);
        initPage();
    });

});

function initPage() {
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
}

function initCatalog(config) {
    log(config);
    $(TABLE_SEL).Catalog({
        pageConfig: config, serverSide: true, showExport: true,
        saveRequest: AJAX + '/PageInfo/SavePageEntity?pageName=' + PAGE_NAME,
        deleteRequest: AJAX + '/PageInfo/DeletePageEntity?pageName=' + PAGE_NAME,
        showNew: false, showEdit: false, showDelete: false,
        dialogWidth: 600, iDeferLoading: 0, 
        sorting: [[config.ColIdxs.TaskOrder, 'asc']],
        columnDefs: [{ targets: '_all', sorting: false }],
        rowCallback: _rowCallback,
        //sorting: getSorting(config),
        //validate: validateEntity,
        //initCompleteCallBack: initComplete,
        //appendNextPrevButtons: true
    });
}

function _rowCallback(nRow, aData, iDisplayIndex, config) {
//    var config = $('div.catalog').Page('getConfig');
    jQuery('td:eq(' + config.ColIdxs.TaskStatus + ')', nRow).html(createStatusHTML(aData));
    jQuery('td:eq(' + config.ColIdxs.ITS_DTStart + ')', nRow).html(createInicioHTML(aData));
    jQuery('td:eq(' + config.ColIdxs.ITS_DTStop + ')', nRow).html(createFinalizoHTML(aData));
    jQuery('td:eq(' + config.ColIdxs.USE_Login + ')', nRow).html(createEmpleadoHTML(aData));
}

function createStatusHTML(aData) {
    var id = 'Item_Status_' + aData.ItemTaskId;
    var enable = '';
    var html = new StringBuffer();
    html.append('<select class="ui-widget-content ui-corner-all selectMenu" name="').append(id);
    html.append('" id="').append(id).append('"');
    html.append(enable);
    html.append('>');
    html.append(createStatusOptions(aData));
    html.append('</select>');

    return html.toString();
}

function createStatusOptions(aData) {
    var ddInfo = { valField: 'StatusId', textField: 'Status', selectedVal: aData.ITS_Status };
    var html = new StringBuffer();

    html.append('<option value=""');
    html.append('');
    html.append('></option>');

    for (var i = 0; i < STATUS.length; i++) {
        html.append($.page.createOptionHTML(STATUS[i], ddInfo));
    }

    html.append('</select>');

    return html.toString();
}

function createInicioHTML(aData) {
    var id = 'Item_Start_' + aData.ItemTaskId;
    return createInputValHTML(id, true, aData.ITS_DTStart, '200');
}

function createFinalizoHTML(aData) {
    var id = 'Item_Stop_' + aData.ItemTaskId;
    return createInputValHTML(id, true, aData.ITS_DTStop, '200');
}

function createEmpleadoHTML(aData) {
    var id = 'Item_User_' + aData.ItemTaskId;
    var enable = '';
    var html = new StringBuffer();
    html.append('<select class="ui-widget-content ui-corner-all selectMenu" name="').append(id);
    html.append('" id="').append(id).append('"');
    html.append(enable);
    html.append('>');
    html.append(createEmployeeOptions(aData));
    html.append('</select>');

    return html.toString();
}

function createEmployeeOptions(aData) {
    var ddInfo = { valField: 'Id', textField: 'NombreText', selectedVal: aData.USE_Login };
    var html = new StringBuffer();

    html.append('<option value=""');
    html.append('');
    html.append('></option>');

    for (var i = 0; i < EMPLOYEES.length; i++) {
        ddInfo.extraAttrs = isTrue(EMPLOYEES[i].Disabled) ? 'disabled' : '';
        html.append($.page.createOptionHTML(EMPLOYEES[i], ddInfo));
    }

    html.append('</select>');

    return html.toString();
}

function createInputValHTML(id, enable, val, width) {
    var html = new StringBuffer();
    html.append('<input type="text" class="text ui-widget-content ui-corner-all"');
    html.append(' name="').append(id).append('"');
    html.append(' id="').append(id).append('"');
    html.append(' value="').append(val).append('"');
    html.append(' style="width:').append(isUndefined(width) ? '100' : width).append('px;" ');
    html.append(enable);
    html.append('>');

    return html.toString();
}

function getStatus() {
    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=OrderStatus', cache: false
    });
}

function getEmployees() {
    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=Empleados_vw', cache: false
    });
}