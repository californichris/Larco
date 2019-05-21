var PAGE_NAME = 'DueUrgentOrdersProcessedByEmployee';
var TABLE_SEL = '#' + PAGE_NAME + '_table';

$(document).ready(initPage);

function initPage() {
    log(PAGE_NAME);
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
    var from = config.FilterFieldNameMap['ITS_DTStopFromFilter'];
    var controlProps = $.evalJSON(from.ControlProps);

    var today = Date.today();
    var fromDate = Date.today();
    var toDate = Date.today();
    if (today.is().wednesday()) {//wednesday        
        toDate = today;
        fromDate = toDate.clone().addDays(-6);
    } else {
        toDate = today.last().wednesday();
        fromDate = toDate.clone().addDays(-6);
    }

    controlProps.value = fromDate.toString('MM/dd/yyyy');
    from.ControlProps = $.toJSON(controlProps);

    var to = config.FilterFieldNameMap['ITS_DTStopToFilter'];
    var controlProps = $.evalJSON(to.ControlProps);
    controlProps.value = toDate.toString('MM/dd/yyyy') + ' 23:59:59';
    to.ControlProps = $.toJSON(controlProps);
}

function initCatalog(config) {
    $(TABLE_SEL).Catalog({
        pageConfig: config, dialogWidth: 680, ordering: false,
        source: createURL(false),
        exportRequest: createURL(true),               
        scrollX: '100%', scrollXInner: '150%', scrollY: '620px',
        paginate: false, showDelete: false,
        serverSide: true, showExport: false,
        showNew: false, showEdit: false,
        iDeferLoading: 0,
        rowCallback: _rowCallback,
        initCompleteCallBack: initComplete
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

function initComplete(oTable, oSettings, json, options) {
    appendExportBtn();
}

function appendExportBtn() {
    var ul = createExportList();

    $('a', ul).click(function () {
        var requestData = getRequestData(this);
        $.fileDownload(requestData.url, { httpMethod: 'POST', data: requestData.data });
    });

    var expbtn = createExportBtn(ul);
    $(TABLE_SEL + '_wrapper_buttons').append(expbtn);
}

function getRequestData(link) {
    var options = $(TABLE_SEL).Catalog('getCatalogOptions');
    var requestData = $(TABLE_SEL).Catalog('getExportRequest', options);
    var exportType = $(link).attr('export-type');
    if (exportType == 'Employee') {
        var filterInfo = $(TABLE_SEL).Catalog('getExportFilterInfo', options);
        requestData.data = 'aggregateInfo=' + $.toJSON(createAggregateInfoByEmployee());
        requestData.data += '&' + filterInfo;
    } else if (exportType == 'Task') {
        var filterInfo = $(TABLE_SEL).Catalog('getExportFilterInfo', options);
        requestData.data = 'aggregateInfo=' + $.toJSON(createAggregateInfoByTask());
        requestData.data += '&' + filterInfo;
    } else if (exportType == 'Product') {
        var filterInfo = $(TABLE_SEL).Catalog('getExportFilterInfo', options);
        requestData.data = 'aggregateInfo=' + $.toJSON(createAggregateInfoByProduct());
        requestData.data += '&' + filterInfo;
    }

    return requestData;
}

function createExportBtn(ul) {
    var expbtn = $('<button id="exportReports" title="Exportar reportes">Export</button>');
    var buttonOpts = { text: true };
    buttonOpts.icons = { primary: 'ui-icon-arrowthickstop-1-s', secondary: 'ui-icon-triangle-1-s' };

    expbtn.button(buttonOpts).click(function (event) {
        var menu = $(ul).show().position({
            my: 'left top', at: 'left bottom', of: this
        });

        return false;
    });

    return expbtn;
}

function createExportList() {
    var ul = $('<ul class="export-menu ui-corner-all" style="display:none;"></ul>').attr('id', 'export-menu');
    ul.append('<li class="ui-corner-all"><a href="#" id="export-ByEmployee" export-type="Employee" title="Exportar reporte agrupado por empleado">Por Empleado</a></li>');
    ul.append('<li class="ui-corner-all"><a href="#" id="export-ByTask" export-type="Task" title="Exportar reporte agrupado por tarea">Por Tarea</a></li>');
    ul.append('<li class="ui-corner-all"><a href="#" id="export-ByProduct" export-type="Product" title="Exportar reporte agrupado por producto">Por Producto</a></li>');
    ul.append('<li class="ui-corner-all"><a href="#" id="export-Detail" export-type="Detail" title="Exxportar reporte detallado">Detallado</a></li>');

    $('body').append(ul);
    var menu = $(ul).menu();
    $(document).on('click', function () { menu.hide(); });

    return ul;
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
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'CantidadLarco', Alias: 'CantidadLarco' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Urgent', Alias: 'Urgent' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Due', Alias: 'Due' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Puntos', Alias: 'Puntos' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'PuntosExtras', Alias: 'PuntosExtras' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'TotalPuntos', Alias: 'TotalPuntos' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'TotalPuntosExtras', Alias: 'TotalPuntosExtras' });
    aggregateInfo.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado');
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado, TaskId, TaskNombre');
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado, TaskId, TaskNombre, ProdId, ProdNombre');
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado, TaskId, TaskNombre, ProdId, ProdNombre, CantidadLarco, Urgent, Due, ITE_Nombre, ITS_DTStart, ITS_DTStop');

    return aggregateInfo;
}

function createAggregateInfoByEmployee() {
    var aggregateInfo = { GroupingSets: [], Functions: [], GroupByFields: 'NumeroEmpleado, Empleado' };
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'CantidadLarco', Alias: 'CantidadLarco' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Urgent', Alias: 'Urgent' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Due', Alias: 'Due' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Puntos', Alias: 'Puntos' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'PuntosExtras', Alias: 'PuntosExtras' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'TotalPuntos', Alias: 'TotalPuntos' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'TotalPuntosExtras', Alias: 'TotalPuntosExtras' });
    aggregateInfo.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado');

    return aggregateInfo;
}

function createAggregateInfoByTask() {
    var aggregateInfo = { GroupingSets: [], Functions: [], GroupByFields: 'NumeroEmpleado, Empleado, TaskId, TaskNombre' };
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'CantidadLarco', Alias: 'CantidadLarco' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Urgent', Alias: 'Urgent' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Due', Alias: 'Due' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Puntos', Alias: 'Puntos' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'PuntosExtras', Alias: 'PuntosExtras' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'TotalPuntos', Alias: 'TotalPuntos' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'TotalPuntosExtras', Alias: 'TotalPuntosExtras' });
    aggregateInfo.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado');
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado, TaskId, TaskNombre');

    return aggregateInfo;
}

function createAggregateInfoByProduct() {
    var aggregateInfo = { GroupingSets: [], Functions: [], GroupByFields: 'NumeroEmpleado, Empleado, TaskId, TaskNombre, ProdId, ProdNombre' };
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'CantidadLarco', Alias: 'CantidadLarco' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Urgent', Alias: 'Urgent' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Due', Alias: 'Due' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Puntos', Alias: 'Puntos' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'PuntosExtras', Alias: 'PuntosExtras' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'TotalPuntos', Alias: 'TotalPuntos' });
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'TotalPuntosExtras', Alias: 'TotalPuntosExtras' });
    aggregateInfo.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado');
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado, TaskId, TaskNombre');
    aggregateInfo.GroupingSets.push('NumeroEmpleado, Empleado, TaskId, TaskNombre, ProdId, ProdNombre');

    return aggregateInfo;
}