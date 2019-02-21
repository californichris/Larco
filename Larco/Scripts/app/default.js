var PAGE_NAME = 'UrgentActiveOrders';
const TABLE_SEL = '#' + PAGE_NAME + '_table';

var MAX_BARS = 15;
var loading;

var DEFAULT_DETAIL_DIALOG_OPTS = {
    autoOpen: false, height: 630, width: 1270,
    modal: true, show: { effect: 'clip' },
    hide: { effect: 'clip' }
}

$(document).ready(function () {
    loading = displayLoading($('#urgentOrdersByInterna'));
    initDashBoard();
});

function displayLoading(element) {
    var top = $(element).height() / 2;
    var left = $(element).width() / 2;

    var loading = $('<div id="loading" style="height:500px;top:' + top + 'px;left:' + left + 'px;"></div>');
    $(element).append(loading);

    var target = document.getElementById('loading');
    var spinner = new Spinner(spinOpts).spin(target);

    return loading;
}

function initDashBoard() {
    createDetailDialog(); //dashboard_common.js
    createDashboard();
}

function createDashboard() {
    createBarCharts();
    createCountCharts(); //dashboard_common.js
}

function createBarCharts() {
    createUrgentOrdersByInternaBarChart();
}

function createUrgentOrdersByInternaBarChart() {
    var _pageName = PAGE_NAME;
    var _aggregate = getUrgentOrdersByInternaAggregate();

    $.when(getAggreateData(_pageName, _aggregate)).done(function (json) {
        var _data = json.aaData || json[0].aaData;
        var opts = {
            aggregate: _aggregate, pageName: _pageName, target: 'urgentOrdersByInterna', data: _data,
            title: 'Ordenes Urgentes Por Fecha Interna', xAxisFieldName: 'Interna', yAxisFieldName: 'Aggregate',
            xAxisLabel: 'Fechas', yAxisLabel: 'Ordenes', maxBars: MAX_BARS, showTotals: true,
            chartType: CHART_TYPE.BAR
        }

        createDetailTable(opts); //dashboard_common.js
        createBarChart(opts);
    });
}

function getUrgentOrdersByInternaAggregate() {
    var aggregate = {};
    aggregate.GroupByFields = 'Interna';
    aggregate.Functions = [];
    aggregate.Functions.push({ Function: 'COUNT', FieldName: '*' });

    return aggregate
}

function getSeriesColors() {
    var seriesColors = [];
    var opacity = '0.50';
    seriesColors.push('rgba(11, 65, 106,' + opacity + ')');
    seriesColors.push('rgba(128,128,128,' + opacity + ')');
    seriesColors.push('rgba(1,44,79,' + opacity + ')');
    seriesColors.push('rgba(193,193,193,' + opacity + ')');
    seriesColors.push('rgba(162, 205, 238,' + opacity + ')');
    seriesColors.push('rgba(103, 164, 211,' + opacity + ')');
    seriesColors.push('rgba(70, 140, 194,' + opacity + ')');
    seriesColors.push('rgba(37, 112, 169,' + opacity + ')');
    seriesColors.push('rgba(220,220,220,' + opacity + ')');

    return seriesColors;
}

