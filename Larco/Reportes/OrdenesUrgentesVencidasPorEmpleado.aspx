﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrdenesUrgentesVencidasPorEmpleado.aspx.cs" Inherits="BS.Larco.Reportes.OrdenesUrgentesVencidasPorEmpleado" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        ul.export-menu { width: 190px!important; }
        ul.export-menu li a { display: initial; }
    </style>
    <%: Styles.Render("~/Styles/extra_widgets_css") %>
    <%: Scripts.Render("~/Scripts/extra_widgets_js", "~/Scripts/urgentes_vencidas_empleado_js") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br />
    <div class="catalog"></div>
</asp:Content>
