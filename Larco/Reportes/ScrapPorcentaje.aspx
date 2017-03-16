<%@ Page Title="Reporte de Porcentaje de Scrap" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ScrapPorcentaje.aspx.cs" Inherits="BS.Larco.Reportes.ScrapPorcentaje" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Styles/extra_widgets_css","~/Styles/jqplot_css") %>
    <%: Scripts.Render("~/Scripts/extra_widgets_js","~/Scripts/jqplot_js") %>  
    <script type="text/javascript">
        $(document).ready(function () {
            var loading = createLoading();

            $('#FromFilter,#ToFilter').css('width', '74%').datepicker({
                showButtonPanel: true, showOn: "button"
            }).next('button').text('').button({
                icons: {
                    primary: 'ui-icon-calendar'
                },
                text: false
            });

            $('#FromFilter').datepicker('setDate', Date.today().addMonths(-6));
            $('#ToFilter').datepicker('setDate', Date.today());

            createClientMultiselect();            
            createDetailTable();
        });

        function createClientMultiselect() {
            var _opts = {};
            _opts.valField = 'Clave';
            _opts.textField = 'Clave';
            _opts.header = true;
            _opts.filter = true;

            $.page.initMultiselect($('#ClientIdFilter'), _opts);

            $.when($.getData(AJAX + '/PageInfo/GetPageEntityList?pageName=Clientes')).done(function (json) {
                $.page.createSelectOptions($('#ClientIdFilter'), json, _opts);
                $.page.refreshMultiselect($('#ClientIdFilter'));

                var clients = '010,060,062,162,699,799,862,899,999,960'.split(',');
                var options = $('#ClientIdFilter option');

                for (var i = 0; i < options.length; i++) {
                    if (clients.indexOf($(options[i]).val()) == -1) {
                        $(options[i]).attr('selected', 'selected');
                    }
                }

                $.page.refreshMultiselect($('#ClientIdFilter'));
                $('div.catalog').show();

                createPorcentajeScrapGraphs();
                getScrapByTarea();
                getScrapByProduct();
            });

        }

        function createPorcentajeScrapGraphs() {
            $.when(getOrdenesLiberadas(), getOrdenesScrap()).done(function (json1, json2) {
                loading.remove();
                $('#header_table').show();
                

                var liberadas = json1[0].aaData[0] && (json1[0].aaData[0].Ordenes || 0);
                var scrap = json2[0].aaData[0] && (json2[0].aaData[0].Ordenes || 0);

                var array = [];
                array.push(createGraphPoint('Liberadas' + ' - ' +liberadas, parseInt(liberadas)));
                array.push(createGraphPoint('Scrapeadas' + ' - ' + scrap, parseInt(scrap)));

                createPieChart('porcentajeScrap', array, {
                    title: 'Porcentaje de Scrap', reloadCallback: function (current, target, _data) {
                        var detail = current.split(' - ')[0];
                        if(detail == 'Liberadas') {
                            alert('Not Implemented!!');
                            return;
                        }
                        displayDetail(current, target, _data);
                    }
                });

                var liberadasPiezas = json1[0].aaData[0] && (json1[0].aaData[0].Piezas || 0);
                var scrapPiezas = json2[0].aaData[0] && (json2[0].aaData[0].Piezas || 0);

                var arrayPiezas = [];
                arrayPiezas.push(createGraphPoint('Liberadas'+ ' - ' +liberadasPiezas, parseInt(liberadasPiezas)));
                arrayPiezas.push(createGraphPoint('Scrapeadas'+ ' - ' +scrapPiezas, parseInt(scrapPiezas)));

                createPieChart('porcentajeScrapPiezas', arrayPiezas, {
                    title: 'Porcentaje de Scrap Piezas', reloadCallback: function (current, target, _data) {
                        var detail = current.split(' - ')[0];
                        if (detail == 'Liberadas') {
                            alert('Not Implemented!!');
                            return;
                        }

                        displayDetail(current, target, _data);
                    }
                });

            });
        }

        function convertToGraphArray(json, aggregate) {
            var list = [];
            if ($.isArray(json)) {
                log('is array');
                list = json;
            } else {
                list = json.aaData;
            }

            var aggregateField = aggregate.Functions[0].Alias || 'Aggregate';
            var fieldName = aggregate.GroupByFields.split(',')[0];

            list.sort(function (a, b) {
                var a1 = a[fieldName], b1 = b[fieldName];
                if (a1 == b1) return 0;
                return a1 > b1 ? 1 : -1;
            });

            var array = [];
            var length = list.length;
            for (var i = 0; i < length; i++) {
                var obj = list[i];

                obj[fieldName] = obj[fieldName] == '' ? 'None' : obj[fieldName];

                array.push(createGraphPoint(obj[fieldName] + ' - ' + obj[aggregateField], parseInt(obj[aggregateField])));
            }

            return array;
        }

        function getOrdenesLiberadas() {
            return $.ajax({
                url: AJAX + '/PageInfo/GetAggreateEntities?pageName=CalidadOrdenes&searchType=AND&aggregateInfo=' + $.toJSON(getLiberadasAggregate()) + '&entity=' + $.toJSON(getLiberadasEntity()),
                dataType: 'json'
            });
        }

        function getLiberadasAggregate() {
            var aggregate = {};
            aggregate.GroupByFields = '';
            aggregate.Functions = [];
            aggregate.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
            aggregate.Functions.push({ Function: 'SUM', FieldName: 'Ordenada', Alias: 'Piezas' });

            return aggregate;
        }

        function getLiberadasEntity() {
            var entity = {};
            entity.ITS_DTStop = getDateRange();
            entity.ClientId = 'LIST_' + $.trim($('#ClientIdFilter').val());

            return entity;
        }

        function getOrdenesScrap() {
            return $.ajax({
                url: AJAX + '/PageInfo/GetAggreateEntities?pageName=PorcentajeScrap&searchType=AND&aggregateInfo=' + $.toJSON(getScrapAggregate()) + '&entity=' + $.toJSON(getScrapEntity()),
                dataType: 'json'
            });
        }

        function getScrapAggregate() {
            var aggregate = {};
            aggregate.GroupByFields = '';
            aggregate.Functions = [];
            aggregate.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
            aggregate.Functions.push({ Function: 'SUM', FieldName: 'SCR_Cantidad', Alias: 'Piezas'});

            return aggregate;
        }

        function getScrapEntity() {
            var entity = {};
            entity.SCR_Fecha = getDateRange();
            entity.ClientId = 'LIST_' + $.trim($('#ClientIdFilter').val());

            return entity;
        }

        function getDateRange() {
            return $('#FromFilter').val() + '_RANGE_' + $('#ToFilter').val();
        }

        function getScrapByTarea() {
            var aggregate = {};
            aggregate.GroupByFields = 'TareaResponsable';
            aggregate.Functions = [];
            aggregate.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
            aggregate.Functions.push({ Function: 'SUM', FieldName: 'SCR_Cantidad', Alias: 'Piezas' });

            $.ajax({
                url: AJAX + '/PageInfo/GetAggreateEntities?pageName=PorcentajeScrap&searchType=AND&aggregateInfo=' + $.toJSON(aggregate) + '&entity=' + $.toJSON(getScrapEntity()),
                dataType: 'json'
            }).done(function (json) {
                var list = sortAndGroup(json.aaData, 'TareaResponsable');
                createPieChart('scrapByTask', convertToGraphArray(list, aggregate), {
                    title: 'Scrap por Area Responsable', reloadCallback: function (current, target, _data) {
                        displayDetail(current, target, _data);
                    }
                });
            });
        }

        function getScrapByProduct() {
            var aggregate = {};
            aggregate.GroupByFields = 'Producto';
            aggregate.Functions = [];
            aggregate.Functions.push({ Function: 'COUNT', FieldName: '*', Alias: 'Ordenes' });
            aggregate.Functions.push({ Function: 'SUM', FieldName: 'SCR_Cantidad', Alias: 'Piezas' });

            $.ajax({
                url: AJAX + '/PageInfo/GetAggreateEntities?pageName=PorcentajeScrap&searchType=AND&aggregateInfo=' + $.toJSON(aggregate) + '&entity=' + $.toJSON(getScrapEntity()),
                dataType: 'json'
            }).done(function (json) {
                var list = sortAndGroup(json.aaData, 'Producto');
                createPieChart('scrapByProduct', convertToGraphArray(list, aggregate), {
                    title: 'Scrap por Producto', reloadCallback: function (current, target, _data) {
                        displayDetail(current, target, _data);
                    }
                });
            });
        }

        function sortAndGroup(list, fieldName) {
            var countFieldName = 'Ordenes';

            list.sort(function (a, b) {
                var a1 = parseInt(a[countFieldName]), b1 = parseInt(b[countFieldName]);
                if (a1 == b1) return 0;
                return a1 < b1 ? 1 : -1; //desc
            });

            if (list.length > 15) {
                var first14 = list.slice(0, 14);
                var rest = list.slice(14);

                var sum = 0;
                for (var i = 0; i < rest.length; i++) {
                    sum += parseInt((rest[i])[countFieldName]);
                }

                var other = {};
                other[countFieldName] = sum;
                other[fieldName] = OTHER;

                first14.push(other);
                list = first14;
            }
            log(list);
            return list;
        }

        function createDetailTable() {
            var _pageName = 'PorcentajeScrap';
            var _table = '#' + _pageName + '_table';

            $('#detail_page').Page({
                source: AJAX + '/PageInfo/GetPageConfig?pageName=' + _pageName,
                onLoadComplete: function (config) {
                    $(_table).Catalog({
                        pageConfig: config,
                        source: [],
                        showNew: false,
                        showEdit: false,
                        showDelete: false,
                        displayLength: 12,
                        scrollX: '100%',
                        scrollXInner: '200%',
                    });
                }
            });

            $('#detail_dialog').dialog({
                autoOpen: false,
                height: 500,
                width: 1098,
                modal: true,
                show: {
                    effect: 'clip'
                },
                hide: {
                    effect: 'clip'
                }
            });
        }

        function displayDetail(current, target, _data) {
            $('#PorcentajeScrap_table').DataTable().clear().draw();
            var _url = '';
            var title = 'Detalle Scrap';

            var option = $.trim(current.split(' - ')[0]);
            var entity = getScrapEntity();
            if (target.indexOf('scrapBy') != -1) {
                title = title + ' - ' + current;
                var fieldName = $('#' + target).attr('fieldName');
                if (option == OTHER) {

                    var other = $.map($('#' + target + ' td.jqplot-table-legend a'), function (label) {
                        if ($(label).text().indexOf('Otros*') == -1) {
                            return $.trim($(label).text().split(' - ')[0]);
                        }                            
                    }).join(',');

                    entity[fieldName] = 'NOT_LIST_' + other;
                } else {
                    entity[fieldName] = option;
                }
                
            }

            _url = AJAX + '/PageInfo/GetPageEntityList?pageName=PorcentajeScrap&searchType=AND&entity=' + $.toJSON(entity);

            $('#PorcentajeScrap_table').DataTable().ajax.url(_url).load();
            $('#PorcentajeScrap_table').css('width', '100%').DataTable().columns.adjust().draw(); //Fix column width bug in datatables.
            $('#detail_dialog').dialog('option', 'title', title);
            $('#detail_dialog').dialog('open');
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Reporte de Porcentaje de Scrap</h2><br />
    <table id="header_table" class="filter-form ui-widget ui-widget-content ui-corner-all" cellpadding="1" style="padding : 5px;" cellspacing="0" width="100%" style="display:none;">
        <tr>
            <td width="10%">Desde:</td>
            <td width="23.333333333333332%" align="right">
                <input type="text" name="FromFilter" id="FromFilter" class="text ui-widget-content ui-corner-all" filter-type="date-range">
            </td>
            <td width="10%">Hasta:</td>
            <td width="23.333333333333332%" align="right">
                <input type="text" name="ToFilter" id="ToFilter" class="text ui-widget-content ui-corner-all" filter-type="date-range">
            </td>
            <td width="10%">Cliente:</td>
            <td width="23.333333333333332%" align="right">
                <select name="ClientIdFilter" id="ClientIdFilter" class="ui-widget-content ui-corner-all multiselect" multiple="multiple" size="1">
                </select>
            </td>
        </tr>
    </table>
    <div class="catalog" style="display: none;">
        <br />
        <table cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td width="50%">
                    <div id="porcentajeScrap" style="height: 400px"></div>
                </td>
                <td width="50%">
                    <div id="porcentajeScrapPiezas" style="height: 400px"></div>
                </td>
            </tr>
            <tr><td width="100%" colspan="2"><br/></td></tr>
            <tr>
                <td width="50%">
                    <div id="scrapByTask" style="height: 400px" fieldName="TareaResponsable"></div>
                </td>
                <td width="50%">
                    <div id="scrapByProduct" style="height: 400px" fieldName="Producto"></div>
                </td>
            </tr>
            <tr><td width="100%" colspan="2"><br/><br/></td></tr>
            <tr>
                <td width="50%">
                    <div id="scrapByClient" style="height: 400px"></div>
                </td>
                <td width="50%">
                    <div id="scrapByEmployee" style="height: 400px"></div>
                </td>
            </tr>                                    
        </table>
    </div>
    <div id="detail_dialog" style="display:none;" title="Detalle Scrap">
        <div id="detail_page">
        </div>        
    </div>
</asp:Content>
