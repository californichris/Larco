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
    $(TABLE_SEL).Catalog({
        pageConfig: config, serverSide: true, showExport: true, showReload : true,
        saveRequest: AJAX + '/PageInfo/SavePageEntity?pageName=' + PAGE_NAME,
        deleteRequest: AJAX + '/PageInfo/DeletePageEntity?pageName=' + PAGE_NAME,
        showNew: false, showEdit: false, showDelete: false,
        dialogWidth: 600, iDeferLoading: 0, 
        sorting: [[config.ColIdxs.TaskOrder, 'asc']],
        columnDefs: [{ targets: '_all', sortable: false }],
        rowCallback: _rowCallback,
        beforeServerDataCall: beforeServerDataCall,
        initCompleteCallBack: initComplete,        
    });
}

function _rowCallback(nRow, aData, iDisplayIndex, config) {
    jQuery('td:eq(' + config.ColIdxs.TaskStatus + ')', nRow).html(createStatusHTML(aData));
    jQuery('td:eq(' + config.ColIdxs.ITS_DTStart + ')', nRow).html(createInicioHTML(aData));
    jQuery('td:eq(' + config.ColIdxs.ITS_DTStop + ')', nRow).html(createFinalizoHTML(aData));
    jQuery('td:eq(' + config.ColIdxs.USE_Login + ')', nRow).html(createEmpleadoHTML(aData));
}

function beforeServerDataCall(filter) {
    var config = $(TABLE_SEL).Catalog('getCatalogOptions').pageConfig;
    var orden = filter.columns[config.ColIdxs.ITE_Nombre].search.value;
    if (orden == '') {
        filter.columns[config.ColIdxs.ITE_Nombre].search.value = 'xx-xxx-xxx-xx';
    }
}

function initComplete() {
    $(TABLE_SEL).DataTable().on('draw', function () {
        initTableSelectMenus();
        initTableDateTimePickers();
    });

    appendSaveButton();
    appendMsg();
}

function appendSaveButton() {
    var buttonOpts = { text: true, icons: { primary: 'ui-icon-disk' } };
    var btn = $('<button onclick="return false;" title="Save changes" id="saveChanges">Save</button>');
    btn.button(buttonOpts).click(saveClick);

    $(TABLE_SEL).Catalog('getButtonSection').append(btn);
}

function appendMsg() {
    $(TABLE_SEL).Catalog('getButtonSection').append('<p id="msg" class="validateTips ui-corner-all"></p>');
}

function initTableSelectMenus() {
    $(TABLE_SEL + ' .selectMenu').selectmenu();
    $.map($(TABLE_SEL + ' .selectMenu'), function (item) {
        $(item).selectmenu('menuWidget').addClass('select-menu-overflow');
    });

    $.map($(TABLE_SEL + ' .status'), function (item) {
        $(item).selectmenu({change: statusChange});
    });

    $.map($(TABLE_SEL + ' .user'), function (item) {
        $(item).selectmenu({ change: userChange });
    });
}

function initTableDateTimePickers() {
    var opts = $.page.getDateTimePickerOpts($('#ITE_NombreFilter'));//default opts
    opts.oneLine = 'true';
    opts.controlType = 'select';

    $.map($(TABLE_SEL + ' input.text'), function (item) {
        $.page._initDateTimePicker(item, opts);
    });    
}

function statusChange() {
    var currentDateTime = getCurrentDateTime('mm/dd/yy', 'hh:mm:ss');
    var current = getRowData($(this));
    setRowData(current, $(this).val(), currentDateTime);

    if (!$(this).val()) return;
    if (confirm('Quieres compleatar todas las tareas previas a esta?') == false) return false;
   
    var items = $(TABLE_SEL).DataTable().ajax.json().aaData;
    for (var i = 0; i < items.length; i++) {
        var item = items[i];
        if (current.ItemTaskId == item.ItemTaskId) break;
        setRowData(item, '2', currentDateTime) //Terminado
    }
}

function userChange() {
    var current = getRowData($(this));
    if (!$(this).val()) return;
    if (confirm('Quieres compleatar el empleado de todas las tareas previas a esta?') == false) return false;

    var user = $(this).val();
    var items = $(TABLE_SEL).DataTable().ajax.json().aaData;
    for (var i = 0; i < items.length; i++) {
        var item = items[i];
        if (current.ItemTaskId == item.ItemTaskId) break;
        var currentUser = $('#Item_User_' + item.ItemTaskId).val();
        if (_isNullOrEmpty(currentUser)) {
            $('#Item_User_' + item.ItemTaskId).selectmenu('setValue', user);
        }        
    }
}

