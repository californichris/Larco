const TYPE = {};
TYPE.PROD = 'PROD';
TYPE.STOCK = 'STOCK';
TYPE.MERGE = 'MERGE';
TYPE.PARTIAL = 'PARTIAL';

const NOT_SELECTED_CLIENTS = '010,012,060,062,162,699,799,862,899,912,999,960'.split(',');

function getCheckFlagJSON() {
    return $.toJSON({ url: 'AjaxController.ashx/PageInfo/GetPageEntityList?pageName=PageListItem&entity={"FieldName":"CheckFlag"}', valField: 'Value', textField: 'Text', cache: true });
}

function getConfig() {
    return _getConfig(PAGE_NAME);
}

function _getConfig(pageName) {
    return $.getData(AJAX + '/PageInfo/GetPageConfig?pageName=' + pageName);
}

function _createCheck(aData, idPrefix, fieldId, _clazz) {
    var id = idPrefix + aData[fieldId];

    var html = new StringBuffer();
    html.append('<input ').append(fieldId).append('="').append(aData[fieldId]);
    html.append('" type="checkbox" id="').append(id);
    html.append('" class="').append(_clazz).append(' dialog-check ui-widget-content ui-corner-all" ');
    html.append('>');

    return html.toString();
}

function getOrdenType(entity) {
    if (isTrue(entity.Stock)) {
        return TYPE.STOCK;
    } else if (isTrue(entity.Mezclado)) {
        return TYPE.MERGE;
    } else if (isTrue(entity.StockParcial)) {
        return TYPE.PARTIAL;
    } else {
        return TYPE.PROD;
    }
}

function getTasksByProductId(_productId) {
    var entity = { ProductId: _productId };
    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=RoutingVW&entity=' + $.toJSON(entity),
        dataType: 'json'
    });
}

function getItemTasks(_ITE_Nombre) {
    var entity = { ITE_Nombre: _ITE_Nombre };
    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=ItemTasks&entity=' + $.toJSON(entity),
        dataType: 'json'
    });
}

function getSaveItemsEntity(data) {
    var item = getItemsEntity(data);
    return addTransAttrs(item, 'Save', 'Items');
}

function getItemsEntity(data) {
    var entity = {};
    entity.ITE_ID = data.ITE_ID;
    entity.ITE_Nombre = data.ITE_Nombre;
    entity.PRO_Nombre = data.Producto;
    entity.ProductId = data.ProductId;

    return entity;
}

function executeTransaction(entities) {
    return $.ajax({
        type: 'POST',
        url: AJAX + '/PageInfo/ExecuteTransaction',
        data: 'entities=' + encodeURIComponent($.toJSON(entities))
    });
}

function getItemTasksEntity(data, task) {
    var entity = {};
    entity.ITE_Id = data.ITE_ID;
    entity.ITE_Nombre = data.ITE_Nombre;
    entity.ITS_DTStart = 'NULL';
    entity.ITS_DTStop = 'NULL';
    entity.ITS_Machine = 'NULL';
    entity.ITS_Status = 'NULL';
    entity.TAS_Id = task.TaskId;
    entity.USE_Login = 'NULL';

    return entity;
}

function getProdOrdenEntities(entity, tasks) {
    var entities = [];
    entities.push(getSaveItemsEntity(entity));

    if (isTrue(entity.StockParcial)) {
        entities.push(getSaveStockParcialEntity(entity));
    }

    entities.push(entity);
    addItemTasks(entities, entity, tasks);

    return entities;
}

function getDeleteOrdenTransEntities(data) {
    var entities = [];

    addTransAttrs(data, 'Delete', 'Ordenes');

    if (isTrue(data.Stock) || isTrue(data.Mezclado)) {
        entities.push({ ITE_Nombre: data.ITE_Nombre, OperationType: 'DeleteEntities', PageName: 'MergeOrdenes' });
        entities.push(data);

        if (data.ST_ID) {
            entities.push({ ST_ID: data.ST_ID, OperationType: 'Delete', PageName: 'Stock' });
        }
    } else {
        entities.push({ ITE_Nombre: data.ITE_Nombre, OperationType: 'DeleteEntities', PageName: 'Items' });
        entities.push({ ITE_Nombre: data.ITE_Nombre, OperationType: 'DeleteEntities', PageName: 'ItemTasks' });
        entities.push(data);

        if (data.ST_ID) {
            entities.push({ ST_ID: data.ST_ID, OperationType: 'Delete', PageName: 'Stock' });
        }
    }

    return entities;
}

function addTransAttrs(entity, operation, pageName) {
    entity.OperationType = operation;
    entity.PageName = pageName;

    return entity;
}

function addItemTasks(entities, entity, tasks) {
    tasks.sort(function (a, b) {
        var a1 = parseInt(a['TaskOrder']), b1 = parseInt(b['TaskOrder']);
        return a1 > b1 ? 1 : -1;
    });

    for (var i = 0; i < tasks.length; i++) {
        var itemTask = getItemTasksEntity(entity, tasks[i]);
        addTransAttrs(itemTask, 'Save', 'ItemTasks');

        if (tasks[i].TaskName == 'Ventas') {
            if (entity.PN_Id != '' && entity.PN_Id != 'NULL') {
                itemTask.ITS_Status = '2';
                itemTask.ITS_DTStart = 'GETDATE()';
                itemTask.ITS_DTStop = 'GETDATE()';
                itemTask.USE_Login = LOGIN_NAME;
            } else {
                itemTask.ITS_Status = '1';
                itemTask.ITS_DTStart = 'GETDATE()';
                itemTask.USE_Login = LOGIN_NAME;
            }
        }

        if (i == 1 && entity.PN_Id != '' && entity.PN_Id != 'NULL') {//next task
            itemTask.ITS_Status = '0';
            itemTask.ITS_DTStart = 'GETDATE()';
            itemTask.USE_Login = LOGIN_NAME;
        }

        entities.push(itemTask);
    }
}

