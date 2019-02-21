const PAGE_NAME = 'DiasVencido';
const TABLE_SEL = '#' + PAGE_NAME + '_table';
const DIALOG_SEL = '#' + PAGE_NAME + '_dialog';

const AGG_VAL_PAGE = 'AggregateVal_VW';

$(document).ready(function () {
    $('div.catalog').Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
        dialogStyle: 'table',
        onBeforeCreateFilter: beforeCreateFilter,
        onLoadComplete: function (config) {
            $('h2').text(config.Title);
            document.title = config.Title;
            initializeCatalog(config);
        }
    });
});

function beforeCreateFilter(config) {
    var hash = config.FilterFielNameMap;
    if (hash['ProdIdFilter']) hash['ProdIdFilter'].ControlType = 'multiselect';
    if (hash['TaskIdFilter']) hash['TaskIdFilter'].ControlType = 'multiselect';
}

function initializeCatalog(config) {
    $(TABLE_SEL).Catalog({
        pageConfig: config, serverSide: true, showExport: true,
        viewOnly: !EDIT_ACCESS, showEdit: true,
        showNew: false, showDelete: false, displayLength: 50,
        columns: getColumns(config), sorting: getSorting(config),
        saveRequest: AJAX + '/PageInfo/SavePageEntity?pageName=' + AGG_VAL_PAGE,
        rowCallback: _rowCallback,
        editEntityCallBack: editEntity,
        saveEntityCallBack: saveEntity,
        initCompleteCallBack: initComplete,
        validate: validateEntity
    });
}

function getColumns(config) {
    var cols = columnsDefinition(config);
    cols[config.ColIdxs.ProdTaskId].sortable = false;
    cols[config.ColIdxs.ProdTaskId].title = createSelectAllCheck();
    cols[config.ColIdxs.ProdTaskId].visible = true;

    return cols;
}

function getSorting(config) {
    var sorting = [];
    sorting.push([config.ColIdxs.ProdNombre, 'asc']);
    sorting.push([config.ColIdxs.TareaNombre, 'asc']);

    return sorting;
}

function createSelectAllCheck() {
    var html = new StringBuffer();
    html.append('<input title="Toggle all checks" type="checkbox" id="checkAllRecords" class="records-check ui-widget-content ui-corner-all" ');
    html.append('>');

    return html.toString();
}

function _rowCallback(nRow, aData, iDisplayIndex, config) {
    $('td:eq(' + config.ColIdxs.ProdTaskId + ')', nRow).html(createCheck(aData));

    return nRow;
}

function createCheck(aData) {
    return _createCheck(aData, 'record_check_', 'ProdTaskId', 'record-check');
}

function editEntity(oTable, options) {
    var entities = getSelectedEntities();
    if (entities.length <= 0) return;

    disableNonMultiEditFields(options); //Always disable non-multi edit fields(prod, task)
    if (entities.length == 1) { //editing one record
        $(options.dialogSelector).attr('multiple', 'false'); //TODO: check if this is necesary I can decide from the field if if contains LIST_
        $(TABLE_SEL).Catalog('editEntity', oTable, options, entities[0]);
    } else { //editing multiple records
        editMultipleEntities(oTable, options, entities);
    }
}

function saveEntity(oTable, options) {
    if (!isMultiEdit()) {
        defaultSaveEntity(oTable, options);
        return false;
    }

    var entities = getSelectedEntities();
    var entity = getObject(DIALOG_SEL);
    for (var i = 0; i < entities.length; i++) {
        var _entity = addSaveOperationAttrs(entities[i], AGG_VAL_PAGE);
        //TODO: use multi-edit attribute to do it for any fields
        _entity.DiasVencido = entity.DiasVencido || _entity.DiasVencido;
        _entity.Puntos = entity.Puntos || _entity.Puntos;
        _entity.PuntosExtras = entity.PuntosExtras || _entity.PuntosExtras;
    }

    $.when(executeTransaction(entities)).done(handleSaveResponse);
}

function handleSaveResponse(json) {
    if (json.ErrorMsg == SUCCESS) {
        $(DIALOG_SEL).dialog('close');
        $(TABLE_SEL + '_wrapper button.disable').button('disable');
        $(TABLE_SEL).DataTable().ajax.reload(null, false);
    } else {
        showError(getTips(DIALOG_SEL), json.ErrorMsg);
    }
}

