const PAGE_NAME = 'DueUrgentOrdersProcessedByEmployee';
const TABLE_SEL = '#' + PAGE_NAME + '_table';

$(document).ready(initPage);

function initPage() {
    $('div.catalog').Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
        dialogStyle: 'table',
        onLoadComplete: function (config) {
            var title = config.Title;
            $('h2').text(title);
            document.title = title;
            initCatalog(config);
        },
        onBeforeCreateFilter: beforeCreateFilter
    });
}

function beforeCreateFilter(config) {
    var from = config.FilterFielNameMap['ITS_DTStopFromFilter'];
    var controlProps = $.evalJSON(from.ControlProps);
    controlProps.value = Date.today().moveToFirstDayOfMonth().toString('MM/dd/yyyy');
    from.ControlProps = $.toJSON(controlProps);

    var to = config.FilterFielNameMap['ITS_DTStopToFilter'];
    var controlProps = $.evalJSON(to.ControlProps);
    controlProps.value = Date.today().moveToLastDayOfMonth().toString('MM/dd/yyyy');
    to.ControlProps = $.toJSON(controlProps);
}

function initCatalog(config) {
    $(TABLE_SEL).Catalog({
        pageConfig: config, dialogWidth: 680, ordering: false,
        source: createURL(false),
        exportRequest: createURL(true),               
        scrollX: '100%', scrollXInner: '150%', scrollY: '620px',
        paginate: false, showDelete: false,
        serverSide: true, showExport: true,
        showNew: false, showEdit: false,
        rowCallback: _rowCallback
    });
}

function _rowCallback(nRow, aData, iDisplayIndex, config) {
    $(nRow).attr('empleado', aData.NumeroEmpleado);
    $(nRow).attr('task', aData.TaskId);
    $(nRow).attr('prod', aData.ProdId);

    if (aData.TaskNombre) {
        $(nRow).hide();
    } else {
        $('td:eq(' + config.ColIdxs.Empleado + ')', nRow).html(createEmployeeLink(nRow, aData));
    }

    if (aData.ITE_Nombre) {
        $(nRow).addClass('detail');
    }

    if (aData.ProdNombre && !aData.ITE_Nombre) {
        $(nRow).addClass('product');
        $('td:eq(' + config.ColIdxs.ProdNombre + ')', nRow).html(createProdLink(nRow, aData));
    }

    if (aData.TaskNombre && !aData.ProdNombre) {
        $(nRow).addClass('task');
        $('td:eq(' + config.ColIdxs.TaskNombre + ')', nRow).html(createTaskLink(nRow, aData));
    }

    return nRow;
}

function createEmployeeLink(nRow, aData) {
    var html = new StringBuffer();
    html.append('<a ');
    html.append('title="Click aqui para mostrar/ocultar el detalle por tarea." href="#" onclick="displayTaskDetail(this, ' + aData.NumeroEmpleado + '); return false;">');
    html.append(aData.Empleado);
    html.append('</a>');

    return html.toString();
}

function createTaskLink(nRow, aData) {
    var html = new StringBuffer();
    html.append('<a ');
    html.append('title="Click aqui para mostrar/ocultar el detalle por producto." href="#" onclick="displayProdDetail(this, ' + aData.NumeroEmpleado + ',' + aData.TaskId + '); return false;">');
    html.append(aData.TaskNombre);
    html.append('</a>');

    return html.toString();
}

function createProdLink(nRow, aData) {
    var html = new StringBuffer();
    html.append('<a ');
    html.append('title="Click aqui para mostrar/ocultar el detalle por orden." href="#" onclick="displayDetail(this, ' + aData.NumeroEmpleado + ',' + aData.TaskId + ',' + aData.ProdId + '); return false;">');
    html.append(aData.ProdNombre);
    html.append('</a>');

    return html.toString();
}

function displayTaskDetail(anchor, empleado) {
    event.stopPropagation();
    $('tr.task[id=' + empleado + ']').toggle();

    if ($(anchor).parent().parent().hasClass('bold')) {
        $('tr.product[id=' + empleado + ']').hide();
        $('tr.detail[id=' + empleado + ']').hide();
    }

    $(anchor).parent().parent().toggleClass('bold');

    return false;
}

function displayProdDetail(anchor, empleado, task) {
    event.stopPropagation();
    $('tr.product[id=' + empleado + '][task=' + task + ']').toggle();

    if ($(anchor).parent().parent().hasClass('bold')) {
        $('tr.detail[id=' + empleado + '][task=' + task + ']').hide();
    }

    $(anchor).parent().parent().toggleClass('bold');

    return false;
}

function displayDetail(anchor, empleado, task, prod) {
    event.stopPropagation();
    $('tr.detail[id=' + empleado + '][task=' + task + '][prod=' + prod + ']').toggle();

    $(anchor).parent().parent().toggleClass('bold');

    return false;
}

function getSorting(gridColsIndexes) {
    var sorting = [];
    sorting.push([gridColsIndexes.Empleado, 'asc']);

    return sorting;
}

function createURL(exportable) {
    var _url = AJAX + '/PageInfo/GetAggreateEntities?searchType=AND&pageName=' + PAGE_NAME;
    _url = _url + '&aggregateInfo=' + $.toJSON(createAggregateInfo());
    if (exportable) _url = _url + '&csv=true';

    return _url;
}

function createAggregateInfo() {
    var aggregateInfo = { GroupingSets: [], Functions: [], GroupByFields: 'NumeroEmpleado, Empleado, TaskId, TaskNombre, ProdId, ProdNombre, ITE_Nombre, ITS_DTStart, ITS_DTStop' };
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Requerida', Alias: 'Requerida' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Urgent', Alias: 'Urgent' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Due', Alias: 'Due' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Puntos', Alias: 'Puntos' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'TotalPuntos', Alias: 'TotalPuntos' });
    aggregateInfo.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado');
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado, TaskId, TaskNombre');
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado, TaskId, TaskNombre, ProdId, ProdNombre');
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado, TaskId, TaskNombre, ProdId, ProdNombre, Requerida, Urgent, Due, ITE_Nombre, ITS_DTStart, ITS_DTStop');

    return aggregateInfo;
}