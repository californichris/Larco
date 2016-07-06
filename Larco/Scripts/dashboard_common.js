var DATA = [];
var detailTable = null;
var OTHER = 'Otros*';
var FILTERTYPE = { EQUALS: 'EQUALS', NOTEQUALS: 'NOTEQUALS', DATERANGE: 'DATERANGE' };
var SERIES_COLORS = ['#004276', '#CF0E0E', '#AD2323', '#AF5D5D', '#CCCCCC', '#EEEEEE', '#F9F9F9', '#5191C4', '#1D6094'];

var tableOpts = {
    sAjaxSource: { "aaData": [] }, bJQueryUI: true, bProcessing: true, bDestroy: true, bPaginate: false, bFilter: true, bInfo: true, sScrollY: 490,
    fnServerData: function (sSource, aoData, fnCallback) {
        fnCallback(sSource);
    },
    fnRowCallback: function (nRow, aData, iDisplayIndex) {
        var armJobNumber = aData.ArmJobNumber;
        if (aData.ArmJobNumber != null && aData.ArmJobNumber != '') {
            var url = APP_PATH + '/Projects/Projects.aspx?action=view&projectId=' + aData.ProjectId;
            armJobNumber = '<a style="color:blue;" href="' + url + '"  target="_blank" title="View project details.">' + aData.ArmJobNumber + '</a>';
        }

        jQuery('td:eq(0)', nRow).html(armJobNumber);
        return nRow;
    },
    aoColumns: [{ mDataProp: 'ArmJobNumber', sWidth: '110px' }, { mDataProp: 'JobIdShortDesc', sWidth: '450px' }, { mDataProp: 'StatusIdText', sWidth: '80px' },
        { mDataProp: 'EmployeeId', sWidth: '80px' }, { mDataProp: 'PriorityIdText', sWidth: '80px' }, { mDataProp: 'RequestingGroup', sWidth: '160px' }],
};

function createLoading() {
    var loading = $('<div id="loading" style="height:500px;">Loading, please wait...</div>');
    $('h2').after(loading);

    var target = document.getElementById('loading');
    var spinner = new Spinner(spinOpts).spin(target);

    return loading;
}

function createDetailDialog() {
    $('#detail_dialog').dialog({
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
    });
}

function createDetailTable(opts) {
    detailTable = $('#detail_table').dataTable(opts);
    $('#detail_dialog div.DataTables_sort_wrapper').css('width', 'inherit');

    $('#detail_dialog div.dataTables_scrollHeadInner').css('height', '20px');
    $('#detail_dialog div.dataTables_scrollHeadInner thead tr').css('height', '18px').css('vertical-align', 'top');
    $('#detail_dialog div.dataTables_scrollHeadInner thead tr th').css('height', '18px');
    $('#detail_dialog div.dataTables_scrollHeadInner thead tr th div').css('height', '16px');

    // Bind the mouseover/mouseout events to the detail table
    $('tbody', $('#detail_table')).mouseover(function (event) {
        $('tbody tr.ui-state-hover', this.element).removeClass('ui-state-hover');
        var targetEle = event.target || event.srcElement;
        var parent = targetEle;
        if (targetEle.nodeName != 'TR') {
            parent = $(targetEle).parentsUntil('table', 'tr'); //targetEle.parentNode;      	
        }

        $(parent).addClass("ui-state-hover");
    }).mouseout(function (event) {
        $('tbody tr.ui-state-hover', $('#detail_table')).removeClass('ui-state-hover');
    });
}