function defaultSaveEntity(oTable, options) {
    $(TABLE_SEL).Catalog('saveEntity', oTable, options);
}

function getMultiEditEntity(options) {
    var entity = getObject(DIALOG_SEL);
    var keys = Object.keys(entity);
    for (var i = 0; i < keys.length; i++) {
        log(keys[i]);
        log($('#' + keys[i]).attr('edit-type'));
        if ($('#' + keys[i]).attr('edit-type') != 'multi') {
            delete entity[keys[i]];
        }
    }

    return entity;
}

function getWhereEntity(entities, options) {
    var fieldId = options.pageConfig.FieldId;
    var whereEntity = {};
    whereEntity[fieldId] = 'LIST_' + getEntitiesIds(entities, options);

    return whereEntity;
}

function editMultipleEntities(oTable, options, entities) {
    if (entities.length <= 1) return;// only for more that one entities
    //log(options);

    clearDialog(options.dialogSelector);
    populateMultipleDialog(entities, options);

    var _dialog = $(options.dialogSelector).dialog();
    _dialog.dialog('option', 'title', _dialog.attr('originalTitle') + ' [Multiple Edit]').dialog('open');
    _dialog.attr('multiple', 'true');
    $('.ui-tabs', _dialog).tabs('option', 'active', 0);
    setFocusOnFirstDialogElement(options);

    //if (this.options.viewOnly) disableDialog('#' + this._dialog.attr('id'));
    //if (options.appendNextPrevButtons) this._toggleNextPrevButtons('enable');            
}

function setFocusOnFirstDialogElement(options) {
    var tab = $($('div.ui-tabs-panel', $(options.dialogSelector))[0]);
    var elements = $('input:visible:first, select, textarea:visible:first', tab);
    for (var i = 0; i < elements.length; i++) {
        var ele = elements[i];
        if ($(ele).prop('readonly') || $(ele).prop('disabled')) continue;
        if (ele.nodeName == 'INPUT' || ele.nodeName == 'TEXTAREA') {
            $(ele).focus();
            break;
        } else if (isSelectMenu(ele) && isSelectMenuEnable(ele)) {
            $(ele).selectmenu('widget').focus();
            break;
        }
    }
}

function isSelectMenu(ele) {
    return ele.nodeName == 'SELECT' && $(ele).hasClass('selectMenu');
}

function isSelectMenuEnable(ele) {
    var widget = $(ele).selectmenu('widget');
    return $(widget).is(':visible') && !$(widget).hasClass('ui-state-disabled');
}

function populateMultipleDialog(entities, options) {
    var fieldId = options.pageConfig.FieldId;
    $('#' + fieldId).val('LIST_' + getEntitiesIds(entities, options));

    var elments = $('input[type=text], select, textarea', $(DIALOG_SEL));
    for (var i = 0; i < entities.length; i++) {
        for (var e = 0; e < elments.length; e++) {
            var ele = $(elments[e]);

            var fieldName = ele.attr('name') || ele.attr('id');
            var val = entities[i][fieldName];

            if (ele.val() == val) continue;
            if (i > 0 && ele.val() != val) {
                setElementVal(ele, '');
                continue;
            }

            // is first setting val
            setElementVal(ele, val);
        }
    }
}

function setElementVal(ele, value) {
    var fieldName = ele.attr('name') || ele.attr('id');
    if (ele.hasClass('selectMenu')) {
        ele.selectmenu('setValue', value);
    } else {
        ele.val(value);
    }
}

function disableNonMultiEditFields(options) {
    var dialog = $(options.dialogSelector);
    var elements = $('input:visible,select,textarea', dialog);
    var _nonMulti = [];
    for (var i = 0; i < elements.length; i++) {
        var ele = $(elements[i]);
        if (ele.prop('edit-type') != 'multi') {
            _nonMulti.push(ele);
            disableElements('#' + ele.attr('id'), dialog);
        }
    }

    return _nonMulti;
}

