<%@ Page Title="Page Config" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PageConfig.aspx.cs" Inherits="BS.Common.PageConfig" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        #filter-fields, #grid-columns, .connectedSortable { list-style-type: none; margin: 0; padding: 0 0 2.5em; float: left; }
        #filter-fields li, #grid-columns li, .connectedSortable li {margin: 0 5px 5px 5px; padding: 5px; height: 16px;}
        
        #filter-fields li .ui-icon-close, #grid-columns li .ui-icon-close, #tabs li .ui-icon-close { float: left; margin: 0.4em 0.2em 0 0; cursor: pointer; }
        #grid-columns li .ui-icon-pencil, #tabs li .ui-icon-pencil { float: left; margin: 0.4em 0.2em 0 0; cursor: pointer; }
        #grid-columns li .ui-icon-plus, #tabs li .ui-icon-plus { float: left; margin: 0.4em 0.2em 0 0; cursor: pointer; }
        
        #grid-columns li .ui-icon-plus, #grid-columns li .ui-icon-pencil, #tabs ul.connectedSortable li .ui-icon-pencil { margin: 0 0 0 0; float: right; position: relative; top: -36px;}
        #filter-fields li .ui-icon-close, #grid-columns li .ui-icon-close, #tabs ul.connectedSortable li .ui-icon-close { margin: 0 0 0 0; float: right; position: relative; top: -36px;}
        #grid-columns ul.connectedSortable li .ui-icon-plus, #tabs ul.connectedSortable li .ui-icon-plus, #tabs ul.connectedSortable li .ui-icon-notice { margin: 0 0 0 0; float: right; position: relative; top: -36px;}
        
        div.field_drag_handle {cursor:move; opacity:0.7; position: relative;top: -16px; left:50%; width:20px; height: 20px;} 
        div.jsonformat, div.tableformat { padding:4px;}    
        div.container .ui-selectmenu-button { width:98%!important;}                 
    </style>
    <%: Scripts.Render("~/Scripts/page_config_js") %>  
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div id="my-carousel">
        <ul class="carousel">
            <li class="carousel">
                <h2>Pages
                    <button id="back" style="display: none;" onclick="return false;">Back</button>
                </h2>
                <div class="catalog">
                    <table cellpadding="0" cellspacing="0" border="0" class="display" id="pages">
                        <thead>
                            <tr>
                                <th align="left">Name</th>
                                <th align="left">Title</th>
                                <th align="left">Table Name</th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>

            </li>

            <li class="carousel">

                <div id="configtabs">
                    <ul id="configtabs-nav">
                        <li><a href="#configtabs-1">General</a></li>
                        <li><a href="#configtabs-2">Dialog</a></li>
                        <li><a href="#configtabs-3">Grid</a></li>
                        <li><a href="#configtabs-4">Filter</a></li>
                    </ul>
                    <div id="configtabs-1">
                        <div id="page_dialog" class="modal-form">
                            <fieldset class="columns-1">
                                <label for="Name">Name :</label>
                                <input type="text" name="Name" id="Name" class="text ui-widget-content ui-corner-all" />
                                <label for="Title">Title :</label>
                                <input type="text" name="Title" id="Title" class="text ui-widget-content ui-corner-all" />
                                <label for="Connection" style="display: none;">Connection :</label>
                                <input type="text" style="display: none;" name="Connection" id="Connection" class="text ui-widget-content ui-corner-all" readonly />
                                <label for="TableName">Table Name :</label>
                                <select name="TableName" id="TableName" class="ui-widget-content ui-corner-all"></select>
                                <input type="hidden" name="PageId" id="PageId" />
                            </fieldset>
                        </div>
                    </div>
                    <div id="configtabs-2">
                        <div id="tabs" style="height: 440px;"></div>
                    </div>
                    <div id="configtabs-3"  style="overflow-y:scroll; height:500px;">
                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                            <tbody>
                                <tr>
                                    <td width="50%">
                                        <div style="height: 440px;">
                                            <ul id="grid-columns" style="width: 100%;">
                                                <li id="grid-columns-empty">No fields have been added to the grid.</li>
                                            </ul>
                                        </div>
                                    </td>
                                    <td width="50%"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div id="configtabs-4">
                        <table cellpadding="0" cellspacing="0" border="0" width="100%">
                            <tbody>
                                <tr>
                                    <td width="50%">
                                        <div style="height: 440px;">
                                            <ul id="filter-fields" style="width: 100%;">
                                                <li id="filter-fields-empty">No fields have been added to the filter.</li>
                                            </ul>
                                        </div>
                                    </td>
                                    <td width="50%"></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </li>
        </ul>
    </div>


    <div id="tab_dialog" title="Tab" style="display: none;" class="modal-form">
        <p class="validateTips ui-corner-all"></p>
        <fieldset>
            <label for="TabName">Name :</label>
            <input type="text" name="TabName" id="TabName" class="text ui-widget-content ui-corner-all" />
            <label for="Cols">Colums :</label>
            <input type="text" name="Cols" id="Cols" class="text ui-widget-content ui-corner-all" />
        </fieldset>
        <input type="hidden" name="TabId" id="TabId" />
        <input type="hidden" name="TabNav" id="TabNav" />
    </div>

    <div id="field_dialog" title="Field" style="display: none;" class="modal-form">
        <p class="validateTips ui-corner-all"></p>
        <div id="field_tabs">
            <ul>
                <li><a href="#fieldtabs-1">Details</a></li>
                <li><a href="#fieldtabs-2">Drop down info</a></li>
                <li><a href="#fieldtabs-3">Join info</a></li>
                <li><a href="#fieldtabs-4">Properties</a></li>
            </ul>
            <div id="fieldtabs-1">
                <table width="100%" cellspacing="0" cellpadding="0">
                    <tbody>
                        <tr>
                            <td valign="top" width="50%">
                                <fieldset class="columns-2">
                                    <label for="FieldName">Name :</label>
                                    <input type="text" name="FieldName" id="FieldName" class="text ui-widget-content ui-corner-all" />
                                    <label for="DBFieldName">DB Name :</label>
                                    <input type="text" name="DBFieldName" id="DBFieldName" class="text ui-widget-content ui-corner-all" />
                                    <label for="Label">Label :</label>
                                    <input type="text" name="Label" id="Label" class="text ui-widget-content ui-corner-all" />
                                    <label for="Type">Type :</label>
                                    <select id="Type" name="Type" class="ui-corner-all">
                                        <option value="bit">bit</option>
                                        <option value="char">char</option>
                                        <option value="date">date</option>
                                        <option value="datetime">datetime</option>
                                        <option value="datetime2">datetime2</option>
                                        <option value="decimal">decimal</option>
                                        <option value="int">int</option>
                                        <option value="nchar">nchar</option>
                                        <option value="nvarchar">nvarchar</option>
                                        <option value="money">money</option>
                                        <option value="real">real</option>
                                        <option value="smalldatetime">smalldatetime</option>
                                        <option value="smallint">smallint</option>
                                        <option value="tinyint">tinyint</option>
                                        <option value="varchar">varchar</option>
                                    </select>
                                    <label for="ControlType">Control Type :</label>
                                    <select id="ControlType" name="ControlType" class="ui-corner-all">
                                        <option value="checkbox">checkbox</option>
                                        <option value="dropdownlist">dropdownlist</option>
                                        <option value="hidden">hidden</option>
                                        <option value="inputbox">inputbox</option>
                                        <option value="multiline">multiline</option>
                                        <option value="multiselect">multiselect</option>
                                        <option value="selectmenu">selectmenu</option>
                                    </select>                                    
                                </fieldset>
                            </td>
                            <td valign="top" width="50%">
                                <fieldset class="columns-2">
                                    <label for="IsId">Is Id :</label>
                                    <input type="checkbox" name="IsId" id="IsId" class="ui-widget-content ui-corner-all" />
                                    <label for="Required">Required :</label>
                                    <input type="checkbox" name="Required" id="Required" class="ui-widget-content ui-corner-all" />
                                    <label for="Exportable">Exportable :</label>
                                    <input type="checkbox" name="Exportable" id="Exportable" class="ui-widget-content ui-corner-all" />
                                    <label for="Insertable">Insertable :</label>
                                    <input type="checkbox" name="Insertable" id="Insertable" class="ui-widget-content ui-corner-all" />
                                    <label for="Updatable">Updatable :</label>
                                    <input type="checkbox" name="Updatable" id="Updatable" class="ui-widget-content ui-corner-all" />                                    
                                </fieldset>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div id="fieldtabs-2">
                <div id="ddi-container" class="container">
                    <button onclick="return false;" class="json" id="dropdownInfo-btn" title="show json format">json</button>
                    <div class="jsonformat" id="ddi-json" style="display: none;">
                        <textarea cols="2" rows="6" name="DropDownInfo" id="DropDownInfo" class="text ui-widget-content ui-corner-all" style="resize: none;"></textarea>
                    </div>
                    <div class="tableformat" id="ddi-table">
                        <div>
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td valign="top" width="36%">
                                        <select id="ddi-property" class="property" style="width:98%;">
                                            <option value=""></option>
                                            <option value="url">URL</option>
                                            <option value="valField">Value Field</option>
                                            <option value="textField">Text Field</option>
                                        </select>
                                    </td>
                                    <td valign="top" width="36%" id="ddinfoValueWrapper">
                                        <input type="text" id="ddi-value" class="value ui-corner-all ui-widget-content" style="height: 20px; margin-bottom: 2px; width: 98%;" />
                                    </td>
                                    <td valign="top">
                                        <div style="display: inline;" id="ddinfo-table_wrapper">
                                            <button onclick="return false;" id="ddi-add-btn" class="save" title="Save new/existing property">Save</button>                                            
                                            <button id="ddi-edit-btn" onclick="return false;" class="disable edit" title="Edit selected property">Edit</button>
                                            <button title="Delete selected property" id="ddi-delete-btn" onclick="return false;" class="disable delete">Delete</button>
                                            <input type="hidden" id="ddInfo-action" value="" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <table width="100%" id="ddinfo-table" class="display detail" cellpadding="0" cellspacing="0" border="0">
                            <thead>
                                <tr>
                                    <th>Property</th>
                                    <th>Value</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div id="fieldtabs-3">
                <div id="ji-container" class="container">
                    <button onclick="return false;" id="joinInfo-btn" class="json" title="Show json format">json</button>
                    <div class="jsonformat" id="ji-json" style="display: none;">
                        <textarea cols="2" rows="6" name="JoinInfo" id="JoinInfo" class="text ui-widget-content ui-corner-all" style="resize: none;"></textarea>
                    </div>
                    <div class="tableformat" id="ji-table">
                        <div>
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td valign="top" width="36%">
                                        <select id="ji-property" class="property" style="width:98%;">
                                            <option value=""></option>
                                            <option value="ExtraJoinDetails">ExtraJoinDetails</option>
                                            <option value="JoinField">JoinField</option>
                                            <option value="JoinFields">JoinFields</option>
                                            <option value="JoinType">JoinType</option>
                                            <option value="TableName">TableName</option>
                                        </select>
                                    </td>
                                    <td valign="top" width="36%" id="joinValueWrapper">
                                        <input type="text" id="ji-value" class="value ui-corner-all ui-widget-content" style="height: 20px; margin-bottom: 2px; width: 98%;" />
                                    </td>
                                    <td valign="top">
                                        <div style="display: inline;" id="joininfo-table_wrapper">                        
                                            <button onclick="return false;" id="ji-add-btn" class="save" title="Save new/existing property">Save</button>
                                            <button id="ji-edit-btn" onclick="return false;" class="disable edit" title="Edit selected property">Edit</button>
                                            <button title="Delete selected property" id="ji-delete-btn" onclick="return false;" class="disable delete">Delete</button>
                                            <input type="hidden" id="joinInfo-action" value="" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <table width="100%" class="display detail" id="joininfo-table" cellpadding="0" cellspacing="0" border="0">
                            <thead>
                                <tr>
                                    <th>Property</th>
                                    <th>Value</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div id="fieldtabs-4">
                <div id="prop-container" class="container">
                    <button onclick="return false;" id="prop-btn" class="json" title="Show json format">json</button>
                    <div class="jsonformat" id="props-json" style="display: none;">
                        <textarea cols="2" rows="6" name="ControlProps" id="ControlProps" class="text ui-widget-content ui-corner-all" style="resize: none;"></textarea>
                    </div>
                    <div class="tableformat" id="props-table-container">
                        <div>
                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td valign="top" width="36%">
                                        <input type="text" id="prop-key" class="property ui-corner-all ui-widget-content" style="height: 20px; margin-bottom: 2px; width: 98%;" />
                                    </td>
                                    <td valign="top" width="36%">
                                        <input type="text" id="prop-value" class="value ui-corner-all ui-widget-content" style="height: 20px; margin-bottom: 2px; width: 98%;" />
                                    </td>
                                    <td valign="top">
                                        <div style="display: inline;" id="props-table_wrapper">
                                            <button onclick="return false;" id="prop-add-btn" class="save" title="Save new/existing property">Save</button>
                                            <button onclick="return false;" id="prop-edit-btn" class="disable edit" title="Edit existing property">Edit</button>
                                            <button onclick="return false;" id="prop-delete-btn" class="disable delete" title="Delete existing property">Delete</button>
                                            <input type="hidden" id="props-action" value="" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <table width="100%" id="props-table" class="display detail" cellpadding="0" cellspacing="0" border="0">
                            <thead>
                                <tr>
                                    <th>Property</th>
                                    <th>Value</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" name="FieldId" id="FieldId" />
        <input type="hidden" name="TabId" id="FieldTabId" />
        <input type="hidden" name="FieldOrder" id="FieldOrder" />
        <input type="hidden" name="FieldNav" id="FieldNav" />
    </div>

    <div id="column_prop_dialog" title="Column Properties" style="display: none;" class="modal-form">
        <p class="validateTips ui-corner-all"></p>
        <fieldset>
            <label for="ColumnName">Name :</label>
            <input type="text" name="ColumnName" id="ColumnName" class="text ui-widget-content ui-corner-all" />
            <label for="ColumnLabel">Label :</label>
            <input type="text" name="ColumnLabel" id="ColumnLabel" class="text ui-widget-content ui-corner-all" />
            <label for="Width">Width :</label>
            <input type="text" name="Width" id="Width" class="text ui-widget-content ui-corner-all" />
            <label for="Visible">Visible :</label>
            <input type="checkbox" name="Visible" id="Visible" class="ui-widget-content ui-corner-all" />
            <label for="Searchable">Searchable :</label>
            <input type="checkbox" name="Searchable" id="Searchable" class="ui-widget-content ui-corner-all" />
            <input type="hidden" name="ColumnOrder" id="ColumnOrder" />
            <input type="hidden" name="ColumnId" id="ColumnId" />
            <input type="hidden" name="FieldId" id="ColumnFieldId" />
            <input type="hidden" name="PageId" id="ColumnPageId" />
            <input type="hidden" name="ColumnNav" id="ColumnNav" />
            <input type="hidden" name="FieldNavId" id="FieldNavId" />
        </fieldset>
    </div>

    <div id="field_list_dialog" title="Fields from Database" style="display: none;" class="modal-form">
        <p class="validateTips ui-corner-all"></p>
        <table id="field_list" cellpadding="0" cellspacing="0" border="0" class="display detail" width="98%">
            <thead>
                <tr>
                    <th align="left">Name</th>
                    <th align="left">Type</th>
                    <th align="left">Nullable</th>
                    <th align="left"></th>
                </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>

    <div id="filter_dialog" title="Filter" style="display: none;" class="modal-form">
        <p class="validateTips ui-corner-all"></p>
        <fieldset>
            <label for="FilterText">Text :</label>
            <input type="text" name="FilterText" id="FilterText" value="Filter" class="text ui-widget-content ui-corner-all" />
            <label for="FilterCols">Columns :</label>
            <input type="text" name="FilterCols" id="FilterCols" value="1" class="text ui-widget-content ui-corner-all" />
            <label for="ShowClear">Show Clear :</label>
            <input type="checkbox" name="ShowClear" id="ShowClear" checked class="ui-widget-content ui-corner-all" />
            <input type="hidden" name="FilterId" id="FilterId" />
        </fieldset>
    </div>
</asp:Content>
