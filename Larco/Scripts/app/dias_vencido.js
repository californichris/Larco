const PAGE_NAME = 'DiasVencido';
const TABLE_SEL = '#' + PAGE_NAME + '_table';
const DIALOG_SEL = '#' + PAGE_NAME + '_dialog';

const AGG_VAL_PAGE = 'AggregateValue';

$(document).ready(function () {
    $('div.catalog').Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
        dialogStyle: 'table',
        onLoadComplete: function (config) {
            $('h2').text(config.Title);
            document.title = config.Title;
            initializeCatalog(config);
        }
    });
});

function initializeCatalog(config) {
    $(TABLE_SEL).Catalog({
        pageConfig: config, serverSide: true, showExport: true,
        viewOnly: !EDIT_ACCESS, showEdit: true,
        columns: getColumns(config), sorting: getSorting(config),
        saveRequest: AJAX + '/PageInfo/SavePageEntity?pageName=' + AGG_VAL_PAGE,
        rowCallback: _rowCallback,
        editEntityCallBack: editEntity,
        deleteEntityCallBack: deleteEntity,
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
    log('editing entity');
    var entities = getSelectedEntities();
    if (entities.length <= 0) return;
    if (entities.length == 1) { //editing one record
        enableDialog(options.dialogSelector);
        $(options.dialogSelector).attr('multiple', 'false'); //TODO: check if this is necesary I can decide from the field if if contains LIST_
        $(TABLE_SEL).Catalog('editEntity', oTable, options, entities[0]);
    } else { //editing multiple records
        editMultipleEntities(oTable, options, entities);
    }
}

function deleteEntity(oTable, options) {
    log('delete Entity');
    var entities = getSelectedEntities();
    if (entities.length <= 0) return;
    if (entities.length == 1) { //deleting one record
        if (confirm('Are you sure you want to delete this ' + $(options.dialogSelector).attr('originalTitle') + '?') == false)
            return false;

        $(TABLE_SEL).Catalog('deleteEntity', oTable, options, entities[0]);
    } else { //editing multiple records
        if (confirm('Are you sure you want to delete the selected records(s)?') == false)
            return false;

        deleteMultipleEntities(oTable, options, entities);
    }
}

function saveEntity(oTable, options) {
    var fieldId = options.pageConfig.FieldId;
    var isMultiEdit = startsWith($('#' + fieldId).val(), 'LIST_');

    if (isMultiEdit) {
        var entities = getSelectedEntities();
        var whereEntity = encodeURIComponent($.toJSON(getWhereEntity(entities, options)));
        var entity = encodeURIComponent($.toJSON(getMultiEditEntity(options)));

        log(whereEntity);
        log(entity);

        $.ajax({
            type: 'POST',
            url: AJAX + '/PageInfo/UpdatePageEntity?pageName=' + AGG_VAL_PAGE + '&entity=' + entity + '&whereEntity=' + whereEntity
        }).done(handleSaveResponse);

    } else {
        $(TABLE_SEL).Catalog('saveEntity', oTable, options, getObject(DIALOG_SEL));
    }
}

function handleSaveResponse(json) {
    var options = $(TABLE_SEL).Catalog('getCatalogOptions');
    if (json.ErrorMsg == SUCCESS) {
        $(DIALOG_SEL).dialog('close');
        $(TABLE_SEL + '_wrapper button.disable').button('disable');
        $(TABLE_SEL).DataTable().ajax.reload(null, false);
    } else {
        showError($(DIALOG_SEL + ' p.validateTips'), json.ErrorMsg);
    }
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
    log(options);
    clearDialog(options.dialogSelector);
    populateMultipleDialog(entities, options);
    //this._setDefaultValues(options.pageConfig);
    var _dialog = $(options.dialogSelector).dialog();
    _dialog.dialog('option', 'title', _dialog.attr('originalTitle') + ' [Multiple Edit]').dialog('open');
    _dialog.attr('multiple', 'true');
    $('.ui-tabs', _dialog).tabs('option', 'active', 0);
    setFocusOnFirstDialogElement(options);

    //if (this.options.viewOnly) disableDialog('#' + this._dialog.attr('id'));
    //if (options.appendNextPrevButtons) this._toggleNextPrevButtons('enable');            
}

function deleteMultipleEntities(oTable, options, entities) {
    if (entities.length <= 1) return;// only multiple entities can be deleted

    var entities = getSelectedEntities();
    var entity = encodeURIComponent($.toJSON(getWhereEntity(entities, options)));
    //var entity = encodeURIComponent($.toJSON(getMultiEditEntity(options)));

    //log(whereEntity);
    log(entity);

    $.ajax({
        type: 'POST',
        url: AJAX + '/PageInfo/DeletePageEntities?pageName=' + AGG_VAL_PAGE + '&entity=' + entity
    }).done(handleDeleteResponse);
}

function handleDeleteResponse(json) {
    if (json.ErrorMsg == SUCCESS) {
        $(TABLE_SEL).Catalog('reloadTable');
        $(TABLE_SEL + '_wrapper button.disable').button('disable');
    } else {
        alert(json.ErrorMsg);
    }
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

    var nonMulti = disableNonMultiEditFields(options);
    log(nonMulti);
    for (var i = 0; i < entities.length; i++) {
        for (var e = 0; e < nonMulti.length; e++) {
            var ele = nonMulti[e];

            var fieldName = ele.attr('name') || ele.attr('id');
            var val = entities[i][fieldName];
            log(fieldName);
            log(val);
            if (ele.val() == val) continue;


            log('i = [' + i + ']');
            log(entities[i][fieldName]);
            if (i > 0 && ele.val() != val) {
                log('is diff setting val to empty');
                setElementVal(ele, '');
                continue;
            }

            log('is first setting val');
            setElementVal(ele, val);
        }
    }
    log(nonMulti);
}

function setElementVal(ele, value) {
    var fieldName = ele.attr('name') || ele.attr('id');
    log('set element val [' + fieldName + '] = [' + value + ']');
    if (ele.hasClass('selectMenu')) {
        ele.selectmenu('setValue', value);
    } else {
        ele.val(value);
    }
}

function disableNonMultiEditFields(options) {
    log('starting disableNonMultiEditFields');
    var dialog = $(options.dialogSelector);
    var elements = $('input:visible,select,textarea', dialog);
    var _nonMulti = [];
    for (var i = 0; i < elements.length; i++) {
        var ele = $(elements[i]);
        log(ele);
        if (ele.prop('edit-type') != 'multi') {
            _nonMulti.push(ele);
            disableElements('#' + ele.attr('id'), dialog);
        }
    }

    log('end disableNonMultiEditFields');
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
    //appendButtons();
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
    $('#editDiasVencido_table,#deleteDiasVencido_table').button(selected.length > 0 ? 'enable' : 'disable');

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
    var options = $(TABLE_SEL).Catalog('getCatalogOptions');
    var fieldId = options.pageConfig.FieldId;
    var isMultiEdit = startsWith($('#' + fieldId).val(), 'LIST_');
    var valid = true;

    if (isMultiEdit) {
        //TODO: validate multiple fields only
    } else {
        valid = validateDialog(options.pageConfig, tips);
    }

    return valid;
}