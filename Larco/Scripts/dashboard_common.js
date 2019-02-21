var DATA = [];
var detailTable = null;
var OTHER = 'Other*';
var FILTERTYPE = { EQUALS: 'EQUALS', NOTEQUALS: 'NOTEQUALS', DATERANGE: 'DATERANGE' };
var CHART_TYPE = { BAR: 'BAR', PIE: 'PIE' };
const DETAIL_PAGE = '#Training_container';
const DETAIL_DIALOG = '#detail_dialog';

var DATE_FORMAT = 'MM/dd/yyyy';

var DEFAULT_DETAIL_DIALOG_OPTS = {
    autoOpen: false, height: 630, width: 1020,
    modal: true, show: { effect: 'clip' },
    hide: { effect: 'clip' }
}

function getAggreateData(pageName, aggregate, entity) {
    var _url = AJAX_CONTROLER_URL + '/PageInfo/GetAggreateEntities?pageName=' + pageName + '&aggregateInfo=' + $.toJSON(aggregate);
    if (entity) _url = _url + '&searchType=AND&entity=' + $.toJSON(entity)

    return $.ajax({ url: _url, dataType: 'json', cache:false });
}

function convertToGraphArray(opts) {    
    var aggregateField = getAggregateField(opts), fieldName = getAggregateGroupField(opts);    
    var array = [], list = opts.slices;

    for (var i = 0; i < list.length; i++) {
        var obj = list[i];
        obj[fieldName] = (obj[fieldName] == '') ? 'None' : obj[fieldName];
        array.push(createGraphPoint(obj[fieldName] + ' - ' + obj[aggregateField], parseInt(obj[aggregateField])));        
    }

    return array;
}

function getAggregateField(opts) {
    var aggregate = opts.aggregate;
    return aggregate.Functions[0].Alias || 'Aggregate';
}

function getAggregateGroupField(opts) {
    var aggregate = opts.aggregate;
    return aggregate.GroupByFields.split(',')[0];
}

function createDataSlices(opts) {
    opts.slices = $.isArray(opts.data) ? opts.data : opts.data.aaData; //default
    if (opts.maxSlices && opts.slices.length > parseInt(opts.maxSlices)) {
        opts.maxSlices = parseInt(opts.maxSlices);
        var fieldName = getAggregateGroupField(opts), aggregateField = getAggregateField(opts);                
        var list = getSortedList(opts.slices, { sortBy: aggregateField, sortType: 'INT', sortDir: 'DESC' }); //sort by aggregate val desc       
        var removed = list.splice(opts.maxSlices - 1); //split array in 2       
        var total = calculateTotalFromOther(removed, opts); //calculate total of removed
        list = getSortedList(list, { sortBy: fieldName }); //sort by group field again so we can put other at the end
        list.push(createOtherObject(fieldName, aggregateField, total));

        opts.slices = list;
    } else {
        createDefaultSlices(opts);
    }
}

function calculateTotalFromOther(removed, opts) {
    var aggregateField = getAggregateField(opts);
    var total = 0;
    for (var i = 0; i < removed.length; i++) {
        total += parseInt(removed[i][aggregateField]);
    }

    return total;
}

function createOtherObject(fieldName, aggregateField, total) {
    var other = {};
    other[fieldName] = 'Other';
    other[aggregateField] = '' + total + '';

    return other;
}

function createDefaultSlices(opts) {
    var fieldName = getAggregateGroupField(opts);
    opts.slices = $.isArray(opts.data) ? opts.data : opts.data.aaData; //default
    opts.slices = clone(opts.slices);
    opts.slices = getSortedList(opts.slices, { sortBy: fieldName });
}

function getSortedList(json, sortOpts) {
    var list = $.isArray(json) ? json : json.aaData;
    $.page.sortList(list, sortOpts);

    return list;
}

function sortListBy(list, fieldName) {
    list.sort(function (a, b) {
        var a1 = a[fieldName], b1 = b[fieldName];
        if (a1 == b1) return 0;
        return a1 > b1 ? 1 : -1;
    });
}