function setRowData(item, status, currentDateTime) {    
    $('#Item_Status_' + item.ItemTaskId).selectmenu('setValue', status);
    var currentStart = $('#Item_Start_' + item.ItemTaskId).val();
    var currentStop = $('#Item_Stop_' + item.ItemTaskId).val();
    var currentUser = $('#Item_User_' + item.ItemTaskId).val();

    if (status == '') {        
        $('#Item_Start_' + item.ItemTaskId).val('');
        $('#Item_Stop_' + item.ItemTaskId).val('');
        $('#Item_User_' + item.ItemTaskId).selectmenu('setValue', '');
    } else if (status == '0' || status == '1') {
        $('#Item_Start_' + item.ItemTaskId).val(currentStart || currentDateTime);
        $('#Item_Stop_' + item.ItemTaskId).val('');
        $('#Item_User_' + item.ItemTaskId).selectmenu('setValue', currentUser || LOGIN_NAME);
    } else {
        $('#Item_Start_' + item.ItemTaskId).val(currentStart || currentDateTime);
        $('#Item_Stop_' + item.ItemTaskId).val(currentStop || currentDateTime);
        $('#Item_User_' + item.ItemTaskId).selectmenu('setValue', currentUser || LOGIN_NAME);
    }
}

function getRowData(ele) {
    var id = $(ele).attr('id');
    var row = $(ele).parentsUntil('tbody');

    var data = $(TABLE_SEL).DataTable().row(row).data();
    return data;
}

function saveClick() {
    var items = $(TABLE_SEL).DataTable().ajax.json().aaData;
    if (items == null || items.length <= 0) {
        alert('No hay registros que actualizar.');
        return;
    }

    var entities = getEntities();
    if (entities.length <= 0) return;
    $.when(executeTransaction(entities)).done(handleSaveResponse);    
}

function handleSaveResponse(json) {
    if (json.ErrorMsg == SUCCESS) {
        $(TABLE_SEL).Catalog('reloadTable');
    } else {
        showError($('#msg'), json.ErrorMsg);
    }
}

function getEntities() {
    var items = $(TABLE_SEL).DataTable().ajax.json().aaData;
    var entities = [];

    try {
        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (!validateItem(item)) throw 'Invalid Item';
            entities.push(createItemEntity(item));
        }
    } catch(err) {
        return [];
    }

    return entities;
}

function validateItem(item) {
    var valid = true, tips = $('#msg').text('').removeClass('ui-state-highlight').removeClass('ui-state-error');
    var status = $('#Item_Status_' + item.ItemTaskId).val();
    if (_isNullOrEmpty(status)) return true;

    valid = valid && checkRequired(tips, $('#Item_Start_' + item.ItemTaskId), 'Inicio');
    valid = valid && checkDate(tips, $('#Item_Start_' + item.ItemTaskId), 'Inicio');
    if (status == '2' || status == '9') {
        valid = valid && checkRequired(tips, $('#Item_Stop_' + item.ItemTaskId), 'Finalizo');
        valid = valid && checkDate(tips, $('#Item_Stop_' + item.ItemTaskId), 'Finalizo');
    }

    valid = valid && checkRequired(tips, $('#Item_User_' + item.ItemTaskId), 'Empleado');

    return valid;
}

function createItemEntity(item) {
    addSaveOperationAttrs(item, PAGE_NAME);
    var prevStatus = item.ITS_Status, status = $('#Item_Status_' + item.ItemTaskId).val();
    item.ITS_Status = status;
    item.ITS_DTStart = _isNullOrEmpty(status) ? '' : $('#Item_Start_' + item.ItemTaskId).val();
    item.ITS_DTStop = _isNullOrEmpty(status) ? '' : $('#Item_Stop_' + item.ItemTaskId).val();
    item.USE_Login = _isNullOrEmpty(status) ? '' : $('#Item_User_' + item.ItemTaskId).val();
    if (prevStatus != status) { //If status change reset values of Urgente and Vencida
        item.Urgente = item.Vencida = '0';
    } else { //if not change keep the same values
        item.Urgente = isTrue(item.Urgent) ? '1' : '0';
        item.Vencida = isTrue(item.Due) ? '1' : '0';
    }
    //TODO: item.ITS_Machine = MACHINE_IP;

    return item;
}

function createStatusHTML(aData) {
    var id = 'Item_Status_' + aData.ItemTaskId;
    var enable = '';
    var html = new StringBuffer();
    html.append('<select class="ui-widget-content ui-corner-all selectMenu status" style="width:120px;" name="').append(id);
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
    return createInputValHTML(id, true, aData.ITS_DTStart, '150');
}

function createFinalizoHTML(aData) {
    var id = 'Item_Stop_' + aData.ItemTaskId;
    return createInputValHTML(id, true, aData.ITS_DTStop, '150');
}

function createEmpleadoHTML(aData) {
    var id = 'Item_User_' + aData.ItemTaskId;
    var enable = '';
    var html = new StringBuffer();
    html.append('<select class="ui-widget-content ui-corner-all selectMenu user" name="').append(id);
    html.append('" id="').append(id).append('"');
    html.append(enable);
    html.append('>');
    html.append(createEmployeeOptions(aData));
    html.append('</select>');

    return html.toString();
}

function createEmployeeOptions(aData) {
    var ddInfo = { valField: 'Id', textField: 'NombreNumeroText', selectedVal: aData.USE_Login };
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