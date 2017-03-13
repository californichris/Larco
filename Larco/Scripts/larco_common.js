const TYPE = {};
TYPE.PROD = 'PROD';
TYPE.STOCK = 'STOCK';
TYPE.MERGE = 'MERGE';
TYPE.PARTIAL = 'PARTIAL';

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
        type: "POST",
        url: AJAX + '/PageInfo/ExecuteTransaction',
        data: "entities=" + encodeURIComponent($.toJSON(entities))
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

function getUniqueId() {
    var id = new Date().getTime();
    return '' + (-1 * id);
}

function getMaterialData(material) {
    var matList = $('#MAT_ID').ComboBox('getList');

    for (var i = 0; i < matList.length; i++) {
        if (material.MAT_ID == matList[i].MAT_ID) {
            return matList[i];
        }
    }
}