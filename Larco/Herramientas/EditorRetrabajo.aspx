<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditorRetrabajo.aspx.cs" Inherits="BS.Larco.Herramientas.EditorRetrabajo" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%: Scripts.Render("~/Scripts/extra_widgets_js", "~/Scripts/editor_retrabajo_js") %> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br />
    <div class="catalog"></div>
</asp:Content>
