<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logon.aspx.cs" Inherits="BS.Larco.Logon" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Iniciar sesion &middot; Larco</title>
    <link href="Images/favicon.ico" rel="shortcut icon"/>
	<link href="Styles/Site.css" rel="stylesheet"/>
	<link href="Styles/blitzer/jquery-ui.css" rel="stylesheet"/>
	<style type="text/css">
		.center-content {
			margin: 0 auto;
			padding: 0;
			width: 960px;
		}	
		
		.form-signin-heading {
			line-height: 30px;
		}
		
		.login-btn {
			width: 100%;
		}
		
		.logo-font {
			font-family: calibri;
			font-size: 2em;
		}

        .login-form {
	        width: 300px;
	        height: 200px;
	        box-shadow: 4px 4px 4px #D2D3D4;
	        padding: 4px;
        }
	</style>
    <script type="text/javascript" src="<%= Page.ResolveUrl("~/Scripts/jquery.js") %>"></script>
    <script type="text/javascript">
        var INVALID = '<%= HttpUtility.HtmlEncode(Request.QueryString["invalid"]) %>';
        $(document).ready(function () {
            $('#lblMsg').text('');
            if (INVALID) {
                $('#lblMsg').text('Credenciales invalidas.');
            }
        });
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div class="center-content">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td height="100px" align="center">
					<br/>
					<img src="Images/larco.jpg" alt="Larco" width="64" height="40" /><br/>
			      	<span class="logo-font"><big><strong>Bienvenido</strong>&nbsp;a Larco</big></span>      	      
			      	<br/>
			      	<span style="font-size:16px;">Ingresa tus credenciales</span><br/><br/>				
				</td>
			</tr>
			<tr>
				<td align="center" valign="top" height="470px">
			      <div class="login-form modal-form ui-widget ui-widget-content ui-corner-all">
			      	<span class="form-signin-heading"></span>
			        <fieldset>
			        	<label>Usuario:</label><br /><br />
                        <input id="txtUserName" type="text" runat="server" placeholder="Usuario"  class="text ui-corner-all">
                        <label>Password:</label><br /><br />
                        <input id="txtUserPass" type="password" runat="server" placeholder="Contraseña"  class="text ui-corner-all">
                        <input type="submit" Value="Iniciar sesion" runat="server" ID="cmdLogin" class="i-button ui-widget ui-state-default ui-corner-all"><p></p>
                        <ASP:CheckBox id="chkPersistCookie" runat="server" autopostback="false" Visible="false" />
                        <asp:Label id="lblMsg" ForeColor="red" Font-Name="Verdana" Font-Size="10" runat="server" />			        	
					</fieldset>        
			      </div>	
				</td>
			</tr>
		</table>        
	  <hr>	  
      <footer>
        <p>&copy; BeltranSoft 2016</p>
      </footer>	  
    </div>     
        
    
    </form>
</body>
</html>