function createLoading() {
    var loading = $('<div id="loading" style="height:500px;">Loading, please wait...</div>');
    $('h2').after(loading);
    var target = document.getElementById('loading');
    var spinner = new Spinner(spinOpts).spin(target);

    return loading;
}

function createDetailDialog() {
    $(DETAIL_DIALOG).dialog(DEFAULT_DETAIL_DIALOG_OPTS);
}

function createDetailTable(opts) {
    var pageName = opts.pageName;
    if (exists('#' + pageName + '_container')) return;

    var container = $(DETAIL_DIALOG).append('<div class="detail-container" id="' + pageName + '_container"></div>');
    var tableSel = '#' + pageName + '_table';
    var _source = opts.detailSource || '';
    var beforeLoadingTable = opts.beforeLoadingTable || null;
    var beforeServerData = opts.beforeServerDataCall || _beforeServerDataCall;

    $('#' + pageName + '_container').Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + pageName,
        createPageFilter: false, createPageDialog: false,
        onLoadComplete: function (config) {
            opts.pageConfig = config;
            $(tableSel).Catalog({
                source: _source, pageConfig: config, serverSide: true, showNew: false,
                showEdit: false, showDelete: false, iDeferLoading: 0,
                beforeServerDataCall: function (data) { beforeServerData(opts, data) },
                beforeLoadingTableCallBack: beforeLoadingTable
            });
        }
    });
}

//default beforeServercall functionality
function _beforeServerDataCall(opts, data) {
    for (var i = 0; i < data.columns.length; i++) {
        data.columns[i].searchtype = 'equals'; //set search type to equals
    }
}

function createPieChart(opts) {
    $(opts.container).html('');
    createDataSlices(opts);
    opts.series = convertToGraphArray(opts);
    if (isFunction(opts.beforeCreateChart)) opts.beforeCreateChart(opts); //trigger callback

    opts.plot = jQuery.jqplot(opts.target, [opts.series], {
        title: opts.title,
        seriesColors: getSeriesColors(),
        seriesDefaults: { shadow: false, showLine: true, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { showDataLabels: true } },
        legend: { show: true, location: 'e' },
        grid: getDefaultGrid()
    });

    resizePieChartLegendTable(opts);
    attachPieChartEventHandlers(opts);
    if (isFunction(opts.onComplete)) opts.onComplete(opts); //trigger callback
}

function resizePieChartLegendTable(opts) {
    var target = opts.target;
    var curWidth = $('#' + target + ' table.jqplot-table-legend').width();
    $('#' + target + ' table.jqplot-table-legend').width(curWidth + 7);
    $('#' + target + ' table.jqplot-table-legend tr').width(curWidth + 2);
}

function attachPieChartEventHandlers(opts) {
    var _data = opts.data;
    var target = opts.target;

    $('#' + target).bind('jqplotDataHighlight',
        function (ev, seriesIndex, pointIndex, data) {
            var current = $('#' + target + ' table.jqplot-table-legend tr.ui-state-focus td:last').text();
            current = $.trim(current).replace('amp;', '');
            if (current == data[0]) return;

            $('#' + target + ' table.jqplot-table-legend tr.ui-state-focus').removeClass('ui-state-focus');
            $('#' + target + ' table.jqplot-table-legend td.jqplot-table-legend-label').each(function (index, td) {
                var text = $.trim($(td).html()).replace('amp;', '');
                if (text == data[0]) {
                    $(td).parent().addClass('ui-state-focus');
                }
            });
        }
    );

    $('#' + target).bind('jqplotDataUnhighlight', function (ev) {
            $('#' + target + ' table.jqplot-table-legend tr.ui-state-focus').removeClass('ui-state-focus');
    });

    $('#' + target).bind('jqplotDataClick', function (ev, seriesIndex, pointIndex, data) {
        opts.current = data[0];
        opts.pointIndex = pointIndex;
        displayChartDetail(opts);
    });

    // update z-index of the chart legend table and canvas, so the legend table is in front of the canvas
    $('#' + target + ' .jqplot-event-canvas').css('z-index', 80);
    $('#' + target + ' table.jqplot-table-legend').css('z-index', 90);

    // Bind the click event to the pie chart legend table tbody
    $('#' + target + ' table.jqplot-table-legend tbody').click(function (event) {
        event.stopPropagation();
        var targetEle = event.target || event.srcElement;
        var tr = $(targetEle).parentsUntil('table.jqplot-table-legend', 'tr.jqplot-table-legend');
        var current = $('td:last', tr).text();
        var parent = $(tr).parentsUntil('div.catalog', 'div.jqplot-target');
        var target = parent.attr('id');

        opts.current = current;
        displayChartDetail(opts);
    });

    // Bind the mouseover/mouseout events to the pie chart legend table
    $('tbody', $('#' + target + ' table.jqplot-table-legend')).mouseover(function (event) {
        $('tbody tr.ui-state-hover', this.element).removeClass('ui-state-hover');
        var targetEle = event.target || event.srcElement;
        var parent = targetEle;
        if (targetEle.nodeName != 'TR') {
            parent = $(targetEle).parentsUntil('table.jqplot-table-legend', 'tr.jqplot-table-legend');
        }

        $(parent).addClass('ui-state-hover');
        var current = $('td:last', parent).text();

        highlightSlice(opts.plot, current);
    }).mouseout(function (event) {
        $('tbody tr.ui-state-hover', $('#' + target + ' table.jqplot-table-legend')).removeClass('ui-state-hover');
    });

    // change mouse cursor to default on legent table
    $('tr', $('#' + target + ' table.jqplot-table-legend')).css('cursor', 'default');
}