function createActiveCompletedBarChart(target, data, options) {
    var completed = filterData(data, 'StatusIdText', 'Completed', FILTERTYPE.EQUALS);
    var active = filterData(data, 'StatusIdText', 'Active', FILTERTYPE.EQUALS);

    var completedWeek = filterData(completed, 'CompletionDate', getWeekRange(), FILTERTYPE.DATERANGE);
    var completedMonth = filterData(completed, 'CompletionDate', getMonthRange(), FILTERTYPE.DATERANGE);
    var completedYear = filterData(completed, 'CompletionDate', getYearRange(), FILTERTYPE.DATERANGE);

    var completedArray = [];
    completedArray.push(completedWeek);
    completedArray.push(completedMonth);
    completedArray.push(completedYear);

    var activeWeek = filterData(active, 'SystemEnteredDate', getWeekRange(), FILTERTYPE.DATERANGE);
    var activeMonth = filterData(active, 'SystemEnteredDate', getMonthRange(), FILTERTYPE.DATERANGE);
    var activeYear = filterData(active, 'SystemEnteredDate', getYearRange(), FILTERTYPE.DATERANGE);

    var activeArray = [];
    activeArray.push(activeWeek);
    activeArray.push(activeMonth);
    activeArray.push(activeYear);

    var series = [];
    series.push(activeArray);
    series.push(completedArray);

    var s1 = [activeWeek.length, activeMonth.length, activeYear.length];
    var s2 = [completedWeek.length, completedMonth.length, completedYear.length];
    var ticks = ['Week', 'Month', 'Year'];

    plot2 = $.jqplot(target, [s1, s2], {
        title: options.title,
        seriesColors: ['#A2CDEE', '#07497C'],
        seriesDefaults: {
            renderer: $.jqplot.BarRenderer,
            pointLabels: { show: true }
        },
        axes: {
            xaxis: {
                renderer: $.jqplot.CategoryAxisRenderer,
                ticks: ticks
            }
        }
    });

    $('#' + target).bind('jqplotDataClick',
        function (ev, seriesIndex, pointIndex, data) {
            var _data = { "aaData": series[seriesIndex][pointIndex] }
            displayDetail(_data);
        }
    );
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
        seriesColors: SERIES_COLORS,
        seriesDefaults: { shadow: true, renderer: jQuery.jqplot.PieRenderer, rendererOptions: { showDataLabels: true } },
        legend: { show: true, location: 'e' }
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

    // Bind the click event to the pie chart legend table tnody
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

        $(parent).addClass("ui-state-hover");
        var current = $('td:last', parent).text();

        highlightSlice(plot, current);
    }).mouseout(function (event) {
        $('tbody tr.ui-state-hover', $('#' + target + ' table.jqplot-table-legend')).removeClass('ui-state-hover');
    });

    // change mouse cursor to default on legent table
    $('tr', $('#' + target + ' table.jqplot-table-legend')).css('cursor', 'default');
}

