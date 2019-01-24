var DATA = [];
var detailTable = null;
var OTHER = 'Other*';
var FILTERTYPE = { EQUALS: 'EQUALS', NOTEQUALS: 'NOTEQUALS', DATERANGE: 'DATERANGE' };
const DETAIL_PAGE = '#PageApp_container';
const DETAIL_DIALOG = '#detail_dialog';

var DEFAULT_DETAIL_DIALOG_OPTS = {
    autoOpen: false,
    height: 630,
    width: 1020,
    modal: true,
    show: {
        effect: 'clip'
    },
    hide: {
        effect: 'clip'
    }
}

function getAggreateData(pageName, aggregate) {
    return $.ajax({
        url: AJAX_CONTROLER_URL + '/PageInfo/GetAggreateEntities?pageName=' + pageName + '&aggregateInfo=' + $.toJSON(aggregate),
        dataType: 'json'
    });
}

function convertToGraphArray(json, aggregate) {
    var aggregateField = aggregate.Functions[0].Alias || 'Aggregate';
    var fieldName = aggregate.GroupByFields.split(',')[0];
    var list = getSortedList(json, fieldName);
   
    var array = [];
    for (var i = 0; i < list.length; i++) {
        var obj = list[i];

        obj[fieldName] = obj[fieldName] == '' ? 'None' : obj[fieldName];
        array.push(createGraphPoint(obj[fieldName] + ' - ' + obj[aggregateField], parseInt(obj[aggregateField])));
    }

    return array;
}