function getSeriesColors() {
    var seriesColors = [];
    var opacity = '0.50';
    seriesColors.push('rgba(11, 65, 106,' + opacity + ')');
    seriesColors.push('rgba(0, 116, 159,' + opacity + ')');
    seriesColors.push('rgba(162, 205, 238,' + opacity + ')');
    seriesColors.push('rgba(103, 164, 211,' + opacity + ')');
    seriesColors.push('rgba(70, 140, 194,' + opacity + ')');
    seriesColors.push('rgba(37, 112, 169,' + opacity + ')');
    seriesColors.push('rgba(17, 86, 139,' + opacity + ')');
    seriesColors.push('rgba(7, 73, 124,' + opacity + ')');
    seriesColors.push('rgba(220, 233, 243,' + opacity + ')');

    return seriesColors;
}

function getDefaultGrid() {
    return {
        drawGridLines: true,        // wether to draw lines across the grid or not.
        gridLineColor: '#E5E5E5',   // CSS color spec of the grid lines.
        background: '#ffffff',      // CSS color spec for background color of grid.
        borderColor: '#CFCFCF',     // CSS color spec for border around grid.
        borderWidth: 1.0,           // pixel width of border around grid.
        shadow: false               // draw a shadow for grid.
    };
}

function highlightSlice(plot, current) {
    var sidx = 0;
    var filterVal = (current.split(' - '))[1];
    var s = plot.series[sidx];
    var canvas = plot.plugins.pieRenderer.highlightCanvas;

    var pidx = 0;
    for (var i = 0; i < s.data.length; i++) {
        var d = s.data[i];
        if ($.trim(d[0]) == $.trim(current)) {
            pidx = i;
            break;
        }
    }

    canvas._ctx.clearRect(0, 0, canvas._ctx.canvas.width, canvas._ctx.canvas.height);
    s._highlightedPoint = pidx;
    plot.plugins.pieRenderer.highlightedSeriesIndex = sidx;
    s.renderer.drawSlice.call(s, canvas._ctx, s._sliceAngles[pidx][0], s._sliceAngles[pidx][1], s.highlightColorGenerator.get(pidx), false);
}

function displayChartDetail(opts) {
    $(DETAIL_DIALOG + ' div.detail-container').hide();
    $('#' + opts.pageName + '_container').show();

    var entity = {};
    if (opts.chartType == CHART_TYPE.PIE) {
        entity = getPieDetailEntity(opts);
    } else {
        var entity = getAggregateFilter('#' + opts.target) || {};
        var val = opts.data[opts.start + opts.pointIndex][opts.xAxisFieldName];
        entity[opts.xAxisFieldName] = val;
    }
    
    var tableSel = '#' + opts.pageName + '_table';
    var config = $(tableSel).Catalog('getCatalogOptions').pageConfig;

    var oTable = $(tableSel).DataTable();
    resetDetailTableFilter(oTable, config);
    $.each(entity, function (key, val) {
        if (config.ColIdxs[key] != 'undefined' && config.ColIdxs[key] >= 0) {
            oTable.columns(config.ColIdxs[key]).search(val);
        }        
    });

    oTable.draw();

    $(DETAIL_DIALOG).dialog('open');
}

