<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EditorOrdenes.aspx.cs" Inherits="BS.Larco.Herramientas.EditorOrdenes" %>
<%@ Import Namespace="System.Web.Optimization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        #EditorOrdenes_table_filter {display:none;}
        
        #EditorOrdenes_table input.text { 
            padding: 4px;
        }

        #EditorOrdenes_table .ui-datepicker-trigger {
            height: 20px;
            margin-top: -2px;
            margin-left: 2px;
        }

        #msg {
            float: right;
            margin-top: 2px;
            margin-bottom: 0;
            width: 800px;
            padding-top: 2px;
        }

    </style>
    <%: Styles.Render("~/Styles/extra_widgets_css") %>
	<%: Scripts.Render("~/Scripts/extra_widgets_js", "~/Scripts/editor_ordenes_js") %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2></h2><br/>
    <div class="catalog"></div>
</asp:Content>