function disableElements(selector, dialog) {
    if (!selector) return;
    var selectMenus = selector.replace(/,/g, '.selectMenu,') + '.selectMenu';
    $(selector, dialog).prop('disabled', true);
    $(selectMenus, dialog).selectmenu('disable');
}

function getEntitiesIds(entities, options) {
    var fieldId = options.pageConfig.FieldId;
    var ids = $.map(entities, function (item) { return item[fieldId] }).join(',');

    return ids;
}

function initComplete() {
    attachEventHandlers();
}

function attachEventHandlers() {
    $('#checkAllRecords').click(toggleAllRecords);
    $(TABLE_SEL + ' tbody').delegate('.record-check', 'click', checkClick);


    var oTable = $(TABLE_SEL).DataTable();
    oTable.off('click', 'tbody tr');
    oTable.off('dblclick', 'tbody tr');
    oTable.on('click', 'tbody tr', rowClick);
    oTable.on('dblclick', 'tbody tr', rowDbClick);
}

function rowClick() {
    var entities = getSelectedEntities();
    if (entities.length <= 1) {
        selectRow($(TABLE_SEL).DataTable(), this);
    }
}

function rowDbClick() {
    var entities = getSelectedEntities();
    if (entities.length <= 1) {
        var oTable = $(TABLE_SEL).DataTable();
        var options = $(TABLE_SEL).Catalog('getCatalogOptions');
        markRowAsSelected(oTable, this);
        if (getSelectedRowData(oTable)) {
            editEntity(oTable, options);
        }
    }
}

function markRowAsSelected(dataTable, row) {
    dataTable.$('tr.row_selected').removeClass('row_selected').removeClass('ui-state-active');
    $(row).addClass('row_selected').addClass('ui-state-active');
}

function toggleAllRecords() {
    $('input.record-check').prop('checked', $(this).is(':checked'));
    checkClick();
}

function checkClick() {
    event.stopPropagation();
    $(TABLE_SEL + '_wrapper button.disable').button('disable');
    $(TABLE_SEL + ' tr.row_selected').removeClass('row_selected').removeClass('ui-state-active');

    var selected = getSelectedEntities();
    log(selected);
    $('#editDiasVencido_table').button(selected.length > 0 ? 'enable' : 'disable');
}

function getSelectedEntities() {
    return _getSelectedEntities(TABLE_SEL, '#record_check_');
}

function _getSelectedEntities(tableSel, checkName) {
    var fieldId = _getFieldId(tableSel)
    var items = $(tableSel).DataTable().ajax.json().aaData;
    var entities = [];

    for (var i = 0; i < items.length; i++) {
        if ($(checkName + items[i][fieldId]).is(':checked')) {
            entities.push(items[i]);
        }
    }

    var entity = getSelectedRowData($(tableSel).DataTable());
    if (entity) entities.push(entity);

    return entities;
}

function _getFieldId(tableSel) {
    var options = $(tableSel).Catalog('getCatalogOptions');
    var fieldId = options.pageConfig ? options.pageConfig.FieldId : '';
    if (!fieldId) log('Error: FieldId not found in pageConfig.');

    return fieldId;
}

function validateEntity(tips) {
    var valid = true;
    if (isMultiEdit()) {
        if (!$('#DiasVencido').val() && !$('#Puntos').val() && !$('#PuntosExtras').val()) {
            updateTips(tips, 'Al menos uno es requerido (Dias de Vencido, Puntos o Puntos Extras).');
            valid = false;
        }

        valid = valid && checkInt(tips, $('#DiasVencido'), 'Dias de Vencido');
        valid = valid && checkFloat(tips, $('#Puntos'), 'Puntos');
        valid = valid && checkFloat(tips, $('#PuntosExtras'), 'Puntos Extras');

    } else {
        valid = validateDialog(getCtlgConfig(), tips);
    }

    return valid;
}

function getCtlgConfig(_selector) {
    var selector = _selector || TABLE_SEL;

    return getCtlgOpts(selector).pageConfig;
}

function getCtlgOpts(_selector) {
    var selector = _selector || TABLE_SEL;

    return $(selector).Catalog('getCatalogOptions');
}

function isMultiEdit() {
    var config = getCtlgConfig();
    var fieldId = config.FieldId;

    return startsWith($('#' + fieldId).val(), 'LIST_');
}