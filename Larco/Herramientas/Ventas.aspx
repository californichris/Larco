<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Ventas.aspx.cs" Inherits="BS.Larco.Herramientas.Ventas" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <style type="text/css">
            #StockParcial {display:inline;}
            #StockParcialCantidad {float: right; margin-right:1px; width:80%; display:inline;}        
        </style>
    <script type="text/javascript" src="<%= Page.ResolveUrl("~/Scripts/jquery.mask.js") %>"></script>
	<script type="text/javascript">
	    const PAGE_NAME = 'OrdenesVW';
	    const TABLE_SELECTOR = '#' + PAGE_NAME + '_table';
	    const DIALOG_SELECTOR = '#' + PAGE_NAME + '_dialog';

	    var PLANOS = [];
	    $.getData(AJAX + '/PageInfo/GetPageEntityList?pageName=PlanosList');

	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        var year = Date.today().toString('yy');
	        $('#ITE_Nombre').mask('99-999-999-99', {
	            placeholder: year + '-___-___-__', selectOnFocus: true,
	            onChange: function (_value) {
	                if ($('#OrdenId').val() == '' && _value.length == 6) {//only in new
	                    var numbers = _value.split('-');
	                    if (numbers.length >= 1) {
	                        $.when(getLatestOrderByClient(numbers[1])).done(function (json) {
	                            if (json.aaData && json.aaData.length > 0) {
	                                populateDialog(json.aaData[0], DIALOG_SELECTOR);
	                                numbers = json.aaData[0].ITE_Nombre.split('-');
	                                numbers[numbers.length - 1] = padDigits(parseInt(numbers[numbers.length - 1]) + 1, 2);
	                                $('#ITE_Nombre').val(numbers.join('-'));

	                                setDefaults();
	                            }
	                        });
	                    }
	                }
	            }
	        });

	        createEventHandlers();
	        appendAdditionalInfoSection();

	        var ventasCtlg = $(TABLE_SELECTOR).Catalog({
	            pageConfig: config,
	            serverSide: true,
	            showExport: true,
	            dialogWidth: 1100,
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            },
	            newEntityCallBack: function (oTable, options) {
	                ventasCtlg.Catalog('newEntity', oTable, options);
	                setDefaults();

	                $('#popularidad_numero_parte_table').DataTable().clear().draw();
	                $('#popularidad_plano_table').DataTable().clear().draw();
	            },
	            editEntityCallBack: function (oTable, options) {
	                ventasCtlg.Catalog('editEntity', oTable, options);
	                $('#popularidad_numero_parte_table').DataTable().clear().draw();
	                $('#popularidad_plano_table').DataTable().clear().draw();
	                setPlanId();

	                reloadAdditionalInfoSection();
	            },
	            deleteEntityCallBack: function (oTable, options) {

	            },
	            saveEntityCallBack: function (oTable, options) {

	            },
	            sorting: [[getArrayIndexForKey(config.GridFields, 'ColumnName', 'Recibido') || 0, 'desc']]
	        });
	    }

	    /*$.fn.setCursorPosition = function (pos) {
	        this.each(function (index, elem) {
	            if (elem.setSelectionRange) {
	                elem.setSelectionRange(pos, pos);
	            } else if (elem.createTextRange) {
	                var range = elem.createTextRange();
	                range.collapse(true);
	                range.moveEnd('character', pos);
	                range.moveStart('character', pos);
	                range.select();
	            }
	        });
	        return this;
	    };

	    $.fn.selectRange = function (start, end) {
	        return this.each(function () {
	            if (this.setSelectionRange) {
	                this.focus();
	                this.setSelectionRange(start, end);
	            } else if (this.createTextRange) {
	                var range = this.createTextRange();
	                range.collapse(true);
	                range.moveEnd('character', end);
	                range.moveStart('character', start);
	                range.select();
	            }
	        });
	    };*/

	    function setPlanId() {
	        if ($('#PN_Id').val() != '') {
	            $('#PN_Id').attr('PlanId', $('#PN_Id').val());
	            var arr = jQuery.grep(PLANOS, function (p) {
	                return p.value == $('#PN_Id').val();
	            });

	            $('#Plano').prop('checked', true);
	            $('#PN_Id').val(arr[0].label).prop('readonly', false);
	        }
	    }

	    function setDefaults() {
	        $('#Recibido').datepicker("setDate", new Date());
	        $('#EmployeeId').val(LOGIN_NAME).selectmenu('refresh');
	        $('#PN_Id').prop('readonly', !$('#Plano').is(':checked'));
	    }

	    function getLatestOrderByClient(_clientId) {
	        var entity = { ClientId: _clientId };
	        return $.ajax({
	            url: AJAX + '/Larco/GetLatestOrderByClient?pageName=' + PAGE_NAME + '&entity=' + $.toJSON(entity),
	            dataType: 'json'
	        });
	    }

	    function appendAdditionalInfoSection() {
	        var table = $('#OrdenesVW_dialog #tabs-1 table.table-style');
	        $('#additional_info').insertAfter(table).show();

	        var options = {
	            data: [],
	            paginate: false,
	            filter: false,
	            jQueryUI: true,
	            info: false,
	            scrollY: '60px',
	            columns: [
                    { title: "Ordenes", data: 'Ordenes', bSortable: false },
                    { title: "Piezas", data: 'Piezas', bSortable: false },
                    { title: "Stock", data: 'Stock', bSortable: false },
                    { title: "Sugerida", data: 'Sugerida', bSortable: false }
	            ]
	        }
	        $('#popularidad_numero_parte_table').DataTable(options);
	        $('#popularidad_numero_parte_table_wrapper div.fg-toolbar').remove();
	        $('#popularidad_plano_table').DataTable(options);
	        $('#popularidad_plano_table_wrapper div.fg-toolbar').remove();
	    }

	    function reloadAdditionalInfoSection() {
	        //reloadPartNumberPopularity();
	        //reloadPlanPopularity();
	        reloadProdOrdersByPartNumber();
	    }

	    function getPopularityAggregate() {
	        var aggregate = { GroupByFields: '', Functions: [] };
	        aggregate.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
	        aggregate.Functions.push({ Function: 'SUM', FieldName: 'Requerida', Alias: 'Piezas' });
	        aggregate.Functions.push({ Function: 'AVG', FieldName: 'Requerida', Alias: 'Sugerida' });

	        return aggregate;
	    }

	    function reloadPartNumberPopularity() {
	        if ($.trim($('#Numero').val()) == '') return;
	        
	        var aggregate = getPopularityAggregate();
	        var entity = { Recibido: getPopularityDateRange(), Numero: $.trim($('#Numero').val()) };

	        var stockAggregate = { GroupByFields: 'PN_Id,PA_Alias,ST_Tipo', Functions: [] };
	        stockAggregate.Functions.push({ Function: 'SUM', FieldName: 'ST_Cantidad', Alias: 'Cantidad' });
	        var entityStock = { PA_Alias: $.trim($('#Numero').val()) };
	        
	        $.when(getAggreateData('OrdenesVW', aggregate, entity), getAggreateData('PlanoAliasStock', stockAggregate, entityStock)).done(function (json1, json2) {
	            var dataSet = createPopularityDataSet(json1, json2);
	            $('#popularidad_numero_parte_table').DataTable().clear().rows.add(dataSet).draw();
	        });
	    }

	    function reloadPlanPopularity() {
	        if ($.trim($('#PN_Id').val()) == '') return;

	        var aggregate = getPopularityAggregate();
	        var entity = { Recibido: getPopularityDateRange(), PN_Id: $.trim($('#PN_Id').attr('PlanId')) };

	        var stockAggregate = { GroupByFields: 'PN_Id,PN_Numero,ST_Tipo', Functions: [] };
	        stockAggregate.Functions.push({ Function: 'SUM', FieldName: 'ST_Cantidad', Alias: 'Cantidad' });
	        var entityStock = { PN_Id: $.trim($('#PN_Id').attr('PlanId')) };

	        $.when(getAggreateData('OrdenesVW', aggregate, entity), getAggreateData('PlanoStock', stockAggregate, entityStock)).done(function (json1, json2) {
	            var dataSet = createPopularityDataSet(json1, json2);
	            $('#popularidad_plano_table').DataTable().clear().rows.add(dataSet).draw();
	        });
	    }

	    function reloadProdOrdersByPartNumber() {
	        var aggregate = { GroupByFields: 'ITE_Nombre,Ordenada,Requerida,Tarea,TaskStatus,StockParcialCantidad', Functions: [] };
	        aggregate.Functions.push({ Function: 'SUM', FieldName: 'MO_Cantidad', Alias: 'Usadas' });

	        var entity = { Numero: '7112-5088-XW', ITS_DTStart: 'NOT_NULL', ITS_DTStop: 'NULL', ITS_Status: 'NOT_9' };

	        $.when(getAggreateData('OrdenesInProd', aggregate, entity)).done(function (json) {
	            log(json);
	        });

	    }

	    function createPopularityDataSet(json1, json2) {
	        json1 = json1[0];
	        json2 = json2[0];

	        var stock = 0;
	        if (json2.aaData && json2.aaData.length > 0) {
	            for (var i = 0; i < json2.aaData.length; i++) {
	                if (json2.aaData[i].ST_Tipo == 'Entrada') stock += parseInt(json2.aaData[i].Cantidad);
	                if (json2.aaData[i].ST_Tipo == 'Salida') stock -= parseInt(json2.aaData[i].Cantidad);
	            }
	        }

	        var dataSet = [];
	        if (json1.aaData && json1.aaData.length > 0) {
	            json1.aaData[0].Stock = stock;
	            json1.aaData[0].Ordenes = json1.aaData[0].Ordenes || 0;
	            json1.aaData[0].Piezas = json1.aaData[0].Piezas || 0;
	            json1.aaData[0].Sugerida = json1.aaData[0].Sugerida || 0;
	            dataSet.push(json1.aaData[0]);
	        } else {
	            dataSet.push({ Stock: stock, Ordenes: 0, Requerida: 0, Sugerida: 0 });
	        }

	        return dataSet;
	    }

	    function getPopularityDateRange() {
	        //TODO: add time to configuration, rigth now default to 6 months

	        var start = Date.today().addMonths(-6).toString('MM/dd/yyyy');
	        var end = Date.today().toString('MM/dd/yyyy');
	        return start + '_RANGE_' + end;
	    }

	    function getAggreateData(pageName, aggregate, entity) {
	        return $.ajax({
	            url: AJAX + '/PageInfo/GetAggreateEntities?pageName=' + pageName + '&searchType=AND&aggregateInfo=' + $.toJSON(aggregate) + '&entity=' + $.toJSON(entity),
	            dataType: 'json'
	        });
	    }

	    function createEventHandlers() {
	        $('#Requerida').blur(function () {
	            if ($('#Ordenada').val() == '') {
	                $('#Ordenada').val($('#Requerida').val());
	            }
	        });

	        $('#Plano').click(function () {
	            $('#PN_Id').prop('readonly', !$('#Plano').is(':checked'));
	            if (!$('#Plano').is(':checked')) {
	                $('#PN_Id').val('').attr('PlanoId', '');
	            } else {
	                $('#PN_Id').focus();
	            }
	        });

	        $('#StockParcialCantidad').prop('type', 'text').prop('readonly', true).insertAfter($('#StockParcial')).addClass('text ui-widget-content ui-corner-all');

	        $('#StockParcial').click(function () {
	            $('#Mezclado,#Stock').prop('checked', false);
	            $('#StockParcialCantidad').prop('readonly', !$('#StockParcial').is(':checked'));
	            if ($('#StockParcial').is(':checked')) {
	                $('#StockParcialCantidad').focus();
	            } else {
	                $('#StockParcialCantidad').val('');
	            }
	        });

	        $('#Stock').click(function () {
	            if ($('#Stock').is(':checked')) {
	                $('#Mezclado,#StockParcial').prop('checked', false);
	                $('#StockParcialCantidad').prop('readonly', true).val('');
	            }
	        });

	        $('#Mezclado').click(function () {
	            if ($('#Mezclado').is(':checked')) {
	                $('#Stock,#StockParcial').prop('checked', false);
	            }
	        });

	        $('#Interna').change(function () {
	            if ($('#OrdenId').val() != '' || $('#Interna').val() == '') return;

	            $('#Entrega').datepicker("setDate", $('#Interna').datepicker('getDate').addDays(1));
	        });

	        $('#Interna,#Entrega').keydown(function (event) {
	            if (event.which == 38) {
	                event.preventDefault();
	                $(this).datepicker("setDate", $(this).datepicker('getDate').addDays(1));
	                $(this).change();
	            } else if (event.which == 40) {
	                event.preventDefault();
	                $(this).datepicker("setDate", $(this).datepicker('getDate').addDays(-1));
	                $(this).change();
	            }
	        });

	        $('#Requerida,#Ordenada').keydown(function (event) {
	            if ($(this).val() == '' || isNaN(parseInt($(this).val()))) return;

	            if (event.which == 38) {
	                event.preventDefault();
	                $(this).val(parseInt($(this).val()) + 1);
	            } else if (event.which == 40 && parseInt($(this).val()) > 0) {
	                event.preventDefault();
	                $(this).val(parseInt($(this).val()) - 1);
	            }
	        });

	        $('#Requerida, #Unitario').change(function () {
	            var req = parseFloat($('#Requerida').val()) || 0.0;
	            var uni = parseFloat($('#Unitario').val()) || 0.0;

	            $('#Total').val((req * uni).toFixed(2));
	        });

	        $.when($.getData(AJAX + '/PageInfo/GetPageEntityList?pageName=PlanosList')).done(function (json) {
	            PLANOS = json.aaData;
	            $('#PN_Id').autocomplete({
	                minLength: 3,
	                source: PLANOS,
	                select: function (event, ui) {
	                    $('#PN_Id').val(ui.item.label);
	                    $('#PN_Id').attr('PlanId', ui.item.value);

	                    return false;
	                },
	                focus: function (event, ui) {
	                    $('#PN_Id').val(ui.item.label);
	                    return false;
	                }
	            });
	        });
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br />
    <div class="catalog"></div>
    <div id="additional_info" style="display:none;">
        <h3 style="margin-top:2px;">Informacion Adicional</h3>
        <table  ="100%" cellspacing="0" cellpadding="2">
            <tbody>
                <tr>
                    <td width="25%">
                        <table id="popularidad_numero_parte_table" width="100%" cellspacing="0" cellpadding="0">
                            <thead>
                                <tr>
                                    <th>Ordenes</th>
                                    <th>Piezas</th>
                                    <th>Stock</th>
                                    <th>Sugerida</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </td>
                    <td width="25%">
                        <table id="popularidad_plano_table" width="100%" cellspacing="0" cellpadding="0">
                            <thead>
                                <tr>
                                    <th>Ordenes</th>
                                    <th>Piezas</th>
                                    <th>Stock</th>
                                    <th>Sugerida</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </td>
                    <td width="25%">
                    </td>
                    <td width="25%">

                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</asp:Content>
