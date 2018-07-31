using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.UI;
using EPE.Common.Dao;
using EPE.Common.Entities;
using EPE.Common.Utils;

namespace Larco
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoggerHelper.Start();
            if (!IsPostBack)
            {
                string loginName = GetUserLogin();
                LoggerHelper.Debug("loginName = " + loginName);

                if (string.IsNullOrEmpty(loginName))
                {
                    LoggerHelper.Debug("Session expired redirenting to logon page.");
                    Response.Redirect(Request.ApplicationPath + "/Logon.aspx");
                }


                if (!AuthorizationUtils.UserHavePermissions())
                {
                    LoggerHelper.Debug("user don't have permissions to access this page redirenting.");
                    Response.Redirect(Request.ApplicationPath + "/InvalidAccess.aspx");
                }

                Entity user = GetUser(loginName);
                if (user != null)
                {
                    Session["CurrentUserName"] = user.GetProperty("UserName");
                }

                if (!Page.ClientScript.IsClientScriptBlockRegistered("menuGlobals"))
                {
                    StringBuilder menuGlobals = new StringBuilder();
                    menuGlobals.Append("\n<script type='text/javascript'>\n");

                    AuthorizationUtils.AppendModulesInfo(menuGlobals);

                    menuGlobals.Append("const LOGIN_NAME = '").Append(loginName).Append("';\n");
                    if (user != null)
                    {

                        menuGlobals.Append("const USER_ID = '").Append(user.GetProperty("USE_ID")).Append("';\n");
                        menuGlobals.Append("const USER_NAME = '").Append(user.GetProperty("USER_NAME")).Append("';\n");
                    }

                    menuGlobals.Append("</script>");

                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "menuGlobals", menuGlobals.ToString());
                }
            }
            LoggerHelper.End();
        }

        private Entity GetUser(string userLogin)
        {
            if (string.IsNullOrEmpty(userLogin)) return null;

            if (Session["CurrentUser"] == null)
            {
                EPE.Common.Entities.Page.Page usersPage = DAOFactory.Instance.GetPageInfoDAO().GetPageConfig("", "Users");
                Entity entity = EntityUtils.CreateEntity(usersPage);
                entity.SetProperty("USE_Login", userLogin);

                IList<Entity> list = DAOFactory.Instance.GetCatalogDAO().FindEntities(entity);
                if (list.Count == 1)
                {
                    Session["CurrentUser"] = list[0];
                    Entity user = (Entity)Session["CurrentUser"];
                    Session["CurrentUserName"] = user.GetProperty("USE_Name");
                }
            }

            return (Entity)Session["CurrentUser"];
        }

        private string GetUserLogin()
        {
            return (string)Session["CurrentUserLogin"];
        }
    }
}
