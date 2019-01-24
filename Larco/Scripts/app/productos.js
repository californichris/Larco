const PAGE_NAME = 'Productos';
const TABLE_SEL = '#' + PAGE_NAME + '_table';
const DIALOG_SEL = '#' + PAGE_NAME + '_dialog';

const TASK_PRODS_PAGE = 'TareasProductos';
const TASK_PRODS_CONTAINER = '#' + TASK_PRODS_PAGE + '_container';
const TASK_PRODS_TABLE = '#' + TASK_PRODS_PAGE + '_table';

const AGGRE_VAL_PAGE = 'AggregateVal_VW';
const ROUTING_PAGE = 'Routing';

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
    createTasks();

    $(TABLE_SEL).Catalog({
        pageConfig: config, showExport: true, dialogWidth: 600,
        viewOnly: !EDIT_ACCESS, showEdit: true,
        validate: validateEntity,
        rowCallback: _rowCallback,
        newEntityCallBack: newEntity,
        editEntityCallBack: editEntity,
        deleteEntityCallBack: deleteEntity,
        saveEntityCallBack: saveEntity,
        appendNextPrevButtons: true
    });
}

function validateEntity(tips) {
    var config = $(TABLE_SEL).Catalog('getCatalogOptions').pageConfig;
    var valid = validateDialog(config, tips);

    var checks = $(TASK_PRODS_TABLE + ' input[type=checkbox]:checked');
    if (checks.length == 1) {
        tips.text('Al menos tienes que seleccionar dos tareas por las cuales va a pasar este producto.').addClass('ui-state-highlight');
        valid = false;
    }

    return valid;
}

function _rowCallback(nRow, aData, iDisplayIndex, config) {
    $('td:eq(' + config.ColIdxs.Activo + ')', nRow).html(isTrue(aData.Activo) ? 'Si' : 'No');
    
    return nRow;
}

function newEntity(oTable, options) {
    $(TABLE_SEL).Catalog('newEntity', oTable, options);
    $(TASK_PRODS_TABLE).css('width', '100%').DataTable().columns.adjust().draw();
    $(TASK_PRODS_TABLE + ' input[type=checkbox]').prop('checked', false);
}

function editEntity(oTable, options) {
    $(TASK_PRODS_TABLE + ' input[type=checkbox]').prop('checked', false);

    var data = getSelectedRowData(oTable);
    $.when(getRouting(data)).done(function (json) {
        var tasks = json.aaData;
        for (var i = 0; i < tasks.length; i++) {
            $('#chkTask' + tasks[i].TaskId).prop('checked', true);
        }
    });

    $(TABLE_SEL).Catalog('editEntity', oTable, options);
    $(TASK_PRODS_TABLE).css('width', '100%').DataTable().columns.adjust().draw();
}

