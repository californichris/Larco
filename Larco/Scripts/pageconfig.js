var carousel;
var tabs;
var tab_items;
var catalog;

$(document).ready(function () {    
    carousel = $('#my-carousel').carousel({ pagination: false, nextPrevLinks: false, speed: 'fast' });
    $('#page_dialog fieldset').css('margin-top', '0px');

    $('#Type').addClass('selectMenu').selectmenu();
    $('#ControlType').addClass('selectMenu').selectmenu();

    $('#searchFields').on('input', function () {
        var _search = $('#searchFields').val().toUpperCase();
        var not = false;
        if (_search.substring(0, 1) == '!') {
            not = true;
            _search = _search.substring(1);
        }

        $('#tabs li.field').css('opacity', 1);

        var results = jQuery.grep($('#tabs li.field'), function (field, i) {
            var _data = $.evalJSON($(field).attr('data'));
            var found = false;

            if (_search == 'ISID') {
                found = !isTrue(_data.IsId);
            } else if (_search == 'REQUIRED') {
                found = !isTrue(_data.Required);                
            } else if (_search == 'EXPORTABLE') {
                found = !isTrue(_data.Exportable);
            } else if (_search == 'INSERTABLE') {
                found = !isTrue(_data.Insertable);
            } else if (_search == 'UPDATABLE') {
                found = !isTrue(_data.Updatable);
            } else {
                found = _data.FieldName.toUpperCase().indexOf(_search) == -1 && _data.Label.toUpperCase().indexOf(_search) == -1 &&
                    _data.DBFieldName.toUpperCase().indexOf(_search) == -1 && _data.Type.toUpperCase().indexOf(_search) == -1 &&
                    _data.ControlType.toUpperCase().indexOf(_search) == -1 && _data.JoinInfo.toUpperCase().indexOf(_search) == -1 &&
                    _data.DropDownInfo.toUpperCase().indexOf(_search) == -1 && _data.ControlProps.toUpperCase().indexOf(_search) == -1;
            }

            found = not ? !found : found;

            return found;
        });

        $(results).css('opacity',.25);
    });

    var configTabs = $('#configtabs').tabs({
        activate: function (event, ui) {
            $('.add-btns, .filter-btns').hide();

            if ('Dialog' == ui.newTab.find('a').text()) {
                $('.add-btns').show();
                if ($('#configtabs-2 ul.connectedSortable li.ui-state-default table').length > 0) {
                    var _width = $($('#configtabs-2 ul.connectedSortable li.ui-state-default table')[0]).width()
                    $('#configtabs-2 ul.connectedSortable li.ui-state-default table div.nowrap').width((_width - 64 - 25));
                }

                $('#tabs').trigger('tabchange');
            } else if ('Filter' == ui.newTab.find('a').text()) {
                $('.filter-btns').show();
            }
        }
    });

    $.page.initSelectMenu('#ConnName');
    $.when($.getData(AJAX_CONTROLER_URL + '/PageInfo/GetConnections')).done(function (json) {
        var ddInfo = {};
        ddInfo.fieldName = 'ConnName'
        ddInfo.valField = 'ConnName';
        ddInfo.textField = 'ConnName';
        ddInfo.onChange = connNameChange;

        $.page.createSelectMenuOptions($('#ConnName'), json, ddInfo);
    });

    $.when($.getData(AJAX_CONTROLER_URL + '/PageInfo/GetTables?ConnName=')).done(function (json) {
        $('#TableName').ComboBox({
            list: json.aaData,
            sortByField: 'Name', valField: 'Name', textField: 'Name', removedInvalid: false,
            onCreateComplete: function () {
                $('#TableName_combobox_wrapper').css('width', '96.5%');
            }
        });
    });
    

    var btnsTab = $('<li style="width:770px"></li>');
    btnsTab.append('<table width="100%" cellpadding="0" cellspacing="0" border="0"><tbody><tr><td valign="middle" align="right"></td></tr></tbody></table>');
    btnsTab.find('td').append('<div style="width:520px; float: left;"><p class="validateTips ui-corner-all" id="validateTips" style="margin:0px 0px 0px 2px;text-align: left;"></p></div>');
    btnsTab.find('td').append('<button class="add-btns" id="addPageTab" onclick="return false;" title="Add tab">Tab</button>');
    btnsTab.find('td').append('<button class="add-btns" id="addPageField" onclick="return false;" title="Add field to current tab">Field</button>');
    btnsTab.find('td').append('<button class="add-btns" id="addPageFieldFromDB" onclick="return false;" title="Add fields from DB to current tab">Field From DB</button>');
    btnsTab.find('td').append('<button class="filter-btns" id="editFilter" onclick="return false;" title="Edit Filter">Edit Filter</button>');
    btnsTab.find('td').append('<button id="previewPage" onclick="return false;" title="Preview Page">Preview</button>');
    btnsTab.find('td').append('<button id="savePage" onclick="return false;" title="Save page configuration">Save</button>');
    btnsTab.find('td').append('<button id="cancelPage" onclick="return false;" title="Discard any changes to the page">Cancel</button>');

    $('#configtabs-nav').append(btnsTab);
    $('.add-btns, .filter-btns').hide();

    createDialogs();

    $('#previewPage').button({ icons: { primary: "ui-icon-play" }, text: false }).click(function () {
        if ($('#PageId').val() == '') {
            alert('You need to save the page first.');
            return;
        }

        window.open('preview.aspx?pageName=' + $('#Name').val(), '_blank');
    });

    $('#tabscrollleft').button({ icons: { primary: "ui-icon-triangle-1-w" }, text: false }).click(function () {
        var _scroll = $('#tabsection').scrollLeft() - 380;
        $('#tabsection').animate({ scrollLeft: _scroll }, 900);
    });
    $('#tabscrollright').button({ icons: { primary: "ui-icon-triangle-1-e" }, text: false }).click(function () {
        var _scroll = $('#tabsection').scrollLeft() + 380;
        $('#tabsection').animate({ scrollLeft: _scroll }, 900);
    });

    //Create page catalog
    catalog = $('#pages').Catalog({
        fieldId: 'PageId',
        dialogSelector: '', // no dialog
        columns: [
	        { "mDataProp": "Name", "sName": "Name", "bVisible": true, "bSearchable": true },
	        { "mDataProp": "Title", "sName": "Title", "bVisible": true, "bSearchable": true },
	        { "mDataProp": "TableName", "sName": "TableName", "bVisible": true, "bSearchable": true },
            { "mDataProp": "ConnName", "sName": "ConnName", "bVisible": true, "bSearchable": true }
	    ],
        displayLength: 18,
        source: AJAX_CONTROLER_URL + "/PageInfo/GetPageList",
        saveRequest: AJAX_CONTROLER_URL + '/PageInfo/SavePage',
        deleteRequest: AJAX_CONTROLER_URL + '/PageInfo/DeletePage',
        newEntityCallBack: function (oTable, options) {
            $('#page_dialog input, #page_dialog select').val('').removeClass('ui-state-error');
            $('#page_dialog input[type=checkbox]').prop('checked', false);

            $('#Connection').val('Default');
            configTabs.tabs("option", "active", 0);

            carousel.data('carousel').moveToItem(1);
        },
        editEntityCallBack: function (oTable, options) {
            $('#page_dialog input, #page_dialog select').val('').removeClass('ui-state-error');
            $('#page_dialog input[type=checkbox]').prop('checked', false);

            carousel.data('carousel').moveToItem(1);
            var row = getSelectedRowData(oTable);
            populateDialog(row, '#page_dialog');
            configTabs.tabs('option', 'active', 0);            

            $.getJSON(
                AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageId=' + row['PageId']
            ).done(function (json) {
                if (json.ErrorMsg) {
                    alert(json.ErrorMsg);
                    return;
                }

                createPage(json);
            }).fail(function (jqXHR, textStatus, errorThrown) {
                var json = eval('(' + jqXHR.responseText + ')');
                if (json.ErrorMsg) {
                    alert(json.ErrorMsg);
                    return;
                }
            });
        },
        initCompleteCallBack: function (oTable, oSettings, json, options) {
            appendPreviewBtnToMainTable(oTable);
        }
    });

    //Bind an click handler to the save button
    $('#savePage').button({ icons: { primary: "ui-icon-disk" }, text: false }).click(function (event) {
        var valid = true;
        var tips = $('#validateTips').text("").removeClass('ui-state-highlight').removeClass('ui-state-error');
        valid = valid && checkRequired(tips, $('#Name'), "Name");
        valid = valid && checkRequired(tips, $('#Title'), "Title");
        if ($('#TableName').ComboBox('value') == '') {
            tips.text('Table Name is required.').addClass("ui-state-highlight");
            valid = false;
        }

        if (!valid) return;

        var page = {};
        page.PageId = $('#PageId').val();
        page.Name = $('#Name').val();
        page.Title = $('#Title').val();
        page.TableName = $('#TableName').ComboBox('value');
        page.ConnName = $('#ConnName').val();
        page.Tabs = [];

        //setting grid columns order
        $('#grid-columns li.ui-state-default').each(function (colIndex) {
            var col = $.evalJSON($(this).attr('data'));
            col.ColumnOrder = colIndex + 1;
            $(this).attr('data', $.toJSON(col));
        });

        var idFound = false;
        $('#tabs ul.ui-tabs-nav li').each(function (tabIndex) {
            var tab = $.evalJSON($(this).attr('data'));
            tab.TabOrder = (tabIndex + 1); //setting new order
            tab.Fields = [];

            var tabContainerSelector = $('a.ui-tabs-anchor', $(this)).attr('href');
            var cols = $(tabContainerSelector + ' ul').length;

            $(tabContainerSelector + ' ul').each(function (colIndex) {
                $('li', $(this)).each(function (findex) {
                    var field = $.evalJSON($(this).attr('data'));
                    var order = (colIndex + 1) + (cols * findex);

                    // setting tabId and order.
                    // in case it was move to a different tab or the order change.
                    field.TabId = tab.TabId;
                    field.FieldOrder = order;

                    var columnId = '#' + $(this).attr('id') + '-grid-column';
                    if (exists(columnId)) {
                        var column = $.evalJSON($(columnId).attr('data'));
                        field.ColumnInfo = column;
                    }

                    if (field.IsId == 'True' || field.IsId == '1') idFound = true;
                    tab.Fields.push(field);
                });
            });

            page.Tabs.push(tab);
        });

        if (!idFound) {
            updateTips(tips, 'You must specify a field as Id.', true);
            return;
        }

        if ($('#filter-fields-empty').length == 0) {
            page.Filter = getObject('#filter_dialog');
            page.Filter.Fields = [];
            var order = 1;
            $('#filter-fields li').each(function () {
                var field = {};
                field.FieldId = $(this).attr('filter-fieldid');
                field.FilterOrder = order++;
                page.Filter.Fields.push(field);
            });
        }

        $.post(AJAX_CONTROLER_URL + '/PageInfo/SavePage', 'entity=' + encodeURIComponent(JSON.stringify(page)))
        .done(function (json) {
            if (json.ErrorMsg == SUCCESS) {
                showSuccess(tips, 'Page configuration succesfully saved.', true);
                realodPage(json.Id);
            } else {
                showError(tips, json.ErrorMsg, true);
            }
        }).fail(function (jqXHR, textStatus, errorThrown) {
            var json = eval('(' + jqXHR.responseText + ')');
            if (json.ErrorMsg) {
                alert(json.ErrorMsg);
                return;
            }
        });
    });

    //Bind a click handler to the cancel button
    $('#cancelPage').button({ icons: { primary: "ui-icon-close" }, text: false }).click(function (event) {
        $('#field_list_dialog').dialog('close');

        catalog.Catalog('reloadTable');
        carousel.data('carousel').moveToItem(0);

        removeTabEvents();

        if (tab_items != null) {
            tab_items = null;
        }

        $('#validateTips').removeClass('ui-state-highlight').text('');

        clearDialogSection();
        $('#ConnName').val('').selectmenu('refresh');
    });

    //Bind an click handler to the add tab button
    $('#addPageTab').button({ icons: { primary: "ui-icon-plus", secondary: "ui-icon-newwin" }, text: false }).click(function () {
        $('#tab_dialog').dialog('open');
    });

    //Bind an click handler to the add field button
    $('#addPageField').button({ icons: { primary: "ui-icon-plus", secondary: "ui-icon-field" }, text: false }).click(function () {
        if (tabs == null || tabs.find('.ui-tabs-nav li').length == 0) {
            alert('Must add a tab first.');
            return;
        }

        $('#field_dialog').dialog('open');
    });


    var fieldTable = $('#field_list').DataTable({
        jQueryUI: true,
        paging: false,
        info: false,
        searching: false,
        processing: true,
        ordering: true,
        columns: [
            { "data": "Name", "name": "Name", "visible": true, "sortable": true, "searchable": true },
            { "data": "Type", "name": "Type", "visible": true, "sortable": true, "searchable": true },
            { "data": "Required", "name": "Required", "visible": true, "sortable": true, "searchable": true },
            { "data": "Name", "name": "Name", "visible": true, "sortable": false, "searchable": true }
        ],
        order: [[0, 'asc']],
        rowCallback: function (nRow, aData, iDisplayIndex) {
            jQuery(nRow).attr("Name", aData.Name);
            jQuery('td:eq(3)', nRow).html('<span class="ui-icon ui-icon-plus" title="Add to current tab."></span>');

            return nRow;
        }
    });

    $('#field_list_dialog .fg-toolbar').remove();

    $('#addPageFieldFromDB').button({ icons: { primary: "ui-icon-plus", secondary: "ui-icon-db" }, text: false }).click(function () {
        if (tabs == null || tabs.find('.ui-tabs-nav li').length == 0) {
            alert('Must add a tab first.');
            return;
        }

        $('#field_list_dialog').dialog('open');
        $('#field_list').undelegate("span.ui-icon-plus", "click");

        var newSource = AJAX_CONTROLER_URL + '/PageInfo/GetTableColumns?tableName=' + $('#TableName').val() + '&connName=' + $('#ConnName').val();
        fieldTable.ajax.url(newSource).load(function () {
            $('#field_list').delegate("span.ui-icon-plus", "click", function (event) {              
                var targetEle = event.target || event.srcElement;
                var tr = targetEle;
                if (targetEle.nodeName != 'TR') {
                    tr = $(targetEle).parentsUntil('tbody', 'tr')[0];//targetEle.parentNode; 
                }

                var _name = $(tr).attr('Name');
                var _data = fieldTable.data();
                addDBFieldToDialog(_name, _data);                
            });
        });
    });

    $('#editFilter').button({ icons: { primary: "ui-icon-pencil" }, text: false }).click(function () {
        $('#filter_dialog').dialog('open');
    });
});