function resetDetailTableFilter(oTable, config) {
    $.each(config.ColIdxs, function (key, val) {
        oTable.columns(val).search('');
    });
}

function getPieDetailEntity(opts) {
    var groupByfields = $('#' + opts.target).attr('groupByfields');
    var value = opts.current.split(' - ')[0];

    var entity = getAggregateFilter('#' + opts.target) || {};
    if (isOther(value)) {
        value = getOtherValue(opts);
    }
    entity[groupByfields] = value;

    return entity;
}

function getOtherValue(opts) {
    var list = [];
    var fieldName = getAggregateGroupField(opts);
    for (var i = 0; i < opts.slices.length; i++) {
        var slice = opts.slices[i];
        if (!isOther(slice[fieldName])) {
            list.push(slice[fieldName]);
        }
    }

    return 'NOT_LIST_' + list.join(',');
}

function isOther(value) {
    return value.toUpperCase() == 'OTHER';
}

function createCountChart(opts) {
    if (!jQuery.isPlainObject(opts)) {
        //argument opts is not an object, must be a string(selector e.g. #elementid) or a jquery element
        var _container = $(opts);
        opts = createDefaultPieChartOps(_container);
        opts.aggregate = createCountAggregate(opts);
    }

    _createPieChart(opts);
}

function createSumChart(opts) {
    if (!jQuery.isPlainObject(opts)) {
        //argument opts is not an object, must be a string(selector e.g. #elementid) or a jquery element
        var _container = $(opts);
        opts = createDefaultPieChartOps(_container);
        opts.aggregate = createSumAggregate(opts);
    }

    _createPieChart(opts);
}

function createDefaultPieChartOps(_container) {
    var opts = {
        container: _container, target: $(_container).attr('id'), title: $(_container).attr('title'),
        groupByfields: $(_container).attr('groupByfields'), sumField: $(_container).attr('sumField'),
        maxSlices: $(_container).attr('maxSlices')
    };

    opts.pageName = $(_container).attr('pageName') || PAGE_NAME;
    opts.entity = getAggregateFilter(_container);

    return opts;
}

function _createPieChart(opts) {
    $.when(getAggreateData(opts.pageName, opts.aggregate, opts.entity)).done(function (json) {
        hideLoading();

        if (!json.aaData || json.aaData.length <= 0) return;

        opts.data = json;
        opts.chartType = opts.chartType || CHART_TYPE.PIE;
        opts.title = opts.title || $(opts.container).attr('title');
        opts.target = opts.target || $(opts.container).attr('id');

        createPieChart(opts);
        createDetailTable(opts);
    });
}

function getAggregateFilter(container) {
    var entity = null;
    var filterFunc = $(container).attr('filterFunc');
    if (filterFunc) {
        var fn = getFunction(filterFunc);
        return fn(container);
    }

    return entity;
}

function getFunction(functionName) {
    var fn = window[functionName];
    if (typeof fn === 'function') {
        return fn;
    }
    
    return null;
}

function hideLoading() {
    if (loading) loading.remove();
    $('div.catalog').show();
}

function createPieCharts() {
    createCountCharts();
    createSumCharts();
}

function createCountCharts() {
    var charts = $('div.countChart');
    for (var i = 0; i < charts.length; i++) {
        createCountChart($(charts[i]));
    }
}

function createSumCharts() {
    var charts = $('div.sumChart');
    for (var i = 0; i < charts.length; i++) {
        createSumChart($(charts[i]));
    }
}

function createCountAggregate(opts) {
    var aggregate = {};
    aggregate.GroupByFields = opts.groupByfields;
    aggregate.Functions = [];
    aggregate.Functions.push({ Function: 'COUNT', FieldName: '*' });

    return aggregate;
}