function deleteEntity(oTable, options) {
    if (confirm('Estas seguro que quieres borrar este producto?') == false)
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

function getDeleteEntities(entity) {    
    var aggre = { ProdId: entity.ProdId, OperationType: 'DeleteEntities', PageName: AGGRE_VAL_PAGE };
    var routing = { ProdId: entity.ProdId, OperationType: 'DeleteEntities', PageName: ROUTING_PAGE };
    entity.OperationType = 'Delete';
    entity.PageName = PAGE_NAME;

    var entities = [];
    entities.push(routing);
    entities.push(aggre);
    entities.push(entity);

    return entities;
}

function saveEntity(oTable, options) {
    if ($('#ProdId').val() == '') {
        saveNewProduct();//new product
    } else {
        editProduct();//existing product update
    }
}

function saveNewProduct() {
    var entity = getProdEntity();

    var entities = [];
    entities.push(addSaveOperationAttrs(entity, 'Productos_VW'));
    appendRoutesEntities(entities, entity);
    appendAggreValEntities(entities, entity);

    log(entities);

    $.when(executeTransaction(entities)).done(handleSaveResponse);
}

function editProduct() {
    var entity = getProdEntity();
    var whereEntity = { ProdId: entity.ProdId };

    var items = { PRO_Nombre: entity.Nombre };
    items.WhereEntity = $.toJSON(whereEntity);
    addUpdateOperationAttrs(items, 'Items');

    var planos = { PN_Descripcion: entity.Nombre.toUpperCase() };
    planos.WhereEntity = $.toJSON(whereEntity);
    addUpdateOperationAttrs(planos, 'Planos');

    var ordenes = { Producto: entity.Nombre };
    ordenes.WhereEntity = $.toJSON(whereEntity);
    addUpdateOperationAttrs(ordenes, 'ValidateOrden');

    var entities = [];
    entities.push(items);
    entities.push(planos);
    entities.push(ordenes);
    entities.push(addSaveOperationAttrs(entity, 'Productos_VW'));
    appendRoutesEntities(entities, entity);

    log(entities);

    $.when(executeTransaction(entities)).done(handleSaveResponse);
}

function handleSaveResponse(json) {
    if (json.ErrorMsg == SUCCESS) {
        $(DIALOG_SEL).dialog('close');
        $(TABLE_SEL).Catalog('reloadTable');
        $(TABLE_SEL + '_wrapper button.disable').button('disable');
    } else {
        showError($(DIALOG_SEL + ' p.validateTips'), 'No fue posible grabar el producto.');
    }
}

function getProdEntity() {
    var entity = getObject(DIALOG_SEL + ' table:first');
    entity.ProdId = $('#ProdId').val();

    return entity;
}

function appendRoutesEntities(entities, entity) {
    if (entity.ProdId) {
        var deleteEntity = { ProdId: entity.ProdId };
        entities.push(addDeleteEntitiesOperationAttrs(deleteEntity, ROUTING_PAGE));
    }

    var checks = $(TASK_PRODS_TABLE + ' input[type=checkbox]:checked');
    for (var i = 0; i < checks.length; i++) {
        if (i < (checks.length - 1)) {
            entities.push(getSaveRoutingEntity(entity, $(checks[i]).attr('TaskId'), $(checks[i + 1]).attr('TaskId')));
        }
    }
}

function appendAggreValEntities(entities, entity) {
    var tasks = $(TASK_PRODS_TABLE).DataTable().ajax.json().aaData;
    for (var i = 0; i < tasks.length; i++) {        
        entities.push(getSaveAggreValEntity(entity, tasks[i].Id));
    }
}


function getSaveRoutingEntity(entity, _fromTaskId, _toTaskId) {
    return { ProdId: entity.ProdId, Nombre: entity.Nombre, Rou_From: _fromTaskId, Rou_To: _toTaskId, Rou_Code: 'OK', OperationType: 'Save', PageName: ROUTING_PAGE };
}

function getSaveAggreValEntity(entity, taskId) {
    return { ProdTaskId: '', ProdId: entity.ProdId, TaskId: taskId, Value: 1, OperationType: 'Save', PageName: AGGRE_VAL_PAGE };
}

function createTasks() {
    $(DIALOG_SEL + ' #tabs-1').append('<div id="' + TASK_PRODS_PAGE + '_container"></div>');

    var entity = { Activo : 1 };

    $(TASK_PRODS_CONTAINER).Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + TASK_PRODS_PAGE + '&entity=' + $.toJSON(entity),
        dialogStyle: 'table',
        onLoadComplete: tasksLoadComplete
    });
}

function tasksLoadComplete(config) {
    var _columns = columnsDefinition(config);
    _columns[config.ColIdxs.TAS_Order].bSortable = false;
    _columns[config.ColIdxs.Nombre].bSortable = false;

    $(TASK_PRODS_TABLE).Catalog({
        pageConfig: config, paginate: false, scrollY: '300px', filter: false,
        showNew: false, showEdit: false, showDelete: false,        
        sorting: [[config.ColIdxs.TAS_Order, 'asc']],
        columns: _columns,        
        rowCallback: tasksRowCallback,
        initCompleteCallBack: tasksInitComplete
    });
}

function tasksRowCallback(nRow, aData, iDisplayIndex, config) {
    //TODO: change .Id to .TaskId
    var wrap = '<input type="checkbox" taskId="DATA" name="chkTaskDATA" id="chkTaskDATA" ProdTaskId="" class="ui-widget-content ui-corner-all">';

    jQuery('td:eq(' + config.ColIdxs.TAS_Order + ')', nRow).html(wrap.replace(/DATA/g, aData.Id));

    return nRow;
}

function tasksInitComplete() {
    var title = $(TASK_PRODS_TABLE).DataTable().column(0).header();
    $(title).html('');
}

function getRouting(_data) {
    var entity = { ProdId: _data.ProdId };

    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=RoutingVW&searchType=AND&entity=' + $.toJSON(entity),
        cache: false
    });
}