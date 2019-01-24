const PAGE_NAME = 'Tareas';
const TABLE_SEL = '#' + PAGE_NAME + '_table';
const DIALOG_SEL = '#' + PAGE_NAME + '_dialog';

const AGGRE_VAL_PAGE = 'AggregateVal_VW';
const ROUTING_PAGE = 'Routing';
const MONITOR_PAGE = 'Monitor';
const PRODS_PAGE = 'Productos';

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
        pageConfig: config, showExport: true, dialogWidth: 600,
        viewOnly: !EDIT_ACCESS, showEdit: true,
        validate: validateEntity,
        rowCallback: _rowCallback,
        newEntityCallBack: newEntity,
        deleteEntityCallBack: deleteEntity,
        saveEntityCallBack: saveEntity,
        initCompleteCallBack: appendUpDownButtons
    });
}

function validateEntity(tips) {
    var config = $(TABLE_SEL).Catalog('getCatalogOptions').pageConfig;

    return validateDialog(config, tips);
}

function _rowCallback(nRow, aData, iDisplayIndex, config) {
    $('td:eq(' + config.ColIdxs.Activo + ')', nRow).html(isTrue(aData.Activo) ? 'Si' : 'No');
    $('td:eq(' + config.ColIdxs.IsPutOnly + ')', nRow).html(isTrue(aData.IsPutOnly) ? 'Si' : 'No');
    $('td:eq(' + config.ColIdxs.IsLast + ')', nRow).html(isTrue(aData.IsLast) ? 'Si' : 'No');

    return nRow;
}

function newEntity(oTable, options) {
    $(TABLE_SEL).Catalog('newEntity', oTable, options);
    var list = getSortedList(oTable);

    if (list.length > 0) {
        $('#TaskOrder').val(parseInt(list[list.length - 1].TaskOrder) + 1);
    } else {
        $('#TaskOrder').val('1');
    }
}

function deleteEntity(oTable, options) {
    if (confirm('Estas seguro que quieres borrar esta tarea?') == false)
        return false;

    var entity = getSelectedRowData(oTable);
    $.when(executeTransaction(getDeleteEntities(entity))).done(function (json) {
        if (json.ErrorMsg == SUCCESS) {
            $(TABLE_SEL).Catalog('reloadTable');
            $(TABLE_SEL + '_wrapper button.disable').button('disable');
        } else {
            alert(json.ErrorMsg);
        }
    });
}

function saveEntity(oTable, options) {
    if ($('#TaskId').val() == '') {
        saveNewTask();
    } else {
        editTask();
    }
}

function saveNewTask() {
    var entity = getObject(DIALOG_SEL);
    var monitor = { MType: 'Task', MName: entity.Nombre, MValue: '50,50' };

    var entities = [];
    entities.push(addSaveOperationAttrs(entity, 'Tareas_VW')); //Using the view so field Id is translated to TaskId
    entities.push(addSaveOperationAttrs(monitor, MONITOR_PAGE));
    $.when(getProds()).done(function (json) {
        var prods = json.aaData;
        for (var i = 0; i < prods.length; i++) {
            entities.push(getSaveAggreValEntity(entity, prods[i].ProdId));
        }

        //Find another way to insert all products to aggregate table because when more products are added to the system 
        // the limit parameters will be reach only supports a maximum of 2100 parameters.
        $.when(executeTransaction(entities)).done(handleSaveResponse);
    });
}

function getSaveAggreValEntity(entity, prodId) {
    return { ProdTaskId: '', ProdId: prodId, TaskId: entity.TaskId, Value: 1, OperationType: 'Save', PageName: AGGRE_VAL_PAGE };
}

function editTask() {
    var prev = getSelectedRowData($(TABLE_SEL).DataTable());
    var entity = getObject(DIALOG_SEL);
    var where = { MType: 'Task', MName: prev.Nombre };
    var monitor = { MName: entity.Nombre, WhereEntity: $.toJSON(where) };

    var entities = [];
    entities.push(addSaveOperationAttrs(entity, PAGE_NAME));
    entities.push(addUpdateOperationAttrs(monitor, MONITOR_PAGE));

    $.when(executeTransaction(entities)).done(handleSaveResponse);
}

function handleSaveResponse(json) {
    if (json.ErrorMsg == SUCCESS) {
        $(DIALOG_SEL).dialog('close');
        $(TABLE_SEL).Catalog('reloadTable');
        $(TABLE_SEL + '_wrapper button.disable').button('disable');
    } else {
        showError($(DIALOG_SEL + ' p.validateTips'), 'No fue posible grabar la tarea.');
    }
}