function connNameChange() {
    var currVal = $('#TableName').ComboBox('value');
    $.when($.getData(AJAX_CONTROLER_URL + '/PageInfo/GetTables?ConnName=' + $('#ConnName').val())).done(function (json) {
        $('#TableName').ComboBox('reload', {
            list: json.aaData,
            onLoadComplete: function () {
                $('#TableName').ComboBox('value', currVal);
            }
        });
    });
}

function addDBFieldToDialog(name, _tableData) {
    var data = {};
    for (var i = 0; i < _tableData.length; i++) {
        if (_tableData[i].Name == name)
            data = _tableData[i];
    }

    if (!$.isEmptyObject(data)) {
        clearDialog('#field_dialog');

        //Setting default values before calling the saveField method
        $('#FieldName').val(data.Name);
        $('#DBFieldName').val(data.Name);
        $('#Label').val(data.Name);
        $('#Type').val(data.Type.toLowerCase());
        $('#ControlType').val('inputbox');
        if (data.Type == 'bit') $('#ControlType').val('checkbox');
        $('#Required').prop('checked', data.Required == 'NO');
        $('#Exportable').prop('checked', true);
        $('#Insertable').prop('checked', true);
        $('#Updatable').prop('checked', true);
        $('#DropDownInfo').val('');
        $('#JoinInfo').val('');

        if (!validateField($('#field_list_dialog p.validateTips'))) return;

        saveField();
    } else {
        log('Upps!! field not found in the list, this should never happend..');
    }
}

