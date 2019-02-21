<%@ Page Title="Larco &middot; Home" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Larco._Default" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style type="text/css">
        .dashboard-dialog table.dataTable { width:100%!important; }
        
        .graph-buttons { opacity:.5; height:25px; }
        .graph-buttons:hover { opacity:1; } 

        .sumChart .jqplot-series-shadowCanvas, .countChart .jqplot-series-shadowCanvas {
            background-color: white;
        }
    </style>   
    <%: Styles.Render("~/Styles/jqplot_css") %>
    <%: Scripts.Render("~/Scripts/jqplot_js", "~/Scripts/default_js") %> 
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <table id="header_table" cellpadding="0" cellspacing="0" width="100%" style="display:none;">
        <tr>
            <td>
                <h2>
                     Larco Dashboard
                </h2>
            </td>
        </tr>
    </table>
    <div class="catalog" style="display: block;">
        <br />
        <table cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td width="100%" colspan="2">
                    <div id="urgentOrdersByInterna" style="height: 400px" title="Ordenes Urgentes Por Fecha Interna"></div>
                </td>
            </tr>
            <tr><td width="100%" colspan="2"><br/></td></tr>
            <tr>
                <td width="50%">
                    <div id="urgentOrderByTask" class="countChart" groupByfields="TaskName" title="Ordenes Urgentes Por Tarea" style="height: 400px"></div>
                </td>
                <td width="50%">

                </td>
            </tr>
            <tr><td width="100%" colspan="2"><br/><br/></td></tr>
            <tr>
                <td width="50%">
                </td>
                <td width="50%">
                </td>
            </tr>                                    
        </table>
    </div>

   <div id="detail_dialog" style="display:none;" class="dashboard-dialog" title="Detalle Ordenes">     
   </div>
</asp:Content>
