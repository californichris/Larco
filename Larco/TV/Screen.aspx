<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Screen.aspx.cs" Inherits="BS.Larco.TV.Screen" %>

<%@ Import Namespace="System.Web.Optimization" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>Larco TV Screens</title>
    <link href="<%= Page.ResolveUrl("~/Images/favicon.ico") %>" type="image/x-icon" rel="shortcut icon" />
    <%: Styles.Render("~/Styles/site_master_css", "~/Styles/blitzer/jquery_css") %>
    <link href="/Larco/Styles/tv.css" type="text/css" rel="stylesheet" />
    <%: Scripts.Render("~/Scripts/site_master_js") %>
    <script type="text/javascript">
        const AJAX_CONTROLER_URL = '<%= ResolveUrl("~/AjaxController.ashx") %>';
        const AJAX = AJAX_CONTROLER_URL;
    </script>
    <script src="/Larco/Scripts/jquery.hotkeys.js"></script>
    <script src="/Larco/Scripts/app/tv.js"></script>
</head>
<body>
    <form id="form1" runat="server"></form>
    <div id="main-body">
        <div id="task-selector">
            <div class="ui-dialog">
                <div class="ui-dialog-titlebar ui-widget-header ui-corner-all ui-helper-clearfix">
                    <span class="ui-dialog-title">Selecciona las tareas a desplegar</span>
                </div>
                <div class="modal-form ui-dialog-content ui-widget-content">
                    <label for="TimeTotals"><b>Tiempo para recargar totales(seg)</b><font color="red">*</font> :</label>
                    <input id="TimeTotals" name="TimeTotals" class="text text ui-widget-content ui-corner-all" value="120"/><br />
                    <label for="TaskId"><b>Tarea</b><font color="red">*</font> :</label>
                    <select id="TaskId" class="ui-corner-all ui-widget-content" multiple>
                    </select>
                </div>
                <div class="button-section">
                    <button id="display" onclick="return false;">Mostrar</button>
                </div>
            </div>
        </div>
        <div id="task-display" style="display:none;">
            <div class="ui-dialog-titlebar ui-widget-header ui-corner-all ui-helper-clearfix">
                <button id="returnToSelector" onclick="return false;">Regresar</button>
                <span class="ui-dialog-title"><span class="task-name"></span></span>
                <img id="larcoLogo" alt="Larco" src="<%= Page.ResolveUrl("~/Images/larco120x100.jpg") %>" />
            </div>
            <div class="task-totals">
                <table id="task_totals_table" width="100%" cellpadding="0" cellspacing="0" border="0" class="totals">
                    <thead></thead>
                    <tbody>
                        <tr>
                            <td>
                                <span class="text-totals" id="total_ordenes"></span>
                            </td>
                            <td>
                                Ordenes Urgentes/Vencidas en Larco
                            </td>
                            <td>
                                <span class="text-totals" id="total_piezas"></span>
                            </td>
                            <td>
                                Piezas Urgentes/Vencidas en Larco
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="text-totals" id="total_tarea_ordenes"></span>
                            </td>
                            <td>
                                Ordenes Urgentes/Vencidas en <span class="task-name"></span>
                            </td>
                            <td>
                                <span class="text-totals" id="total_tarea_piezas"></span>
                            </td>
                            <td>
                                Piezas Urgentes/Vencidas en <span class="task-name"></span>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="task-display-content">
                
            </div>

            <div id="dialog_container" style="display:none;"></div>
            <div id="filter_container" style="display:none;"></div>
    </div>
    </div>
    
</body>
</html>