function appendPreviewBtnToMainTable(oTable) {
    var btn = $('<button onclick="return false;" class="disable" title="Preview Page">Preview</button>');
    btn.button({ icons: { primary: "ui-icon-play" } }).click(function (event) {
        var data = getSelectedRowData(oTable);
        window.open('preview.aspx?pageName=' + data.Name, '_blank');
    }).button('disable');

    $('#pages').Catalog('getButtonSection').append(btn);
}

function realodPage(pageId) {
    $('#field_list_dialog').dialog('close');

    removeTabEvents();

    if (tab_items != null) {
        tab_items = null;
    }

    clearDialogSection();
    $('#page_dialog input, #page_dialog select').val('').removeClass('ui-state-error');
    $('#page_dialog input[type=checkbox]').prop('checked', false);

    $.getJSON(
        AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageId=' + pageId
    ).done(function (json) {
        if (json.ErrorMsg) {
            alert(json.ErrorMsg);
            return;
        }

        populateDialog(json, '#page_dialog');
        createPage(json);
    }).fail(function (jqXHR, textStatus, errorThrown) {
        var json = eval('(' + jqXHR.responseText + ')');
        if (json.ErrorMsg) {
            alert(json.ErrorMsg);
            return;
        }
    });
}

function clearDialogSection() {
    $('#tabs div.dialogtab').remove();
    $('#tabsection').html('');
    $('#tabscrollsection').hide();    
}

function removeTabEvents() {
    if (tabs == null) return;

    tabs.undelegate(".ui-tabs-nav span.ui-icon-close", "click");
    tabs.undelegate(".ui-tabs-nav span.ui-icon-pencil", "click");

    tabs.undelegate(".connectedSortable span.ui-icon-close", "click");
    tabs.undelegate(".connectedSortable span.ui-icon-pencil", "click");
    tabs.undelegate(".connectedSortable span.ui-icon-plus", "click");

    tabs.tabs('destroy');
    tabs = null;

    $('#grid-columns').sortable('destroy');
    $('#grid-columns').html('');
    $('#grid-columns').append('<li id="grid-columns-empty">No fields have been added to the grid.</li>');

    $("#grid-columns").undelegate("li span.ui-icon-close", "click");
    $("#grid-columns").undelegate("li span.ui-icon-pencil", "click");
    $("#grid-columns").undelegate("li span.ui-icon-plus", "click");

    $('#filter-fields').sortable('destroy');
    $('#filter-fields').html('');
    $('#filter-fields').append('<li id="filter-fields-empty">No fields have been added to the filter.</li>');

    $("#filter-fields").undelegate("li span.ui-icon-close", "click");
}

