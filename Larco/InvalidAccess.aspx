<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvalidAccess.aspx.cs" Inherits="BS.Larco.InvalidAccess" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>Accesso Invalido</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />    
    <link href="<%= Page.ResolveUrl("~/Images/favicon.ico") %>" type="image/x-icon" rel="shortcut icon"/>
    <link href="<%= Page.ResolveUrl("~/Styles/Site.css") %>" rel="stylesheet" type="text/css" />
    <link href="<%= Page.ResolveUrl("~/Styles/blitzer/jquery-ui.css") %>" rel="stylesheet" type="text/css" />
</head>
<body>
    <div class="page ui-corner-all">
        <div class="ui-state-default ui-corner-all header">
            <table cellpadding="0" cellspacing="0" width="100%">
                <tr>
                    <td>
                        <div class="title bold">Larco</div>
                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="padding-right: 6px;">
                                    <span id="environment"></span>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td rowspan="2" width="125px">
                        <img alt="" src="<%= Page.ResolveUrl("~/Images/larco120x100.jpg") %>" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div id="menu-container">
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="main">
            <b>Usted no tiene permisos para accessar esta applicacion, por favor contacte al administrador.</b>
        </div>
        <div class="clear">
        </div>
    </div>
    <div class="footer">
    </div>
</body>
</html>

