$(document).ready(initPage);

var PAGE_NAME = 'OrdenesTV';
const TABLE_SEL = '#' + PAGE_NAME + '_table';
const FILTER_SEL = '#' + PAGE_NAME + '_filter';

var TASKS = [];
var CURRENT = null;
var CURRENT_INDEX = -1;
var CURRENT_PAGE = -1;
var CURRENT_PAGE_INFO = null;
var TASK_INFO = null;

var TASK_HASH = {};
var TOTALS = [];

function initPage() {
    loadTasks();
    $('#display').button().click(displayTaskInfo);
    $('#returnToSelector').button().click(returnToTaskSelector);

    createPage();

    $(document).bind('keydown', 'right', function () {
        log('rigth press');
        startDisplayTask();
        return false;
    });
}

function createPage() {
    $('div.task-display-content').Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
        dialogSelector: '#dialog_container',
        filterSelector: '#filter_container',
        onLoadComplete: function (config) {
            initCatalog(config);
        }
    });
}

function initCatalog(config) {    
    $(TABLE_SEL).Catalog({
        pageConfig: config, showExport: false, serverSide:true,
        showNew: false, showEdit: false, showDelete: true,
        displayLength: 10, info: false, iDeferLoading: 0,
        columnDefs: [ { targets: '_all', sorting: false } ],
        rowCallback: _rowCallback,
        initCompleteCallBack: initComplete,
        sorting: getSorting(config)
    });
}

function getSorting(config) {
    var sorting = [];
    sorting.push([config.ColIdxs.Interna, 'asc']);

    return sorting;
}

function _rowCallback(nRow, aData, iDisplayIndex, config) {
    var rowNum = (CURRENT_PAGE * 10) + iDisplayIndex + 1;
    jQuery('td:eq(' + config.ColIdxs.OrdenId + ')', nRow).html(rowNum);

    if (isTrue(aData.Urgente)) {
        jQuery('td:eq(' + config.ColIdxs.ITE_Nombre + ')', nRow).addClass('urgent');
    }
}

function initComplete() {
    $('#OrdenesTV_table > thead > tr > th:nth-child(1) > div').text('');
    $(TABLE_SEL).DataTable().on('draw.dt', function (e, settings, details) {
        CURRENT_PAGE_INFO = $(TABLE_SEL).DataTable().page.info();
    });
}

function displayTaskInfo() {
    var tasks = $('#TaskId').val();
    if (!tasks) {
        alert('selecciona al menos una tarea.');
        return;
    }

    $('#task-selector').hide();
    $('#task-display').show();
    startDisplayTasks(tasks);
}

function returnToTaskSelector() {
    $('#task-selector').show();
    $('#task-display').hide();

    resetVars();
}

function resetVars() {
    TASKS = [];
    CURRENT = null;
    CURRENT_INDEX = -1;
    CURRENT_PAGE = -1;
    CURRENT_PAGE_INFO = null;
    TASK_INFO = null;

    if (interval) clearInterval(interval);
    if (totalInterval) clearInterval(totalInterval);
}

function startDisplayTasks(tasks) {
    TASKS = tasks;
    if (TASKS.length <= 0) {
        log('No tasks to display');
        return;
    }

    startDisplayTask();
    startDisplayTotals();
}

var totalInterval = null;
function startDisplayTotals() {
    if (totalInterval) clearInterval(totalInterval);

    var time = isInt($('#TimeTotals').val()) ? parseInt($('#TimeTotals').val()) : 120;
    $.when(getAggreateData()).done(updateTotals);

    totalInterval = setInterval(startDisplayTotals, time * 1000);
}

function updateTotals(json) {
    log('updateTotals');
    $('span.text-totals').text('');

    if (json && json.ErrorMsg) {
        log(json.ErrorMsg);
        return;
    }

    TOTALS = json.aaData;
    updateLarcoTotals();
    updateTaskTotals();
}