function createPage(json) {
    createTabs(json);
    createFilter(json);    
    $('#Name').focus();
    connNameChange();

    if ($('#configtabs-2 ul.connectedSortable li.ui-state-default table').length > 0) {
        var _width = $($('#configtabs-2 ul.connectedSortable li.ui-state-default table')[0]).width()
        $('#configtabs-2 ul.connectedSortable li.ui-state-default table div.nowrap').width((_width - 64 - 20));
    }

    $('#tabs').trigger('tabchange');
}

function createFilter(json) {
    clearDialog('#filter_dialog');
    var dialog = $('#filter_dialog');
    $('#FilterText', dialog).val('Filter');
    $('#FilterCols', dialog).val('1');
    $('#ShowClear', dialog).prop('checked', true);

    var filter = json.Filter;
    if (!filter) return;

    populateDialog(filter, '#filter_dialog');

    var length = filter.Fields.length;
    $('#filter-fields').html('');
    for (var i = 0; i < length; i++) {
        var field = filter.Fields[i];
        var data = $.evalJSON($('#configtabs-2 li[fieldid=' + field.FieldId + ']').attr('data'));
        $('#filter-fields').append(createFilterField(data));
    }    
}

function createDialogs() {
    //Creating tab dialog
    $('#tab_dialog').dialog({
        autoOpen: false,
        modal: true,
        width: '350px',
        buttons: [
            {
                id: "button-save", text: "Save",
                click: function () {
                    var valid = true;
                    var tips = $('#tab_dialog p.validateTips');
                    valid = valid && checkRequired(tips, $('#TabName'), "Name");
                    //valid = valid && checkAlpha(tips, $('#TabName'), "Name");
                    valid = valid && checkRequired(tips, $('#Cols'), "Colums");
                    valid = valid && checkInt(tips, $('#Cols'), "Colums");

                    if (!valid) return;

                    saveTab();
                    $(this).dialog("close");
                }
            },
            {
                id: "button-cancel", text: "Cancel",
                click: function () {
                    $(this).dialog("close");
                }
            }
            ],
        close: function () {
            clearDialog("#tab_dialog");
        }
    });

    //cleaning dialog
    clearDialog("#tab_dialog");

    $('#field_dialog').dialog({
        autoOpen: false,
        modal: true,
        width: '800',
        height: '470',
        buttons: [
            {
                id: "button-save", text: "Save",
                click: function () {
                    if (!validateField($('#field_dialog p.validateTips'))) return;
                    
                    saveField();
                    $(this).dialog("close");

                }
            },
            {
                id: "button-cancel", text: "Cancel",
                click: function () {
                    $(this).dialog("close");
                }
            }
            ],
        close: function () {
            clearDialog('#field_dialog');
            createJsonTable('#ji-container', true);
            createJsonTable('#ddi-container', true);
            createJsonTable('#prop-container', true);
        }
    });

    clearDialog('#field_dialog');
    $('#field_tabs').tabs();
    createJoinAndDropDownInfoHandlers();

    $('#column_prop_dialog').dialog({
        autoOpen: false,
        modal: true,
        width: '350px',
        buttons: [
            {
                id: "button-save", text: "Save",
                click: function () {
                    //TODO: validate
                    var colId = $('#ColumnNav').val();
                    var data = getObject('#column_prop_dialog');
                    if ($(colId).length != 0) {
                        var li = $(colId);
                        $('span:first-child', li).text(data.ColumnLabel);
                        li.attr('data', $.toJSON(data));                      
                    } else {
                        var li = createColumn(data);

                        li.attr('id', colId.replace('#', ''));                        
                        $('#grid-columns').append(li);                   
                    }

                    $(this).dialog("close");
                }
            },
            {
                id: "button-cancel", text: "Cancel",
                click: function () {
                    $(this).dialog("close");
                }
            }
            ],
        close: function () {
            clearDialog("#column_prop_dialog");
        }
    });

    clearDialog("#column_prop_dialog");

    $('#field_list_dialog').dialog({
        autoOpen: false,
        modal: false,
        width: '480',
        height: '400',
        buttons: [
            {
                id: "add-all-fields", text: "Add All",
                click: function () {
                    var _data = $('#field_list').DataTable().data();
                    var _rows = $('#field_list tbody tr');

                    for (var i = 0; i < _rows.length; i++) {
                        var _row = $(_rows[i]);
                        addDBFieldToDialog(_row.attr('Name'), _data);
                    }
                }
            },
            {
                id: "button-close", text: "Close",
                click: function () {
                    $(this).dialog("close");
                }
            }
            ],
        close: function () {
            clearDialog("#field_list_dialog");
        }
    });

    clearDialog("#field_list_dialog");

    $('#filter_dialog').dialog({
        autoOpen: false,
        modal: true,
        width: '400',
        buttons: [
            {
                id: "button-save", text: "Save",
                click: function () {
                    $(this).dialog("close");
                }
            }
        ],
        close: function () { }
    });
}

