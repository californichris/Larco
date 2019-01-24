<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tareas.aspx.cs" Inherits="BS.Larco.Catalogos.Tareas" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%: Scripts.Render("~/Scripts/tareas_js") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