function getSortedList(json, fieldName) {
    var list = $.isArray(json) ? json : json.aaData;
    sortListBy(list, fieldName);

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

function createDetailTable() {
    $(DETAIL_PAGE).Page({
        source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
        createPageFilter: false, createPageDialog: false,
        onLoadComplete: function (config) {
            $(TABLE_SEL).Catalog({
                pageConfig: config, source: [], showNew: false,
                showEdit: false, showDelete: false,
            });
        }
    });
}

function getDetailEntity(current, target, _data) {
    var groupByfields = $('#' + target).attr('groupByfields');
    var value = current.split(' - ')[0];

    var entity = {};
    entity[groupByfields] = value;

    return entity;
}

function getYearRange() {
    var from = Date.today().moveToFirstDayOfMonth();
    var to = Date.today().moveToLastDayOfMonth();
    if (Date.today().getMonth() != 0) {
        from = Date.today().moveToMonth(0, -1).moveToFirstDayOfMonth();
    }

    if (Date.today().getMonth() != 11) {
        to = Date.today().moveToMonth(11, +1).moveToLastDayOfMonth();
    }

    return from.toString('MM/dd/yyyy') + '_' + to.toString('MM/dd/yyyy');
}

function getMonthRange() {
    var from = Date.today().moveToFirstDayOfMonth();
    var to = Date.today().moveToLastDayOfMonth();
    return from.toString('MM/dd/yyyy') + '_' + to.toString('MM/dd/yyyy');
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

    return from.toString('MM/dd/yyyy') + '_' + to.toString('MM/dd/yyyy');
}

function createPieChart(target, data, options) {
    var _data = data;
    var plot = jQuery.jqplot(target, [data], {
        title: options.title,
        seriesColors: getSeriesColors(),
        seriesDefaults: { shadow: false, showLine: true, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { showDataLabels: true } },
        legend: { show: true, location: 'e' },
        grid: getDefaultGrid()
    });

    var curWidth = $('#' + target + ' table.jqplot-table-legend').width();
    $('#' + target + ' table.jqplot-table-legend').width(curWidth + 7);
    $('#' + target + ' table.jqplot-table-legend tr').width(curWidth + 2);

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

    $('#' + target).bind('jqplotDataUnhighlight',
        function (ev) {
            $('#' + target + ' table.jqplot-table-legend tr.ui-state-focus').removeClass('ui-state-focus');
        }
    );

    $('#' + target).bind('jqplotDataClick',
        function (ev, seriesIndex, pointIndex, data) {
            var current = data[0];          
            if (options.reloadCallback == null) {
                reloadDetailTable(current, target, _data);
            } else {
                options.reloadCallback(current, target, _data)
            }
        }
    );

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

        if (options.reloadCallback == null) {
            reloadDetailTable(current, target, _data);
        } else {
            options.reloadCallback(current, target, _data)
        }
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

        highlightSlice(plot, current);
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
        borderWidth: 2.0,           // pixel width of border around grid.
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

function displayDetail(current, target, _data) {
    $(DETAIL_DIALOG + ' div.detail-container').hide();
    $(DETAIL_PAGE).show();
    
    //TODO: change this to use the more generic method _displayDetail in default.js
    var entity = getDetailEntity(current, target, _data);

    $(TABLE_SEL).Catalog('clearTable');
    $.when(getDetailData(entity)).done(function (json) {
        $(TABLE_SEL).Catalog('addDataToTable', json.aaData);
        $(DETAIL_DIALOG).dialog('open');
    });
}

function getDetailData(entity) {
    return $.getData(AJAX + '/PageInfo/GetPageEntityList?pageName=' + PAGE_NAME + '&entity=' + encodeURIComponent($.toJSON(entity)));
}

function createCountChart(container) {
    $(container).html('');
    var aggregateInfo = createCountAggregate(container);
    var pageName = $(container).attr('pageName') || PAGE_NAME;

    $.when(getAggreateData(pageName, aggregateInfo)).done(function (json) {
        hideLoading();

        if (!json.aaData || json.aaData.length <= 0) return;
        createPieChart($(container).attr('id'), convertToGraphArray(json, aggregateInfo), {
            title: $(container).attr('title'), reloadCallback: function (current, target, _data) {
                displayDetail(current, target, _data);
            }
        });
    });
}

function hideLoading() {
    if (loading) loading.remove();
    $('div.catalog').show();
}

function createCountCharts() {
    var charts = $('div.countChart');
    for (var i = 0; i < charts.length; i++) {
        createCountChart($(charts[i]));
    }
}

function createCountAggregate(container) {
    var groupByfields = $(container).attr('groupByfields');

    var status = {};
    status.GroupByFields = groupByfields;
    status.Functions = [];
    status.Functions.push({ Function: 'COUNT', FieldName: '*' });

    return status;
}

function createGraphPoint(desc, value) {
    var val = [];
    val.push(desc);
    val.push(value);

    return val;
}

function getChartMax(maxVal) {
    return Math.max(maxVal, 10) + 16;
}

/***** Bar Chart ****/

function createBarChart(opts) {
    hideLoading();
    initBarChart(opts);

    var objJqplot = $.jqplot(opts.target, [opts.series], {
        title: opts.title, axesDefaults: getBarChartAxesDefaults(opts),
        seriesColors: opts.seriesColors, seriesDefaults: getBarChartSeriesDefaults(opts),
        axes: getBarChartAxes(opts), highlighter: opts.highlighter,
        //canvasOverlay: { show: true, objects: getOverlayLines() },
        grid: getDefaultGrid()
    });

    attachBarChartEventHandlers(opts);
    createBarChartTotalSection(opts);
    createBarChartScrollButtons(opts);
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
        yaxis: { label: opts.yAxisLabel, min: 0, max: getChartMax(opts.maxVal) }
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
            _displayDetail(pointIndex, graphdata, opts);
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
}

function setBarChartSeries(opts) {
    for (var i = 0; i < opts.length ; i++) {
        var sFieldName = opts.yAxisFieldName, tickFieldName = opts.xAxisFieldName;
        var sVal = parseFloat(opts.data[i][sFieldName]), tickVal = opts.data[i][tickFieldName];

        if ((i >= opts.start) && (i < opts.length && i < (opts.maxBars + opts.start))) {
            opts.series.push(sVal);
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

        $('#' + opts.target).append('<div id="nextRecords" style="position:absolute;top:200px;left:1090px;"><button class="graph-buttons" title="Show ' + display + '"></button></div>');
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
            var text = opts.data[opts.start + pointIndex][opts.xAxisFieldName];
            return '<span style="padding:5px;font-size:13px;"><b>' + text + '</b></span>';
        }
    }
}