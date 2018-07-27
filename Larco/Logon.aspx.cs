using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using BS.Common.Dao;
using BS.Common.Entities;
using BS.Common.Utils;

namespace BS.Larco
{
    public partial class Logon : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            this.cmdLogin.ServerClick += new System.EventHandler(this.cmdLogin_ServerClick);
        } 

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private bool ValidateUser(string userName, string passWord)
        {
            BS.Common.Entities.Page.Page usersPage = DAOFactory.Instance.GetPageInfoDAO().GetPageConfig("", "Users");
            Entity entity = EntityUtils.CreateEntity(usersPage);
            entity.SetProperty("USE_Login",userName);
            entity.SetProperty("USE_Password", passWord);

            IList<Entity> list = DAOFactory.Instance.GetCatalogDAO().FindEntities(entity, FilterInfo.SearchType.AND);
            if (list.Count == 1)
            {
                Session["CurrentUser"] = list[0];
                return true;                
            }

            return false;
        }

        private void cmdLogin_ServerClick(object sender, System.EventArgs e)
        {
            if (ValidateUser(txtUserName.Value, txtUserPass.Value))
            {
                //TODO: add expiration to web config
                FormsAuthenticationTicket tkt;
                string cookiestr;
                HttpCookie ck;
                tkt = new FormsAuthenticationTicket(1, txtUserName.Value, DateTime.Now, DateTime.Now.AddMinutes(60), chkPersistCookie.Checked, "your custom data");
                cookiestr = FormsAuthentication.Encrypt(tkt);
                ck = new HttpCookie(FormsAuthentication.FormsCookieName, cookiestr);
                if (chkPersistCookie.Checked)
                {
                    ck.Expires = tkt.Expiration;
                }
                    
                ck.Path = FormsAuthentication.FormsCookiePath;
                Response.Cookies.Add(ck);

                string strRedirect;
                strRedirect = Request["ReturnUrl"];
                if (strRedirect == null)
                {
                    strRedirect = "Default.aspx";
                }                    
                Response.Redirect(strRedirect, true);
            }
            else
            {
                Response.Redirect("Logon.aspx", true);
            }                
        }
    }
}