function updateTaskTotals() {
    log('updateTaskTotals');
    var total = null;
    for (var i = 0; i < TOTALS.length; i++) {        
        if (TOTALS[i].TaskId == CURRENT) {
            total = TOTALS[i];
            break;
        }
    }

    $('#total_tarea_ordenes, #total_tarea_piezas').text('');
    if (total) {
        $('#total_tarea_ordenes').text(total.Ordenes);
        $('#total_tarea_piezas').text(total.Piezas);
    }

    $('#task_totals_table').effect('highlight', { color: '#F3D8D8' }, 'slow', function () {
        $('#task_totals_table').show();
    });
}


function updateLarcoTotals() {
    log('updateTaskTotals');
    var total = null;
    for (var i = 0; i < TOTALS.length; i++) {
        if (TOTALS[i].TaskId == '') {
            total = TOTALS[i];
            break;
        }
    }

    $('#total_ordenes, #total_piezas').text('');
    if (total) {
        $('#total_ordenes').text(total.Ordenes);
        $('#total_piezas').text(total.Piezas);
    }
}

var interval = null;
function startDisplayTask() {
    if (interval) clearInterval(interval);

    getNextTask();
    $('.task-name').text(TASK_INFO.TaskNombre);

    if (CURRENT_PAGE == 0) {
        $('#TaskIdFilter').val(CURRENT);
        $(FILTER_SEL).Filter('refresh');
    } else {
        $(TABLE_SEL).DataTable().page('next').draw('page');
    }
    updateTaskTotals();

    interval = setInterval(startDisplayTask, parseInt(TASK_INFO.DetailTime) * 1000);
}

function getNextTask() {
    if(CURRENT_INDEX == -1) {
        CURRENT_INDEX++;
        CURRENT_PAGE++;
    } else {
        if (CURRENT_PAGE_INFO.page < (CURRENT_PAGE_INFO.pages - 1)) {
            CURRENT_PAGE++;
        } else {
            CURRENT_PAGE = 0;
            CURRENT_INDEX++;
        }
    }

    if (CURRENT_INDEX >= TASKS.length) CURRENT_INDEX = 0;

    CURRENT = TASKS[CURRENT_INDEX];
    TASK_INFO = getTaskInfo(CURRENT);
}

function loadTasks() {
    $.when(getTasks()).done(function (json) {
        createTasksHash(json);
        $.page.createSelectOptions($('#TaskId'), json, {valField: 'TaskId', textField: 'TaskNombre' });
    });
}

function getTasks() {
    return $.ajax({
        url: AJAX + '/PageInfo/GetPageEntityList?pageName=TareasTV',
        cache: false
    });
}

function getTaskInfo(taskId) {
    var id = parseInt(taskId);
    return TASK_HASH[id] || getDefaultTask();
}

function getDefaultTask() {
    var _default = {};
    _default.MinimumTimeInTask = 60;
    _default.DetailTime = 15;
    _default.TaskNombre = '';

    return _default;
}

function createTasksHash(json) {
    var tasks = $.isArray(json) ? json[0].aaData : json.aaData;
    for (var i = 0; i < tasks.length; i++) {
        var task = tasks[i];
        TASK_HASH[task.TaskId] = task;
    }
}

function getAggreateData() {
    var aggregate = createAggregateInfo();
    var _url = AJAX + '/PageInfo/GetAggreateEntities?pageName=' + PAGE_NAME + '&aggregateInfo=' + $.toJSON(aggregate);

    return $.ajax({ url: _url, dataType: 'json', cache: false });
}

function createAggregateInfo() {
    var aggregateInfo = { GroupingSets: [], Functions: [], GroupByFields: 'TaskId, TaskName' };
    aggregateInfo.Functions.push({ Function: 'SUM', FieldName: 'Ordenada', Alias: 'Piezas' });
    aggregateInfo.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
    aggregateInfo.GroupingSets.push('TaskId, TaskName');
    aggregateInfo.GroupingSets.push('');

    return aggregateInfo;
}