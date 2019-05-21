<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditorOrdenes.aspx.cs" Inherits="BS.Larco.Herramientas.EditorOrdenes" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
        <style type="text/css">
            #EditorOrdenes_table_filter {display:none;}
        </style>
	<%: Scripts.Render("~/Scripts/extra_widgets_js", "~/Scripts/editor_ordenes_js") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br/>
    <div class="catalog"></div>
</asp:Content>
