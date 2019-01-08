<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Productos.aspx.cs" Inherits="BS.Larco.Catalogos.Productos" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        #TareasProductos_table input[type=checkbox]  {margin: 0px 4px 0px 4px; height: 13px;}        
        #TareasProductos_table input[type=text]  {margin: 0px 2px 0px 2px; height: 12px; padding:2px;}        
    </style>
    <%: Scripts.Render("~/Scripts/productos_js") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
