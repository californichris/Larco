<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logon.aspx.cs" Inherits="BS.Larco.Logon" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <h3>
           <font face="Verdana">Logon Page</font>
        </h3>
        <table>
           <tr>
              <td>Email:</td>
              <td><input id="txtUserName" type="text" runat="server"></td>
              <td><ASP:RequiredFieldValidator ControlToValidate="txtUserName"
                   Display="Static" ErrorMessage="*" runat="server" 
                   ID="vUserName" /></td>
           </tr>
           <tr>
              <td>Password:</td>
              <td><input id="txtUserPass" type="password" runat="server"></td>
              <td><ASP:RequiredFieldValidator ControlToValidate="txtUserPass"
                  Display="Static" ErrorMessage="*" runat="server" 
                  ID="vUserPass" />
              </td>
           </tr>
           <tr>
              <td>Persistent Cookie:</td>
              <td><ASP:CheckBox id="chkPersistCookie" runat="server" autopostback="false" /></td>
              <td></td>
           </tr>
        </table>
        <input type="submit" Value="Logon" runat="server" ID="cmdLogin"><p></p>
        <asp:Label id="lblMsg" ForeColor="red" Font-Name="Verdana" Font-Size="10" runat="server" />
    </div>
    </form>
</body>
</html>
