<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RelacionOrdenCompra.aspx.cs" Inherits="BS.Larco.Reportes.RelacionOrdenCompra" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Styles/extra_widgets_css") %>
    <%: Scripts.Render("~/Scripts/extra_widgets_js") %>  
    <script type="text/javascript">
        const PAGE_NAME = 'RelacionOrdenCompra';
        const TABLE_SEL = '#' + PAGE_NAME + '_table'
        const FILTER_SEL = '#' + PAGE_NAME + '_filter';
        
        $(document).ready(function () {
            bindYear();
            $('div.catalog').Page({
                source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
                onBeforeCreateFilter: function (config) {
                    var length = config.Filter.Fields.length;
                    for (var i = 0; i < length; i++) {
                        var fieldData = config.Filter.Fields[i].FieldData;
                        if (fieldData.FieldName == 'OrderYearFilter') {
                            fieldData.ControlProps = '{"value":"' + Date.today().toString('yyyy') + '"}';
                            fieldData.Type = 'nvarchar';
                        } 
                    }
                },
                onAfterCreateFilter: function (config) {

                },
                onFilterInitComplete: function (config) {
                    selectDefaultClients();

                    var filter = $(FILTER_SEL);
                    $('select.multiselect', filter).multiselect({
                        close: function () {
                            _filterChange(config, filter);
                        }
                    });

                    $('#OrderYearFilter', filter).replaceWith($('#temp #OrderYearFilter'));
                    $('#OrderYearFilter', filter).selectmenu({
                        change: function () {
                            _filterChange(config, filter);
                        }
                    });

                    $('#clearFilter', filter).off('click');
                    $('input[type=text]', filter).off('change keydown');

                    $('#clearFilter', filter).click(function () {
                        $('input,select', this.element).val("");
                        $('select.selectMenu', this.element).selectmenu('refresh', true);
                        $('#OrderYearFilter', filter).val(Date.today().toString('yyyy')).selectmenu('refresh');

                        $('select.multiselect', this.element).each(function (ele) {
                            $(this).multiselect('uncheckAll');
                            $.page.refreshMultiselect($(this));
                        });

                        selectDefaultClients();
                        $(TABLE_SEL).DataTable().clear().draw();
                    });

                    $('input[type=text]', filter).change(function () {
                        _filterChange(config, filter);
                    }).keydown(function () {
                        if ((event.type == 'keydown' && event.keyCode == 13)) {
                            _filterChange(config, filter);
                            event.preventDefault();
                        }
                    });

                },
                onLoadComplete: function (config) {
                    $('h2').text(config.Title);
                    document.title = config.Title;
                    initializeCatalog(config);
                }
            });
        });

        function selectDefaultClients() {
            var clients = '010,060,062,162,699,799,862,899,999,960'.split(',');
            var options = $('#ClientIdFilter option');

            for (var i = 0; i < options.length; i++) {
                if (clients.indexOf($(options[i]).val()) == -1) {
                    $(options[i]).attr('selected', true);
                    $(options[i]).selected = true;
                } 
            }
            
            $.page.refreshMultiselect($('#ClientIdFilter'));
        }

        function _filterChange(config, filter) {
            var prevFilter = filter.Filter('getFilter');
            log(prevFilter);

            var newFilter = $.page.filter.createFilter($(FILTER_SEL));
            $.each(newFilter, function (key, val) {
                if (val && val.indexOf('LIST_') == -1 && val.indexOf('_RANGE_') == -1) {
                    var field = getField(config, key);
                    var props = {};

                    if (field && field.ControlProps) {
                        props = $.evalJSON(field.ControlProps);
                    }

                    if (!(props['search-type'] && props['search-type'] == 'equals')) {
                        newFilter[key] = 'LIKE_' + val;
                    }                    
                }
            });

            log(newFilter);
            if ($.toJSON(prevFilter) == $.toJSON(newFilter)) return;

            $(TABLE_SEL).DataTable().clear().draw();
            $(TABLE_SEL + '_processing').show();
            var _url = AJAX + '/PageInfo/GetPageEntityList?pageName=' + PAGE_NAME;
            filter.Filter('setFilter', newFilter);

            _url += '&searchType=AND&entity=' + $.toJSON(newFilter);
            return $.ajax({
                url: _url
            }).done(function (json) {
                $(TABLE_SEL + '_processing').hide();

                if (json.ErrorMsg) {
                    alert('No fue posible traer la informacion requerida.');
                    log(json.ErrorMsg);
                    return;
                }

                if (json.aaData.length > 2000) {
                    if (confirm('El resultado de la busqueda es muy grande y se tomara algunos segundos desplegarlos en la pantalla, Quieres continuar de cualquier manera?') == false)
                        return false;
                }

                log(json.aaData.length);
                $('#RelacionOrdenCompra_table').DataTable().rows.add(json.aaData).draw();
            });


            
        }

        function bindYear() {
            var start = Date.today().addYears(-4).set({ day: 1, month: 0 });
            var end = Date.today().set({ day: 1, month: 0 });

            while (start.compareTo(end) < 0) {
                start = start.addYears(1);
                var opt = $('<option></option>').attr('value', start.toString('yyyy')).text(start.toString('yyyy'));
                if (start.compareTo(end) == 0) opt.attr('selected', 'true');
                $('#temp #OrderYearFilter').append(opt);
            }
        }

        function buildRequestFilter(config, opts) {
            log(opts);
            log(config);
            var filter = { draw: 1, columns: [], order: [], start: 0, length: -1, search: { value: '', regex: false } };

            for (var o = 0; o < opts.order.length; o++) {
                var order = {};
                order.column = opts.order[o][0];
                order.dir = opts.order[o][1];
                filter.order.push(order);
            }

            for (var c = 0; c < opts.columns.length; c++ ) {
                var col = opts.columns[c];
                var column = { search: { value: '', regex: false }, orderable: true };
                column.data = col.data;
                column.name = col.name;
                column.searchable = col.searchable;
                filter.columns.push(column);
            }

            log($.toJSON(filter));
            return filter;
        }

        function initializeCatalog(config) {
            $(TABLE_SEL).Catalog({
                serverSide: false,
                pageConfig: config,
                processing: true,
                paginate: false,
                source:[],
                filter : false,
                //viewOnly:true,
                showEdit: false,
                showNew: false,
                showDelete: false,
                showExport: true,
                scrollY: '600px',
                scrollX: '100%',
                scrollXInner: '200%',
                initCompleteCallBack: function () {
                    $(TABLE_SEL + '_processing').css('z-index', '10').css('color', 'black');

                    $(TABLE_SEL).on('draw.dt', function () {
                        //TODO: calculate totals
                        console.log('Redraw occurred at: ' + new Date().getTime());
                    });

                }
            });
        }

        function getField(config, fieldName) {
            for (var i = 0; i < config.Tabs.length; i++) {
                var tab = config.Tabs[i];
                for (var f = 0; f < tab.Fields.length; f++) {
                    var field = tab.Fields[f];
                    if (field.FieldName == fieldName) {
                        return field;
                    }
                }
            }

            return null;
        }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br/>
    <div class="catalog"></div>
    <div id="temp" style="display:none"><select id="OrderYearFilter" name="OrderYearFilter" class="selectMenu"></select></div>
</asp:Content>