function createSumAggregate(opts) {   
    var aggregate = {};
    aggregate.GroupByFields = opts.groupByfields;
    aggregate.Functions = [];
    aggregate.Functions.push({ Function: 'SUM', FieldName: opts.sumField });

    return aggregate;
}

function createGraphPoint(desc, value) {
    var val = [];
    val.push(desc);
    val.push(value);

    return val;
}

function getChartMax(maxVal) {
    var max = Math.max(maxVal, 10) + 16;
    return max.toFixed(2);
}

/**** Date Range Functions ****/

function getYearRange() {
    var from = Date.today().moveToFirstDayOfMonth();
    var to = Date.today().moveToLastDayOfMonth();
    if (Date.today().getMonth() != 0) {
        from = Date.today().moveToMonth(0, -1).moveToFirstDayOfMonth();
    }

    if (Date.today().getMonth() != 11) {
        to = Date.today().moveToMonth(11, +1).moveToLastDayOfMonth();
    }

    return from.toString(DATE_FORMAT) + '_' + to.toString(DATE_FORMAT);
}

function getMonthRange() {
    var from = Date.today().moveToFirstDayOfMonth();
    var to = Date.today().moveToLastDayOfMonth();
    return from.toString(DATE_FORMAT) + '_' + to.toString(DATE_FORMAT);
}

function getWeekRange() {
    var from = Date.today();
    var to = Date.today();
    if (Date.today().getDay() != 1) {
        from = Date.today().moveToDayOfWeek(1, -1);
    }

    if (Date.today().getDay() != 0) {
        to = Date.today().moveToDayOfWeek(0, +1);
    }

    return from.toString(DATE_FORMAT) + '_' + to.toString(DATE_FORMAT);
}

/***** Bar Chart ****/

function createBarChart(opts) {
    hideLoading();
    initBarChart(opts);
    if (!validateBarChartData(opts)) return;
    if (isFunction(opts.beforeCreateChart)) opts.beforeCreateChart(opts); //trigger callback

    _createBarChart(opts);

    attachBarChartEventHandlers(opts);
    createBarChartTotalSection(opts);
    createBarChartScrollButtons(opts);
    if (isFunction(opts.onComplete)) opts.onComplete(opts); //trigger callback
}

function _createBarChart(opts) {
    var overlayLines = opts.overlayLines ? true : false;
    opts.plot = $.jqplot(opts.target, [opts.series], {
        title: opts.title, axesDefaults: getBarChartAxesDefaults(opts),
        seriesColors: opts.seriesColors, seriesDefaults: getBarChartSeriesDefaults(opts),
        axes: getBarChartAxes(opts), highlighter: opts.highlighter,
        canvasOverlay: { show: overlayLines, objects: opts.overlayLines },
        grid: getDefaultGrid()
    });
}

function validateBarChartData(opts) {
    if (opts.data.length <= 0) {
        $('#' + opts.target).html('No data found.');
        return false;
    }

    return true;
}

function isFunction(func) {
    return func && typeof func === 'function';
}

function getBarChartAxesDefaults(opts) {
    return { tickopts: { formatString: '%.2f' } };
}

function getBarChartAxes(opts) {
    return {
        xaxis: {
            renderer: $.jqplot.CategoryAxisRenderer,
            ticks: opts.ticks, label: opts.xAxisLabel
        },
        yaxis: {
            label: opts.yAxisLabel, min: 0, max: getChartMax(opts.maxVal),
            tickOptions: { formatString: '%.2f' }
        }
    };
}

function getBarChartSeriesDefaults(opts) {
    return {
        renderer: $.jqplot.BarRenderer, pointLabels: { show: true },
        rendererOptions: { varyBarColor: true }, shadow: false, showLine: true
    };
}

function attachBarChartEventHandlers(opts) {
    $('#' + opts.target).unbind('jqplotDataClick');
    $('#' + opts.target).bind('jqplotDataClick',
        function (ev, seriesIndex, pointIndex, graphdata) {
            opts.pointIndex = pointIndex;
            opts.graphdata = graphdata;
            displayChartDetail(opts);
        }
    );
}

