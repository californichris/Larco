<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="BS.Larco.Sistema.Usuarios" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    const PAGE_NAME = 'Users';
	    const TABLE_SELECTOR = '#' + PAGE_NAME + '_table';
	    const DIALOG_SELECTOR = '#' + PAGE_NAME + '_dialog';
	    const BUTTONS_SELECTOR = '#' + PAGE_NAME + 'table_wrapper_buttons button.disable';

	    const UR_PAGE_NAME = 'UserRoles';
	    const UR_TABLE_SELECTOR = '#' + UR_PAGE_NAME + '_table';
	    const UR_DIALOG_SELECTOR = '#' + UR_PAGE_NAME + '_dialog';
	    const UR_BUTTONS_SELECTOR = '#' + UR_PAGE_NAME + 'table_wrapper_buttons button.disable';


	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + PAGE_NAME,
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        createLogPage(config);

	        var catalog = $(TABLE_SELECTOR).Catalog({
	            pageConfig: config,
	            showExport: true,
	            dialogWidth: 600,
	            dialogHeight: 430,
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            },
	            newEntityCallBack: function (oTable, options) {
	                catalog.Catalog('newEntity', oTable, options);
	                $(UR_TABLE_SELECTOR).DataTable().clear().draw();
	                $(UR_DIALOG_SELECTOR + ' div.ui-tabs').tabs('option', 'active', 0);
	            },
	            editEntityCallBack: function (oTable, options) {
	                var data = getSelectedRowData(oTable);

	                catalog.Catalog('editEntity', oTable, options);
	                reloadUserRoles(data);
	                $(UR_DIALOG_SELECTOR + ' div.ui-tabs').tabs('option', 'active', 0);
	            }
	        });
	    }

	    function createLogPage(_config) {
	        $(DIALOG_SELECTOR + ' div.ui-tabs').tabs({
	            activate: function (event, ui) {
	                if ('PermisosTab' == ui.newTab[0].id) {
	                    $(UR_TABLE_SELECTOR).css('width', '100%').DataTable().columns.adjust().draw();
	                }
	            }
	        });

	        $(DIALOG_SELECTOR + ' #tabs-2 table').after('<div id="' + UR_PAGE_NAME + '_container"><h3>Miembro de:</h3></div>');
	        $(DIALOG_SELECTOR + ' #tabs-2 table').remove();
	        $('#' + UR_PAGE_NAME + '_container').Page({
	            source: AJAX + '/PageInfo/GetPageConfig?pageName=' + UR_PAGE_NAME,
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                var userRolesCatalog = $(UR_TABLE_SELECTOR).Catalog({
	                    dialogWidth: 500,
	                    displayLength: 7,
	                    pageConfig: config,
	                    source: [],
	                    scrollY: '120px',
	                    paginate: false,
	                    showDelete: true,
	                    showEdit: false,
	                    filter: false,
	                    validate: function (tips) {
	                        return validateDialog(config, tips);
	                    },
	                    newEntityCallBack: function (oTable, options) {
	                        //before displaying the new note dialog validate if all Incident required fields
	                        var valid = validateDialog(_config, $(UR_DIALOG_SELECTOR + ' p.validateTips'));
	                        if (!valid) return;

	                        userRolesCatalog.Catalog('newEntity', oTable, options);

	                        $(UR_DIALOG_SELECTOR + ' #USE_ID').val($('#USE_ID').val());
	                    },
	                    saveEntityCallBack: function (oTable, options) {
	                        if ($('#USE_ID').val() != '') { // Adding new notes to an existing incident
	                            userRolesCatalog.Catalog('saveEntity', oTable, options);
	                            return;
	                        }

	                        // save the user first
	                        var user = getObject(UR_DIALOG_SELECTOR);
	                        $.when(saveIncident(user, _config)).then(function (json) {
	                            // populate new user id in UserRoles dialog
	                            $('#USE_ID').val(json.Id);
	                            incident.IncidentId = json.Id;
	                            $(DIALOG_SELECTOR + ' #USE_ID').val($('#USE_ID').val());

	                            // reloading Users table
	                            $(TABLE_SELECTOR).DataTable().ajax.reload();

	                            // Saving User Role
	                            var entity = getObject(UR_DIALOG_SELECTOR);
	                            $.ajax({
	                                type: 'POST',
	                                url: options.saveRequest,
	                                data: 'entity=' + encodeURIComponent($.toJSON(entity))
	                            }).done(function () {
	                                if (json.ErrorMsg == SUCCESS) {
	                                    $(UR_DIALOG_SELECTOR).dialog('close');
	                                    reloadIncidentLog(incident);
	                                } else {
	                                    showError($(UR_DIALOG_SELECTOR + ' p.validateTips'), 'No fue posible agregar el role al usuario.');
	                                }
	                            });

	                        });

	                    }
	                });

	            }
	        });
	    }

	    function saveIncident(entity, config) {
	        return $.ajax({
	            type: 'POST',
	            url: AJAX + '/PageInfo/SavePageEntity?pageName=' + config.Name,
	            data: 'entity=' + encodeURIComponent($.toJSON(entity))
	        });
	    }

	    function reloadUserRoles(data) {
	        var entity = { USE_ID: data.USE_ID };
	        var _url = AJAX + '/PageInfo/GetPageEntityList?pageName=' + UR_PAGE_NAME + '&entity=' + encodeURIComponent($.toJSON(entity));
	        $(UR_TABLE_SELECTOR).DataTable().ajax.url(_url).load();
	        $(UR_TABLE_SELECTOR).css('width', '100%').DataTable().columns.adjust().draw(); //Fix column width bug in datatables.
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
