<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Ventas.aspx.cs" Inherits="BS.Larco.Herramientas.Ventas" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <style type="text/css">
            #StockParcial {display:inline;}
            #StockParcialCantidad {float: right; margin-right:1px; width:80%; display:inline;}
            table.ventas-detail div.dataTables_scrollBody table.dataTable tbody td,
            table.ventas-detail div.dataTables_scrollHead table.dataTable thead th ,
            table.ventas-detail div.dataTables_wrapper table.dataTable thead th,
            table.ventas-detail div.dataTables_wrapper table.dataTable tbody td
            {
                padding:2px 2px 2px 4px;
            }        
        </style>
    <%: Scripts.Render("~/Scripts/extra_widgets_js", "~/Scripts/ventas_js") %> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br />
    <div class="catalog"></div>
    <div id="merge_orders_info" style="display:none;">
    </div>
    <div id="additional_info" style="display:none;">
        <h3 style="margin-top:2px;">Informacion Adicional</h3>
        <table  width="100%" cellspacing="0" cellpadding="2" class="ventas-detail">
            <tbody>
                <tr>
                    <td width="20%" valign="top">
                        <h3 style="margin-top:2px;font-size: 11px;">Popularidad por Numero de Parte</h3>
                        <table id="popularidad_numero_parte_table" width="100%" cellspacing="0" cellpadding="0" style="font-size:10px;">
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
                    <td width="40%" rowspan="2" valign="top">
                        <h3 style="margin-top:2px;font-size: 11px;">Ordenes en Produccion por Numero de Parte</h3>
                        <table id="prod_orders_part_number_table" width="100%" cellspacing="0" cellpadding="0" style="font-size:10px;">
                            <thead>
                                <tr>
                                    <th>Orden</th>
                                    <th>Larco</th>
                                    <th>Cliente</th>
                                    <th>Disp.</th>
                                    <th>Tarea</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </td>
                    <td width="40%" rowspan="2" valign="top">
                        <h3 style="margin-top:2px;font-size: 11px;">Ordenes en produccion por Numero de Plano</h3>
                        <table id="prod_orders_plan_table" width="100%" cellspacing="0" cellpadding="0" style="font-size:10px;">
                            <thead>
                                <tr>
                                    <th>Orden</th>
                                    <th>Larco</th>
                                    <th>Cliente</th>
                                    <th>Disp.</th>
                                    <th>Tarea</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="20%" valign="top">
                        <h3 style="margin-top:2px;font-size: 11px;">Popularidad por Numero de Plano</h3>                        
                        <table id="popularidad_plano_table" width="100%" cellspacing="0" cellpadding="0" style="font-size:10px;">
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

                </tr>
            </tbody>
        </table>
    </div>
</asp:Content>