function getNewTaskEntities(entity) {
    var optType = OPERATION_TYPES.DELETE_ENTITIES;
    var routing = { TaskId: entity.TaskId, OperationType: optType, PageName: ROUTING_PAGE };
    var monitor = { MName: entity.Nombre, OperationType: optType, PageName: MONITOR_PAGE };
    var aggre = { TaskId: entity.TaskId, OperationType: optType, PageName: AGGRE_VAL_PAGE };

    var entities = [];
    entities.push(routing);
    entities.push(monitor);
    entities.push(aggre);
    entities.push(addDeleteOperationAttrs(entity, PAGE_NAME));

    return entities;
}

function getDeleteEntities(entity) {
    var routing1 = { Rou_From: entity.TaskId, OperationType: 'DeleteEntities', PageName: ROUTING_PAGE };
    var routing2 = { Rou_To: entity.TaskId, OperationType: 'DeleteEntities', PageName: ROUTING_PAGE };
    var monitor = { MName: entity.Nombre, OperationType: 'DeleteEntities', PageName: MONITOR_PAGE };
    var aggre = { TaskId: entity.TaskId, OperationType: 'DeleteEntities', PageName: AGGRE_VAL_PAGE };

    var entities = [];
    entities.push(routing1);
    entities.push(routing2);
    entities.push(monitor);
    entities.push(aggre);
    entities.push(addDeleteOperationAttrs(entity, PAGE_NAME));

    return entities;
}

function appendUpDownButtons(oTable, oSettings, json, options) {
    var upbtn = $('<button class="disable" onclick="return false;" title="Mover tarea hacia arriba en el orden.">Mover Arriba</button>');
    var upbtnOpts = { text: options.showText, icons : { primary: 'ui-icon-triangle-1-n' } };
    upbtn.button(upbtnOpts).click(upClick).button('disable');

    var downbtn = $('<button class="disable" onclick="return false;" title="Mover tarea hacia abajo en el orden.">Mover Abajo</button>');
    var downbtnOpts = { text: options.showText, icons : { primary: 'ui-icon-triangle-1-s' } };
    downbtn.button(downbtnOpts).click(downClick).button('disable');

    $('#Tareas_table').Catalog('getButtonSection').append(upbtn).append(downbtn);
}

function upClick() {
    var oTable = $(TABLE_SEL).DataTable();
    var data = getSelectedRowData(oTable);
    var list = getSortedList(oTable);

    var index = indexOfArray(list, 'TaskId', data.TaskId);
    if (index == 0) return; //Is first in the list do nothing
    var prev = list[index - 1];

    switchOrder(data, prev);
    executeTrans(data, prev, oTable);
}

function downClick() {
    var oTable = $(TABLE_SEL).DataTable();
    var data = getSelectedRowData(oTable);
    var list = getSortedList(oTable);

    var index = indexOfArray(list, 'TaskId', data.TaskId);
    if (index == list.length - 1) return; //is the last of the list do nothing
    var next = list[index + 1];

    switchOrder(data, next);
    executeTrans(data, next, oTable);

}

function getSortedList(oTable) {
    var _json = oTable.ajax.json();
    var list = _json.aaData;
    list.sort(function (a, b) {
        return $.page.sortItems(a, b, { sortField: 'TaskOrder', sortType: 'INT', sortDir: 'ASC' });
    });

    return list;
}

function switchOrder(task1, task2) {
    var currentOrder = task1.TaskOrder;
    task1.TaskOrder = task2.TaskOrder;
    task2.TaskOrder = currentOrder;
}

function executeTrans(task1, task2, oTable) {
    var entities = [];

    task1.PageName = 'Tareas';
    task1.OperationType = 'Save';

    task2.PageName = 'Tareas';
    task2.OperationType = 'Save';

    entities.push(task1);
    entities.push(task2);

    $.when(executeTransaction(entities)).done(function (json) {
        if (json.ErrorMsg == SUCCESS) {
            //reload dialog table
            oTable.ajax.reload();
        } else {
            alert('Ocurrio un error al mover el orden de la tarea.');
        }
    });
}

function indexOfArray(array, key, val) {
    var length = array.length;
    for (var i = 0; i < array.length; i++) {
        var item = array[i];
        if (item[key] == val) {
            return i;
        }
    }

    return -1;
}

function getProds() {
    return $.getData(AJAX + '/PageInfo/GetPageEntityList?pageName=' + PRODS_PAGE);
}