function createJoinAndDropDownInfoHandlers() {
    $('div.container button.json').button().click(function () {
        var parent = $(this).parentsUntil('div.modal-form', 'div.container');
        if ($(this).button('option', 'label') == 'json') {
            $(this).button('option', 'label', 'Table').attr('title', 'Show table format');
            $('div.tableformat', parent).hide();
            $('div.jsonformat', parent).show();
            $('button.disable', parent).button('disable');
        } else {
            $(this).button('option', 'label', 'json').attr('title', 'Show json format');
            $('div.tableformat', parent).show();
            $('div.jsonformat', parent).hide();
            $('button.disable', parent).button('disable');

            clearTableFields('#' + $('div.tableformat', parent).attr('id'));
            createJsonTable('#' + $(parent).attr('id'), false);
        }
    }).css('margin-left','4px');
   
    createJsonTable('#ji-container', false);
    createJsonTable('#ddi-container', false);
    createJsonTable('#prop-container', false);

    $('#ji-property').selectmenu().selectmenu("widget").css('margin-bottom', '2px').css('height', '23px');
    $('#ddi-property').selectmenu().selectmenu("widget").css('margin-bottom', '2px').css('height', '23px');

    $('div.container button.save').button().click(function () {
        var parent = $(this).parentsUntil('div.modal-form', 'div.container');

        //validating data
        if ($('input.property, select.property', parent).val() == '') {
            alert('Property is requeried.');
            return;
        }

        var value = '';
        if ($('input.value', parent).val() == '') {
            alert('Value is requeried.');
            return;
        }

        if ($('input[type=hidden]', parent).val() == 'SAVE') {
            var table = $('table.detail', parent);
            if ($('tr[id=' + $('input.property, select.property', parent).val() + ']', table).length > 0) {
                alert('Property already exists.');
                return;
            }
        }

        //getting value
        value = $('input.value', parent).val();        

        //updating json object
        var obj = {};
        if ($('textarea', parent).val() != '') {
            obj = jQuery.parseJSON($('textarea', parent).val());
            obj[$('input.property, select.property', parent).val()] = value;
        } else {
            obj[$('input.property, select.property', parent).val()] = value;
        }
        $('textarea', parent).val($.toJSON(obj));

        //populate table and clear fields
        createJsonTable('#' + $(parent).attr('id'), false);
        clearTableFields('#' + $('div.tableformat', parent).attr('id'));
    });

    $('div.container button.edit').button().click(function () {
        var parent = $(this).parentsUntil('div.modal-form', 'div.container');
        var data = getSelectedRowData($('table.detail', parent).DataTable());

        $('select.property, input.property', parent).val(data.Property);
        $('select.value, input.value', parent).val(data.Value);

        $('select', parent).selectmenu('refresh', true);
        $('input[type=hidden]', parent).val('EDIT');
        $('button.add',parent).attr('title', 'Save existing property');
    }).button('disable');

    $('div.container button.delete').button().click(function () {
        var parent = $(this).parentsUntil('div.modal-form', 'div.container');
        var data = getSelectedRowData($('table.detail', parent).DataTable());
        var obj = jQuery.parseJSON($('textarea', parent).val());
        delete obj[data.Property]; //delete property from json

        $('textarea', parent).val($.toJSON(obj));
        $('button.disable', parent).button('disable');

        //populate join info table
        createJsonTable('#' + $(parent).attr('id'), false);
    }).button('disable');

}

function createJsonTable(selector, displayTable) {
    var jsonBtn = $(selector + ' button.json');
    if (displayTable) {
        jsonBtn.button('option', 'label', 'Table');
        jsonBtn.click();
        return;
    }

    var tableOptions = {
        jQueryUI: true, paging: false,
        info: false, searching: false,
        ordering: false, destroy: true,
        columns: [
            { "data": "Property", "name": "Property", "visible": true, "searchable": false, "sortable": true, "width": "120px" },
            { "data": "Value", "name": "Value", "visible": true, "searchable": false, "sortable": false, "width": "600px" }
        ],
        rowCallback: function (nRow, aData, iDisplayIndex) {
            jQuery(nRow).attr("id", aData['Property']);
            jQuery('td:eq(0)', nRow).html('<div style="white-space: nowrap; overflow: hidden; width: 120px" >' + aData['Property'] + '</div>');
            jQuery('td:eq(1)', nRow).html('<div style="white-space: nowrap; overflow: hidden; width: 600px" >' + aData['Value'] + '</div>');
            return nRow;
        }
    };

    var textArea = $(selector + ' textarea');
    var oTable = $(selector + ' table.detail').DataTable(tableOptions).clear().draw();
    $(selector + ' table.detail').parent().find('.fg-toolbar').remove();

    if ($(textArea).val() != '') {
        var obj = jQuery.parseJSON($(textArea).val());
        $.each(obj, function (key, value) {
            var r = {'Property' : key, 'Value' : value};
            oTable.row.add(r).draw();
        });
    }

    oTable.off('click');
    oTable.on('click', 'tr', function () {
        if (exists('#' + $(selector + ' table.detail').attr('id') + ' td.dataTables_empty')) return;

        selectRow(oTable, this);
        if ($(selector + ' button.edit').hasClass('ui-button-disabled')) {
            clearTableFields('#' + $(selector + ' div.tableformat').attr('id'));
        }
    });
}

function clearTableFields(selector) {
    $(selector + ' input, ' + selector + ' select').val('')
    $(selector + ' select').selectmenu('refresh', true);
    $(selector + ' button').attr('title', 'Save new property');
    $(selector + ' input[type=hidden]').val('SAVE');
}

function createTabs(config) {
    if(config == null || config.Tabs == null || typeof config.Tabs == 'undefined' || config.Tabs.length == 0) return;

    var pageTabs = config.Tabs;
    var ul = $('<ul></ul>');
    $('#tabsection').append(ul);
            
    for (var i = 0; i < pageTabs.length; i++) {
        //cloning tab data to store it in the html element without fields data                
        var newTab = $.evalJSON($.toJSON(pageTabs[i])); 
        newTab.Fields = [];

        var tabContent = createTab(ul, newTab, (i + 1));
        appendTabContent(pageTabs[i], tabContent);

        $('#tabs').append(tabContent);
    }

    createTabEvents();
    createGridColumns(config);
}

function createGridColumns(config) {
    if (config.GridFields.length > 0) {
        $('#grid-columns').html('');
    }

    config.GridFields.sort(function (a, b) {
        var a1 = parseInt(a.ColumnOrder), b1 = parseInt(b.ColumnOrder);
        if (a1 == b1) return 0;
        return a1 > b1 ? 1 : -1;
    }); 

    for (var i = 0; i < config.GridFields.length; i++) {
        var data = config.GridFields[i];
        var li = createColumn(data);

        var colId = $('#tabs li[fieldid=' + data.FieldId + ']').attr('id');
        li.attr('id', colId + '-grid-column');
        
        $('#grid-columns').append(li);
    }    
}

function createTab(ul, tab, index) {
    var li = $('<li id="tabs-' + index + 'TabNav"><a href="#tabs-' + index + '">' +
        '<div style="width:115px;" class="nowrap" title="' + tab.TabName + '"><span style="white-space: nowrap">' + tab.TabName + '</span></div></a>' +
        '<span class="ui-icon ui-icon-pencil" title="Edit Tab">Edit Tab</span>' +
        '<span class="ui-icon ui-icon-close"  title="Delete Tab">Delete Tab</span>' +
        '</li>');
    li.attr('data', $.toJSON(tab));
                
    $(ul).append(li);

    return $('<div id="tabs-' + index + '" style="height:370px;overflow: auto;" class="dialogtab"></div>');
}