function initBarChart(opts) {
    $('#totals', $('#' + opts.target).parent()).remove();
    $('#' + opts.target).html('');

    opts.showTotals = opts.showTotals || false;
    opts.start = opts.start || 0;
    opts.ticks = [], opts.series = [];
    opts.length = opts.data.length;
    opts.maxVal = 0.0, opts.total = 0.0;
    opts.maxBars = opts.maxBars || opts.length
    setBarChartSeries(opts);
    opts.avg = (opts.total / opts.length);
    opts.seriesColors = opts.seriesColors || getSeriesColors();
    opts.highlighter = opts.highlighter || getDefaultBarChartHiglighter(opts);
    opts.tooltipFieldName = opts.tooltipFieldName || opts.xAxisFieldName;
}

function setBarChartSeries(opts) {
    for (var i = 0; i < opts.length ; i++) {
        var sFieldName = opts.yAxisFieldName, tickFieldName = opts.xAxisFieldName;
        var sVal = parseFloat(opts.data[i][sFieldName]), tickVal = opts.data[i][tickFieldName];

        if ((i >= opts.start) && (i < opts.length && i < (opts.maxBars + opts.start))) {
            opts.series.push(sVal.toFixed(2));
            opts.ticks.push(tickVal);
        }

        opts.maxVal = Math.max(opts.maxVal, sVal);
        opts.total += sVal;
    }
}

function createBarChartTotalSection(opts) {
    if (opts.showTotals) {
        $('#totals', $('#' + opts.target).parent()).remove();
        $('#' + opts.target).parent().append('<table id="totals" cellpadding="2" cellspacing="2"><tr><td>Total:</td><td><b>' + opts.total.toFixed(2) + '</b></td><td>Avg:</td><td><b>' + opts.avg.toFixed(2) + '</b></td></tr></table>');
    }
}

function createBarChartScrollButtons(opts) {
    if (!(opts.length > opts.maxBars)) return;

    createBarChartNextButton(opts);
    createBarChartPrevButton(opts);
}

function createBarChartNextButton(opts) {
    if ((opts.start + opts.maxBars) < opts.length) {
        var _start = opts.start + opts.maxBars;
        var display = getBarChartNextButtonDisplay(opts);

        var width = $('#' + opts.target).css('width');
        $('#' + opts.target).append('<div id="nextRecords" style="position:absolute;top:200px;left:' + width + '"><button class="graph-buttons" title="Show ' + display + '"></button></div>');
        $('#nextRecords button', $('#' + opts.target)).button({ text: false, icons: { primary: 'ui-icon-triangle-1-e' } }).click(function (event) {
            opts.start = _start;
            createBarChart(opts);
        });
    }
}

function getBarChartNextButtonDisplay(opts) {
    var _start = opts.start + opts.maxBars;
    var display = (opts.length - _start) < opts.maxBars ? (opts.length - _start) : opts.maxBars;
    if (display == 1) {
        //TODO: remove the last s
        display = 'last ' + opts.xAxisLabel;
    } else if (display < opts.maxBars) {
        display = 'last ' + display + ' ' + opts.xAxisLabel;
    } else {
        display = 'next ' + display + ' ' + opts.xAxisLabel;
    }

    return display;
}

function createBarChartPrevButton(opts) {
    if (opts.start > 0) {
        $('#' + opts.target).append('<div id="prevRecords" style="position:absolute;top:200px;left:0px;"><button class="graph-buttons" title="Show previous ' + opts.maxBars + ' ' + opts.xAxisLabel + '"></button></div>');
        $('#prevRecords button', $('#' + opts.target)).button({ text: false, icons: { primary: 'ui-icon-triangle-1-w' } }).click(function (event) {
            opts.start = opts.start - opts.maxBars;
            createBarChart(opts);
        });
    }
}

function getDefaultBarChartHiglighter(opts) {
    return {
        show: true, sizeAdjust: -9, lineWidthAdjust: 2.5,
        tooltipLocation: 'n', tooltipOffset: 18,
        tooltipContentEditor: function (str, seriesIndex, pointIndex, plot) {
            var text = opts.data[opts.start + pointIndex][opts.tooltipFieldName];
            return '<span style="padding:5px;font-size:13px;"><b>' + text + '</b></span>';
        }
    }
}