function createDueDateBarChart(target, data, options) {
    var openProjects = filterData(data, 'StatusIdText', 'Completed', FILTERTYPE.NOTEQUALS);
    openProjects = filterData(openProjects, 'StatusIdText', 'Canceled', FILTERTYPE.NOTEQUALS);

    var from = Date.today().moveToFirstDayOfMonth();
    var to = Date.today().moveToFirstDayOfMonth().addYears(1).addDays(-1)
    var range = from.toString('MM/dd/yyyy') + '_' + to.toString('MM/dd/yyyy');

    openProjects = filterData(openProjects, 'DueDate', range, FILTERTYPE.DATERANGE);

    for (var i = 0; i < openProjects.length; i++) {
        openProjects[i].DueDateMonthYear = Date.parse(openProjects[i].DueDate).toString('yyyy-MM');
    }

    var projectsByDueDate = groupData({
        data: openProjects,
        fieldName: 'DueDateMonthYear'
    });

    var s1 = [];
    var ticks = [];
    var _ticks = [];

    for (var i = 0; i < projectsByDueDate.length; i++) {
        ticks.push(right(projectsByDueDate[i][0], 7));
        s1.push(projectsByDueDate[i][1]);
        var _date = right(projectsByDueDate[i][0], 7) + '-01';
        _ticks.push(Date.parseExact(_date, "yyyy-MM-dd").toString('MMM-yyyy'))
    }

    $.jqplot(target, [s1], {
        title: options.title,
        seriesColors: SERIES_COLORS,
        seriesDefaults: {
            renderer: $.jqplot.BarRenderer,
            pointLabels: { show: true },
            rendererOptions: {
                varyBarColor: true
            }
        },
        axes: {
            xaxis: {
                renderer: $.jqplot.CategoryAxisRenderer,
                ticks: _ticks
            }
        }
    });

    $('#' + target).bind('jqplotDataClick',
        function (ev, seriesIndex, pointIndex, graphdata) {
            var _date = ticks[pointIndex] + '-01';

            var from = Date.parseExact(_date, "yyyy-MM-dd").moveToFirstDayOfMonth();
            var to = Date.parseExact(_date, "yyyy-MM-dd").moveToLastDayOfMonth();
            var range = from.toString('MM/dd/yyyy') + '_' + to.toString('MM/dd/yyyy');

            var detail = filterData(data, 'StatusIdText', 'Completed', FILTERTYPE.NOTEQUALS);
            detail = filterData(detail, 'StatusIdText', 'Canceled', FILTERTYPE.NOTEQUALS);
            detail = filterData(detail, 'DueDate', range, FILTERTYPE.DATERANGE);

            var _data = { "aaData": detail }
            displayDetail(_data);
        }
    );
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

function reloadDetailTable(current, target, data) {
    var filterVal = (current.split(' - '))[1];
    var filteredData = [];
    var fieldName = '';

    if (target.indexOf('Status') != -1) {
        fieldName = 'StatusIdText';
        if (OTHER != filterVal) {
            filteredData = filterData(DATA, fieldName, filterVal, FILTERTYPE.EQUALS)
        }
        $('#detail_dialog').dialog('option', 'title', 'Projects by Status - ' + filterVal);
    } else if (target.indexOf('Employee') != -1) {
        fieldName = 'EmployeeId';
        filteredData = filterData(DATA, 'StatusIdText', 'Completed', FILTERTYPE.NOTEQUALS);
        filteredData = filterData(filteredData, 'StatusIdText', 'Canceled', FILTERTYPE.NOTEQUALS);
        filteredData = filterData(filteredData, 'StatusId', '', FILTERTYPE.NOTEQUALS);
        if (OTHER != filterVal) {
            filteredData = filterData(filteredData, fieldName, filterVal, FILTERTYPE.EQUALS);
        }

        $('#detail_dialog').dialog('option', 'title', 'Projects by Employee - ' + filterVal);
    } else if (target.indexOf('Priority') != -1) {
        fieldName = 'PriorityIdText';
        filteredData = filterData(DATA, 'StatusIdText', 'Completed', FILTERTYPE.NOTEQUALS);
        filteredData = filterData(filteredData, 'StatusIdText', 'Canceled', FILTERTYPE.NOTEQUALS);
        filteredData = filterData(filteredData, 'StatusId', '', FILTERTYPE.NOTEQUALS);
        if (OTHER != filterVal) {
            filteredData = filterData(filteredData, fieldName, filterVal, FILTERTYPE.EQUALS);
        }

        $('#detail_dialog').dialog('option', 'title', 'Projects by Priority - ' + filterVal);
    } else {
        fieldName = 'RequestingGroup';
        filteredData = filterData(DATA, 'StatusIdText', 'Completed', FILTERTYPE.NOTEQUALS);
        filteredData = filterData(filteredData, 'StatusIdText', 'Canceled', FILTERTYPE.NOTEQUALS);
        filteredData = filterData(filteredData, 'StatusId', '', FILTERTYPE.NOTEQUALS);
        if (OTHER != filterVal) {
            filteredData = filterData(filteredData, fieldName, filterVal, FILTERTYPE.EQUALS);
        }
        $('#detail_dialog').dialog('option', 'title', 'Projects by Requesting Group - ' + filterVal);
    }

    if (OTHER == filterVal) {
        for (var i = 0; i < data.length; i++) {
            var d = data[i];
            filterVal = (d[0].split(' - '))[1];
            filteredData = filterData(filteredData, fieldName, filterVal, FILTERTYPE.NOTEQUALS);
        }
    }
    log('filteredData');
    log(filteredData);
    var _data = { "aaData": filteredData }
    displayDetail(_data);
}

function displayDetail(_data) {
    detailTable.fnReloadAjax(_data);

    $('#detail_dialog div.dataTables_filter input').addClass('ui-corner-all');
    $('#detail_dialog .DataTables_sort_icon').css('float', 'right');
    $('#detail_dialog').dialog('open');
}

function groupData(options) {
    var list = options.data;
    var fieldName = options.fieldName;

    list.sort(function (a, b) {
        var a1 = a[fieldName], b1 = b[fieldName];
        if (a1 == b1) return 0;
        return a1 > b1 ? 1 : -1;
    });

    var groupData = [];
    var prevVal = '';
    var count = 0;

    for (var i = 0; i < list.length; i++) {
        var data = list[i];
        data[fieldName] = data[fieldName] == '' ? 'None' : data[fieldName];

        if ((options.countIf != null && options.countIf(data)) || options.countIf == null) {
            if (prevVal != '' && prevVal != data[fieldName]) {
                if (count > 0) {
                    groupData.push(createGraphPoint(count + ' - ' + prevVal, count));
                }
                count = 0;
            }

            count += 1;
            prevVal = data[fieldName];
        }
    }

    var data = list[list.length - 1];
    groupData.push(createGraphPoint(count + ' - ' + data[fieldName], count));

    if (groupData.length > 15) {
        groupData.sort(function (a, b) { //Sort descending
            var a1 = b[1], b1 = a[1];
            if (a1 == b1) return 0;
            return a1 > b1 ? 1 : -1;
        });

        var first14 = groupData.slice(0, 14);
        var rest = groupData.slice(14);

        var sum = 0;
        for (var i = 0; i < rest.length; i++) {
            sum += (rest[i])[1];
        }

        first14.sort(function (a, b) { //Sort ascending by text
            var a1 = (a[0].split(' - '))[1], b1 = (b[0].split(' - '))[1];
            if (a1 == b1) return 0;
            return a1 > b1 ? 1 : -1;
        });

        first14.push(createGraphPoint(sum + ' - ' + OTHER, sum));
        groupData = first14;
    }

    return groupData;
}

function createGraphPoint(desc, value) {
    var val = [];
    val.push(desc);
    val.push(value);

    return val;
}

function filterData(data, filterBy, filterVal, filterType) {
    var range, dateFrom, dateTo, dateMin, dateMax;
    if (filterType == FILTERTYPE.DATERANGE) {
        range = filterVal.split('_');
        dateFrom = range[0];
        dateTo = range[1];

        dateMin = dateFrom.substring(6, 10) + dateFrom.substring(0, 2) + dateFrom.substring(3, 5);
        dateMax = dateTo.substring(6, 10) + dateTo.substring(0, 2) + dateTo.substring(3, 5);
    }

    var filteredData = jQuery.grep(data, function (prj, i) {
        if (filterType == FILTERTYPE.EQUALS) {
            return (prj[filterBy] == filterVal);
        } else if (filterType == FILTERTYPE.NOTEQUALS) {
            return (prj[filterBy] != filterVal);
        } else if (filterType == FILTERTYPE.DATERANGE) {
            var value = prj[filterBy];
            if (dateFrom == '' && dateTo == '') return true;

            var date = value.substring(6, 10) + value.substring(0, 2) + value.substring(3, 5);
            return filterByDate(date, dateMin, dateMax);
        }
    });

    return filteredData;
}

function filterByDate(date, dateMin, dateMax) {
    // run through cases
    if (dateMin == "" && date <= dateMax) {
        return true;
    }
    else if (dateMin == "" && date <= dateMax) {
        return true;
    }
    else if (dateMin <= date && "" == dateMax) {
        return true;
    }
    else if (dateMin <= date && date <= dateMax) {
        return true;
    }
    // all failed
    return false;
}

function right(str, n) {
    if (n <= 0)
        return "";
    else if (n > String(str).length)
        return str;
    else {
        var iLen = String(str).length;
        return String(str).substring(iLen, iLen - n);
    }
}