function appendTabContent(tabConfig, tabContent) {
    var colWidth = 100 / tabConfig.Cols;
    for (var c = 0; c < tabConfig.Cols; c++) {
        $(tabContent).append('<ul id="' + getColName(tabConfig.TabName, c) + '" class="connectedSortable ui-helper-reset" style="width:' + colWidth + '%;"></ul>');
    }
            
    for (var f = 0; f < tabConfig.Fields.length; f++) {
        var colNum = f % tabConfig.Cols;               
        $('#' + getColName(tabConfig.TabName, colNum), tabContent).append(createField(tabConfig.Fields[f]));
    }

    $('#tabs').trigger('tabchange');
}

function getColName(tabName, num) {
    return tabName.replace(/[^A-Z0-9]/ig, '') + '_Col_' + num;
}

function createField(field) {
    var _label = field.Label;

    var li = $('<li class="ui-state-default field">' +
        '<table width="100%" cellspacing="0" cellpadding="0"><tr>' +
        '<td>' + getImage(field) + '<div class="nowrap" title="' + _label + '"><span style="white-space: nowrap">' + _label + '</span></div></td>' +
        '<td style="width: 64px;"><span class="ui-icon ui-icon-plus" title="Add Field to Grid">Add Field to Grid</span>' +
        '<span class="ui-icon ui-icon-pencil" title="Edit Field">Edit Field</span>' +
        '<span class="ui-icon ui-icon-close" title="Delete Field">Delete Field</span></td>' +
        '</tr></table>' +
        '<div class="field_drag_handle" title="Drag field from here"><span class="ui-icon ui-icon-grip-dotted-horizontal"></span></div>' +
        '</li>');

    if (field.Required == 'True' || field.Required == '1') {
        $('<span class="ui-icon ui-icon-notice" title="Required">*</span>').insertAfter(li.find('span.ui-icon-close'));
    }
    li.attr('FieldId', field.FieldId);
    field.JoinInfo = field.JoinInfo.replace(/'/g, "''");

    li.attr('data', $.toJSON(field)).uniqueId();
    if (field.ColumnNav != null && field.ColumnNav != '') {
        var columnId = $(li).attr('id') + '-grid-column';
        $(field.ColumnNav).attr('id', columnId);
    }

    return li;
}

function createColumn(data) {
    var li = $('<li class="ui-state-default">' +
            '<table width="100%" cellspacing="0" cellpadding="0"><tr>' +
            '<td><div class="nowrap" style="width:422px;" title="' + data.ColumnLabel + '"><span style="white-space: nowrap">' + data.ColumnLabel + '</span></div></td>' +
            '<td style="width: 64px;"><span class="ui-icon ui-icon-pencil" title="Edit Column">Edit Column</span>' +
            '<span class="ui-icon ui-icon-close" title="Remove Column from Grid">Remove Column from Grid</span>' +
            '<span class="ui-icon ui-icon-plus" title="Add Column to Filter">Add Column to Filter</span></td>' +
            '</tr></table>' +
            '<div class="field_drag_handle" title="Drag column from here to sort"><span class="ui-icon ui-icon-grip-dotted-horizontal"></span></div>' +
            '</li>');

    li.attr('data', $.toJSON(data));
    return li;
}

function getImage(field) {
    var html = '<img class="nowrap" title="TITLE" src="../Images/IMAGE_NAME" style="opacity: 0.5;padding-right:2px;">';

    if (field.ControlType == 'selectmenu') {
        return html.replace('TITLE', 'SelectMenu').replace('IMAGE_NAME', 'select.gif');
    } else if (field.ControlType == 'dropdownlist') {
        return html.replace('TITLE', 'ComboBox').replace('IMAGE_NAME', 'list.gif');
    } else if (field.ControlType == 'checkbox') {
        return html.replace('TITLE', 'Checkbox').replace('IMAGE_NAME', 'checkbox.gif');
    } else if (field.ControlType == 'hidden') {
        return html.replace('TITLE', 'Hidden').replace('IMAGE_NAME', 'hidden.gif');
    } else if (field.ControlType == 'multiline') {
        return html.replace('TITLE', 'TextArea').replace('IMAGE_NAME', 'textarea.gif');
    }

    return html.replace('TITLE', 'TextBox').replace('IMAGE_NAME', 'text.gif');
}

function saveTab() {
    var tab = getObject('#tab_dialog');
    tab.Fields = [];
    
    if(tabs == null) {
        var ul = $('<ul></ul>');
        $('#tabsection').append(ul);

        var tabContent = createTab(ul, tab, 1);
        appendTabContent(tab, tabContent);
        $('#tabs').append(tabContent);
        createTabEvents();
    } else {
       if($('#TabNav').val() == '') {
            var tabContent = createTab(tabs.find('.ui-tabs-nav'), tab, $('#tabs ul.ui-tabs-nav li').length + 1);
            tabs.append(tabContent);
            appendTabContent(tab, tabContent);
            tabs.tabs('refresh');
            tabItemsDroppable();
        } else {
            //update existing tab
            var li = $($('#TabNav').val());
            var data = $.evalJSON(li.attr('data'));

            if(data.Cols != tab.Cols) {
                var tabContent = $($('a', li).attr('href'));
                var cols = tab.Cols;

                $('ul', tabContent).each(function(colIndex) {
                    $('li', $(this)).each(function(fIndex) {                        
                        var field = $.evalJSON($(this).attr('data'));      
                        var order = (colIndex + 1) + (cols * fIndex);

                        // setting tabId and order.
                        // in case it was move to a different tab or the order change.
                        field.TabId = tab.TabId;
                        field.FieldOrder = order;

                        var columnId = '#' + $(this).attr('id') + '-grid-column';
                        if (exists(columnId)) {
                            var column = $.evalJSON($(columnId).attr('data'));
                            field.ColumnNav = columnId;
                        }

                        tab.Fields.push(field);
                    });
                });
                
                tabContent.html('');
                appendTabContent(tab, tabContent);

                $("ul.connectedSortable").sortable({ connectWith: ".connectedSortable", cursor: "move", 
                handle: "div.field_drag_handle" }).disableSelection();
            }
            
            li.attr('data', $.toJSON(tab));
            $('a span', li).text(tab.TabName);
            $('a div.nowrap', li).attr('title', tab.TabName);
        }
    }           
}

function validateField(tips) {
    var valid = true;
    //var tips = $('#field_dialog p.validateTips');
    valid = valid && checkRequired(tips, $('#FieldName'), "Name");
    valid = valid && checkAlpha(tips, $('#FieldName'), "Name");
    valid = valid && checkRequired(tips, $('#Label'), "Label");
    valid = valid && checkAlpha(tips, $('#DBFieldName'), "DB Name");
    valid = valid && checkRequired(tips, $('#Type'), "Type");
    valid = valid && checkRequired(tips, $('#ControlType'), "Control Type");

    var activeTab = $(tabs.find('.ui-tabs-nav li')[tabs.tabs("option", "active")]);
    var tabName = activeTab.find('a').attr('href');
    var fields = $(tabName + ' li');
    for (var f = 0; f < fields.length; f++) {
        var field = $.evalJSON($(fields[f]).attr('data'));
        if ($('#FieldName').val() == field.FieldName && $.trim($('#FieldId').val()) != $.trim(field.FieldId)) {
            $('#FieldName').addClass("ui-state-error");
            tips.text("There is already a field with this name on the current tab.").addClass("ui-state-highlight");
            valid = false;
            break;
        }
    }

    return valid;
}

function saveField() {       
    var field = getObject('#field_dialog');
    var _label = field.Label;

    if ($('#FieldNav').val() == '') {
        var activeTab = $(tabs.find('.ui-tabs-nav li')[tabs.tabs("option", "active")]);
        var tabName = activeTab.find('a').attr('href');
        var tab = $.evalJSON(activeTab.attr('data'));
        var fieldsCount = $(tabName + ' li').length;
        var list = fieldsCount % tab.Cols;
        var ul = $(tabName + ' ul')[list];

        $(ul).append(createField(field));
    } else {
        var li = $($('#FieldNav').val());
        $('span:first-child', li).text(_label);
        $('div.nowrap', li).attr('title', _label);
        li.attr('data', $.toJSON(field));
        $('span.ui-icon-notice', li).remove();
        if (field.Required == 'True' || field.Required == '1') {
            $('adding notice icon');
            $('<span class="ui-icon ui-icon-notice" title="Required">*</span>').insertAfter(li.find('span.ui-icon-close'));
        }

        li.find('img').replaceWith($(getImage(field)));
    }
}

function createTabEvents() {
    tabs = $('#tabs').tabs();
    tabs.find( '.ui-tabs-nav' ).sortable({
        axis: 'x',
        stop: function() {
            tabs.tabs( 'refresh' );
            tab_items = $('ul:first li', tabs);
        }
    });

    tabs.on('tabchange', function () {
        if (exists('#tabsection ul')) {
            $('.tabscroll').show();
        } else {
            $('.tabscroll').hide();
        }

        if ($('#tabsection ul.ui-tabs-nav li:visible').length > 4) {
            $('#tabscrollsection').show();

            var _width = $('#tabsection ul.ui-tabs-nav li:visible').length * 184;
            $('div.tabcontainer div.scroller ul').width(_width);
        } else {
            $('#tabscrollsection').hide();

            $('div.tabcontainer div.scroller ul').width(737);
            $('#tabsection').scrollLeft(0);
        }
    });

    // close icon: removing the tab on click
    tabs.delegate( ".ui-tabs-nav span.ui-icon-close", "click", function() {  
        if(confirm('Are you sure you want to delete this tab?')  == false)  
            return false;
              
        if(confirm('If you delete this tab, all tab fields will be deleted too, Are you really sure you want to delete the tab?')  == false)  
            return false;

        var li = $(this).closest("li");               
        var tabdata = $.evalJSON($(li).attr('data'));

        if(tabdata.TabId == '') {
            var tabContentId = $(li).remove().find('a').attr('href');
            $(tabContentId).remove();
            tabs.tabs( "refresh" );
        } else {
            tabdata.UpdatedDate = '1'; //flag tab to be deleted
            $(li).attr('data', $.toJSON(tabdata));
            var tabContentId = $(li).hide().find('a').attr('href');    

            //flag all fields to be deleted
            $(tabContentId + ' li').each(function() {
                var fielddata = $.evalJSON($(this).attr('data'));
                if(fielddata.FieldId != '') {
                    fielddata.UpdatedDate = '1'; //flag field to be deleted
                    $(this).attr('data', $.toJSON(fielddata));
                } else {
                    $(this).remove();
                }                        
            });

            if(tabs.find('.ui-tabs-nav li').length > 0) {
                tabs.tabs( "option", "active", 0 );
            }

            $(tabContentId).hide();
        }

        $('#tabs').trigger('tabchange');// after delete
    });

    // edit icon: edit the tab on click
    tabs.delegate( ".ui-tabs-nav span.ui-icon-pencil", "click", function() {
        var li = $(this).closest("li");
        var data = $.evalJSON(li.attr('data'));
        populateDialog(data, '#tab_dialog');
        
        $('#TabNav').val('#' + li.attr('id'));
        $('#tab_dialog').dialog('open');    
    });

    // close icon: removing the field on click
    tabs.delegate(".connectedSortable span.ui-icon-close", "click", function () {
        if (confirm('Are you sure you want to delete this field?') == false)
            return false;

        var li = $(this).closest("li");
        var data = $.evalJSON(li.attr('data'));
        if (data.FieldId != '') {
            data.UpdatedDate = '1'; //flag field to be deleted
            li.attr('data', $.toJSON(data));
            $(this).closest("li").hide();
        } else {
            $(this).closest("li").remove();
        }

        //removing grid column if exists.
        var id = '#' + li.attr('id') + '-grid-column';
        $(id).remove();
    });

    // edit icon: edit the field on click
    tabs.delegate(".connectedSortable span.ui-icon-pencil", "click", function () {
        var li = $(this).closest("li");
        var data = $.evalJSON(li.attr('data'));
        populateDialog(data, '#field_dialog');


        $('#FieldNav').val('#' + li.attr('id'));
        createJsonTable('#ji-container', true);
        createJsonTable('#ddi-container', true);
        createJsonTable('#prop-container', true);
        $('#field_dialog').dialog('open');
        $('#field_tabs').tabs("option", "active", 0);
    });

    // plus icon: add the field to grid on click
    tabs.delegate(".connectedSortable span.ui-icon-plus", "click", function () {
        var li = $(this).closest("li");
        var data = $.evalJSON(li.attr('data'));

        var id = li.attr('id') + '-grid-column';

        $('#column_prop_dialog input').val('').removeClass('ui-state-error');
        $('#column_prop_dialog input[type=checkbox]').prop('checked', false);

        if ($('#grid-columns-empty').length != 0) { //clear list if empty column exist
            $('#grid-columns').html('');
        }

        if ($('#' + id).length != 0) {
            alert('Field is already in the grid.');
            $('#configtabs').tabs("option", "active", 2);
        } else {
            $('#ColumnName').val(data.FieldName);
            $('#ColumnLabel').val(data.Label);
            $('#ColumnFieldId').val(data.FieldId);
            $('#ColumnPageId').val($('#PageId').val());
            $('#FieldNavId').val(li.attr('id'));
            $('#ColumnNav').val('#' + li.attr('id') + '-grid-column');
            $('#Visible').prop("checked", true);
            $('#Searchable').prop("checked", true);
            $('#column_prop_dialog').parent().find('#button-save').click();
            var tips = $('#validateTips');
            showSuccess(tips, 'Field succesfully added to grid.', true);
        }
    });


    // make fields sortable
    $("ul.connectedSortable").sortable({
        connectWith: ".connectedSortable", cursor: "move", handle: "div.field_drag_handle",
        update: function (event, ui) {
            //TODO: create a method that execute the following code
            //Adjust width of visible fields
            if ($('#configtabs-2 div.dialogtab:visible ul.connectedSortable li.ui-state-default table').length > 0) {
                var _width = $($('#configtabs-2 div.dialogtab:visible ul.connectedSortable li.ui-state-default table')[0]).width()
                $('#configtabs-2 div.dialogtab:visible ul.connectedSortable li.ui-state-default table div.nowrap').width((_width - 64 - 20));
            }
        }
    }).disableSelection();

    $("#grid-columns").sortable();
    $("#grid-columns").disableSelection();

    // delete icon: remove the column on click
    $("#grid-columns").delegate("li span.ui-icon-close", "click", function () {
        if (confirm('Are you sure you want to removed this column from the grid?') == false)
            return false;

        var li = $(this).closest("li");
        var data = $.evalJSON(li.attr('data'));
        if (data.ColumnId != '') {
            data.UpdatedDate = '1'; //flag column to be deleted
            li.attr('data', $.toJSON(data));
            $(this).closest("li").hide();
        } else {
            $(this).closest("li").remove();
        }


        if ($('#grid-columns li').filter(':visible').length == 0) {
            $('#grid-columns').append('<li id="grid-columns-empty">No fields have been added to the grid.</li>');
        }
    });

    // edit icon: edit the column on click
    $("#grid-columns").delegate("li span.ui-icon-pencil", "click", function () {
        var li = $(this).closest("li");
        var data = $.evalJSON(li.attr('data'));
        populateDialog(data, '#column_prop_dialog');

        $('#ColumnNav').val('#' + li.attr('id'));
        $('#column_prop_dialog').dialog('open');
    });

    // plus icon: edit the column on click
    $("#grid-columns").delegate("li span.ui-icon-plus", "click", function (event) {
        event.stopPropagation();

        var li = $(this).closest("li");
        var data = $.evalJSON(li.attr('data'));

        var id = data.FieldId + '-filter-field';
        if ($('#' + id).length != 0) {
            alert('Field is already in the filter.');
            $('#configtabs').tabs("option", "active", 3);
            $('#' + id).effect('highlight');
            return;
        }


        if ($('#filter-fields #filter-fields-empty')) {
            $('#filter-fields #filter-fields-empty').remove();
        }

        $('#filter-fields').append(createFilterField(data));
        showSuccess($('#validateTips'), 'Field succesfully added to the filter.', true);
    });

    $("#filter-fields").sortable();
    $("#filter-fields").disableSelection();

    // delete icon: remove field from filter
    $("#filter-fields").delegate("li span.ui-icon-close", "click", function () {
        if (confirm('Are you sure you want to removed this field from the fielter?') == false)
            return false;

        var li = $(this).closest("li");
        li.remove();

        if ($('#filter-fields li').filter(':visible').length == 0) {
            $('#filter-fields').append('<li id="filter-fields-empty">No fields have been added to the filter.</li>');
        }
    });

    tabItemsDroppable();   
}

function createFilterField(data) {
    var field = $.evalJSON($('#configtabs-2 li[fieldid=' + data.FieldId + ']').attr('data'));

    var li = $('<li class="ui-state-default">' +
            '<table width="100%" cellspacing="0" cellpadding="0"><tr>' +
            '<td><div class="nowrap" style="width:470px;" title="' + field.Label + '"><span style="white-space: nowrap">' + field.Label + '</span></div></td>' +
            '<td style="width: 16px;"><span class="ui-icon ui-icon-close" title="Delete field from filter.">Delete field from filter.</span></td>' +
            '</tr></table>' +
            '<div class="field_drag_handle" title="Drag filter field from here"><span class="ui-icon ui-icon-grip-dotted-horizontal"></span></div>' +
            '</li>');

    li.attr('id', data.FieldId + '-filter-field');
    li.attr('filter-fieldid', data.FieldId);

    return li;
}

function tabItemsDroppable() {
    tab_items = $("ul:first li", tabs).droppable({
        accept: ".connectedSortable li",
        hoverClass: "ui-state-hover",
        drop: function( event, ui ) {
            var item = $(this);
            var tab = $.evalJSON(item.attr('data'));
            var tabName = item.find("a").attr("href");
 
            var fieldsCount = $(tabName + ' li').length;
            var listNumber = fieldsCount % tab.Cols;
            var list = $(tabName + ' ul')[listNumber];

            ui.draggable.hide( "slow", function() {
                tabs.tabs( "option", "active", tab_items.index( item ) );
                
                // Resize field
                if(fieldsCount > 0) {
                    var width = $($(tabName + ' li')[0]).width();
                    $(this).width(width);
                } else {
                    $(this).width($(list).width() - 22);
                }

                $(this).appendTo(list).show("slow");
            });
        }
    }); 
}