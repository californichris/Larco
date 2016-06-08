using System;
using System.Web.Security;

namespace BS.Larco
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["CurrentUserLogin"] = null;
            Session["CurrentUserName"] = null;
            Session["CurrentUser"] = null;
            Session["CurrentUserModules"] = null;

            FormsAuthentication.SignOut();
            Response.Redirect("Logon.aspx", true);
        }
    }
}