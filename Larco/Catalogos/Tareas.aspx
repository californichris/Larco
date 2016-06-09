<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tareas.aspx.cs" Inherits="BS.Larco.Catalogos.Tareas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=Tareas',
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        $('#Tareas_table').Catalog({
	            pageConfig: config,
	            paginate: false,
	            showExport: true,
	            scrollY: '460px',
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            },
	            initCompleteCallBack: function (oTable, oSettings, json, options) {
	                appendUpDownButtons(oTable, oSettings, json, options);
	            },
	            newEntityCallBack: function(oTable, options) {
	                $('#Tareas_table').Catalog('newEntity');
	                var list = getSortedList(oTable);
	                if (list.length > 0) {
	                    $('#TaskOrder').val(parseInt(list[list.length - 1].TaskOrder) + 1);
	                } else {
	                    $('#TaskOrder').val('1');
	                }
                }
	        });
	    }

	    function appendUpDownButtons(oTable, oSettings, json, options) {
	        //Creating up/down buttons
	        var upbtn = $('<button class="disable" onclick="return false;" title="Mover tarea hacia arriba en el orden.">Mover Arriba</button>');
	        var upbtnOpts = { text: options.showText };

	        if (options.showIcons) {
	            upbtnOpts.icons = { primary: "ui-icon-triangle-1-n" };
	        }

	        upbtn.button(upbtnOpts).click(function (event) {
	            var data = getSelectedRowData(oTable);
	            var list = getSortedList(oTable);

	            var index = indexOfArray(list, 'TaskId', data.TaskId);
	            if (index == 0) return; //Is first in the list do nothing
	            var prev = list[index - 1];

	            switchOrder(data, prev);
	            executeTrans(data, prev, oTable);
	        }).button('disable');

	        var downbtn = $('<button class="disable" onclick="return false;" title="Mover tarea hacia abajo en el orden.">Mover Abajo</button>');
	        var downbtnOpts = { text: options.showText };

	        if (options.showIcons) {
	            downbtnOpts.icons = { primary: "ui-icon-triangle-1-s" };
	        }

	        downbtn.button(downbtnOpts).click(function (event) {
	            var data = getSelectedRowData(oTable);
	            var list = getSortedList(oTable);

	            var index = indexOfArray(list, 'TaskId', data.TaskId);
	            if (index == list.length - 1) return; //is the last of the list do nothing
	            var next = list[index + 1];

	            switchOrder(data, next);
	            executeTrans(data, next, oTable);
	        }).button('disable');

	        $('#Tareas_table').Catalog('getButtonSection').append(upbtn).append(downbtn);
	    }

	    function getSortedList(oTable) {
	        var _json = oTable.ajax.json();
	        var list = _json.aaData;
	        list.sort(function (a, b) {
	            return $.page.sortItems(a, b, { sortField: 'TaskOrder', sortType: 'INT', sortDir: 'ASC' });
	        });

	        return list;
	    }

	    function switchOrder(task1, task2) {
	        var currentOrder = task1.TaskOrder;
	        task1.TaskOrder = task2.TaskOrder;
	        task2.TaskOrder = currentOrder;
	    }

	    function executeTrans(task1, task2, oTable) {
	        var entities = [];

	        task1.PageName = 'Tareas';
	        task1.OperationType = 'Save';

	        task2.PageName = 'Tareas';
	        task2.OperationType = 'Save';

	        entities.push(task1);
	        entities.push(task2);

	        $.ajax({
	            type: "POST",
	            url: AJAX_CONTROLER_URL + '/PageInfo/ExecuteTransaction',
	            data: "entities=" + encodeURIComponent($.toJSON(entities))
	        }).done(function (json) {
	            if (json.ErrorMsg == SUCCESS) {
	                //reload dialog table
	                oTable.ajax.reload();
	            } else {
	                alert('Ocurrio un error al mover el orden de la tarea.');
	            }
	        });
	    }


	    function indexOfArray(array, key, val) {
	        var length = array.length;
	        for (var i = 0; i < array.length; i++) {
	            var item = array[i];
	            if (item[key] == val) {
	                return i;
	            }
	        }

	        return -1;
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
