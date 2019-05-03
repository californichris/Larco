<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditorOrdenes.aspx.cs" Inherits="BS.Larco.Herramientas.EditorOrdenes" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
	<%: Scripts.Render("~/Scripts/editor_scrap_js") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2>
    <div class="catalog"></div>
</asp:Content>