function attachProveedorIdEventHandler() {
    $('#MAT_ProvNumero').keydown(function (event) {
        var tips = $(DETALLE_DIALOG_SELECTOR + ' p.validateTips');
        tips.text('').removeClass('ui-state-highlight');
        if ($.trim($('#MAT_ProvNumero').val()) && event.which == 13) {
            var provID = $.trim($('#MAT_ProvNumero').val());
            var material = getMaterialDataByProvId(provID);

            if (material) {
                $('#MAT_ID').ComboBox('value', material.MAT_ID);
                $('#ED_Cantidad,#SD_Cantidad').focus();
            } else {
                $('#MAT_ID').ComboBox('value', '');
                tips.text('No se encontro ningun material con numero de provedor: ' + provID).addClass('ui-state-highlight');
            }
        }
    });
}

function getUniqueId() {
    var id = new Date().getTime();
    return '' + (-1 * id);
}

function getMaterialDataByProvId(provID) {
    var matList = $('#MAT_ID').ComboBox('getList');

    var results = $.grep(matList, function (item) {
        return item.MAT_ProvNumero == provID;
    });

    return results.length > 0 ? results[0] : null;
}

function getMaterialData(material) {
    var matList = $('#MAT_ID').ComboBox('getList');

    for (var i = 0; i < matList.length; i++) {
        if (material.MAT_ID == matList[i].MAT_ID) {
            return matList[i];
        }
    }

    return null;
}

function replaceEntityValues(template, data) {
    var keys = Object.keys(data)
    for (var i = 0; i < keys.length; i++) {
        var key = keys[i];
        var re = new RegExp('#' + key + '#', 'g');
        template = template.replace(re, data[key]);
    }

    return template;
}

function addEmptyRows(templateRow, rows) {
    var container = $('#template_container');
    var emptyRow = getEmptyObject();
    for (var i = 0; i < rows; i++) {
        $('#printdetail tbody', container).append(replaceEntityValues(templateRow, emptyRow));
    }
}

function getTemplate(templateName) {
    var entity = { TemplateName: templateName };
    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=Templates&searchType=AND&entity=' + $.toJSON(entity)
    });
}

function maskITENombre(selector, options) {
    var year = Date.today().toString('yy');
    var maskOpts = { placeholder: year + '-___-___-__', selectOnFocus: true };

    if (options.onChange) {
        maskOpts.onChange = options.onChange;
    }

    $(selector).mask('99-999-999-99', maskOpts);
}

function getCtlgConfig(_selector) {
    var selector = _selector || TABLE_SEL;

    return getCtlgOpts(selector).pageConfig;
}

function getCtlgOpts(_selector) {
    var selector = _selector || TABLE_SEL;

    return $(selector).Catalog('getCatalogOptions');
}

/****************** Top Records ***********************************/
function getTopRecords(config, top, order, where) {
    return $.ajax({
        url: createTopRecordsUrl(config, top, order, where),
        //data: 'filterInfo=' + encodeURIComponent($.toJSON(filter)),
        cache: false
    });
}

function createTopRecordsUrl(config, top, order, where) {
    var filter = getFilterInfo(config, top, order);
    if (where && $.isPlainObject(where)) {
        var colIdxs = getGridColsIndexes(config);
        $.each(where, function (key, value) {
            filter.columns[colIdxs[key]].search.value = value;
        });
    }

    var url = AJAX + '/PageInfo/GetPageEntityList?pageName=' + config.Name + '&filterInfo=' + encodeURIComponent($.toJSON(filter));

    return url;
}

function getFilterInfo(config, _top, _order) {
    var filterInfo = {};
    filterInfo.draw = '1';
    filterInfo.columns = createFilterInfoColumns(config);
    filterInfo.order = _order;
    filterInfo.start = 0;
    filterInfo.length = _top;
    filterInfo.search = { value: '', regex: false };

    return filterInfo;
}

function createFilterInfoColumns(config) {
    var cols = [];
    for (var i = 0; i < config.GridFields.length; i++) {
        var gridField = config.GridFields[i];
        var column = createFilterInfoColumn(gridField);
        var props = getColControlProps(config, gridField);
        if (props && props['search-type']) {
            column.searchtype = props['search-type'];
        }

        cols.push(column);
    }

    return cols;
}

function getColControlProps(config, gridField) {
    var props = null, field = config.FieldMap[gridField.FieldId];
    if (field.ControlProps) {
        props = $.evalJSON(field.ControlProps);
    }

    return props;
}

function createFilterInfoColumn(gridField) {
    var column = {};
    column.data = gridField.ColumnName;
    column.name = gridField.ColumnName;
    column.orderable = true;
    column.searchable = gridField.Searchable == 'True' ? true : false;
    column.search = { value: '', regex: false };

    return column;
}
/*********************************************************************************/


