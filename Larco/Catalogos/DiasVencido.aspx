<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DiasVencido.aspx.cs" Inherits="BS.Larco.Catalogos.DiasVencido" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <%: Styles.Render("~/Styles/extra_widgets_css") %>
    <%: Scripts.Render("~/Scripts/extra_widgets_js", "~/Scripts/dias_vencido_js") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br />
    <div class="catalog"></div>
</asp:Content>
