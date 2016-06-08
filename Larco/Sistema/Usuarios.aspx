<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="BS.Larco.Sistema.Usuarios" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<script type="text/javascript">
	    $(document).ready(function () {
	        $('div.catalog').Page({
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=Users',
	            onLoadComplete: function (config) {
	                $('h2').text(config.Title);
	                document.title = config.Title;
	                initializeCatalog(config);
	            }
	        });
	    });

	    function initializeCatalog(config) {
	        createLogPage(config);

	        var catalog = $('#Users_table').Catalog({
	            pageConfig: config,
	            showExport: true,
	            dialogWidth: 600,
	            dialogHeight: 430,
	            validate: function (tips) {
	                return validateDialog(config, tips);
	            },
	            newEntityCallBack: function (oTable, options) {
	                catalog.Catalog('newEntity', oTable, options);
	                $('#UserRoles_table').DataTable().clear().draw();
	                $('#Users_dialog div.ui-tabs').tabs('option', 'active', 0);
	            },
	            editEntityCallBack: function (oTable, options) {
	                var data = getSelectedRowData(oTable);

	                catalog.Catalog('editEntity', oTable, options);
	                reloadUserRoles(data);
	                $('#Users_dialog div.ui-tabs').tabs('option', 'active', 0);
	            }
	        });
	    }

	    function createLogPage(_config) {
	        $('#Users_dialog div.ui-tabs').tabs({
	            activate: function (event, ui) {
	                if ('PermisosTab' == ui.newTab[0].id) {
	                    $('#UserRoles_table').css('width', '100%').DataTable().columns.adjust().draw();
	                }
	            }
	        });

	        $('#Users_dialog #tabs-2 table').after('<div id="UserRoles_container"><h3>Miembro de:</h3></div>');
	        $('#Users_dialog #tabs-2 table').remove();
	        $('#UserRoles_container').Page({
	            source: AJAX_CONTROLER_URL + '/PageInfo/GetPageConfig?pageName=UserRoles',
	            dialogStyle: 'table',
	            onLoadComplete: function (config) {
	                var userRolesCatalog = $('#UserRoles_table').Catalog({
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
	                        var valid = validateDialog(_config, $('#Users_dialog p.validateTips'));
	                        if (!valid) return;

	                        userRolesCatalog.Catalog('newEntity', oTable, options);

	                        $('#UserRoles_dialog #UserId').val($('#UserId').val());                           
	                    },
	                    saveEntityCallBack: function (oTable, options) {
	                        if ($('#UserId').val() != '') { // Adding new notes to an existing incident
	                            userRolesCatalog.Catalog('saveEntity', oTable, options);
	                            return;
	                        }

	                        // save the user first
	                        var user = getObject('#UserRoles_dialog');
	                        $.when(saveIncident(user, _config)).then(function (json) {
	                            // populate new user id in UserRoles dialog
	                            $('#UserId').val(json.Id);
	                            incident.IncidentId = json.Id;
	                            $('#UserRoles_dialog #UserId').val($('#UserId').val());

	                            // reloading Users table
	                            $('#Users_table').DataTable().ajax.reload();

	                            // Saving User Role
	                            var entity = getObject('#UserRoles_dialog');
	                            $.ajax({
	                                type: "POST",
	                                url: options.saveRequest,
	                                data: "entity=" + encodeURIComponent($.toJSON(entity))
	                            }).done(function () {
	                                if (json.ErrorMsg == SUCCESS) {
	                                    $('#UserRoles_dialog').dialog('close');
	                                    reloadIncidentLog(incident);
	                                } else {
	                                    showError($("#UserRoles_dialog p.validateTips"), 'No fue posible agregar el role al usuario.');
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
	            type: "POST",
	            url: AJAX_CONTROLER_URL + '/PageInfo/SavePageEntity?pageName=' + config.Name,
	            data: "entity=" + encodeURIComponent($.toJSON(entity))
	        });
	    }

	    function reloadUserRoles(data) {
	        var entity = { UserId: data.UserId };
	        var _url = AJAX_CONTROLER_URL + '/PageInfo/GetPageEntityList?pageName=UserRoles&entity=' + encodeURIComponent($.toJSON(entity));
	        $('#UserRoles_table').DataTable().ajax.url(_url).load();
	        $('#UserRoles_table').css('width', '100%').DataTable().columns.adjust().draw(); //Fix column width bug in datatables.
	    }

	</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
