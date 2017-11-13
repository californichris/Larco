using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.UI;
using BS.Common.Dao;
using BS.Common.Entities;
using BS.Common.Utils;

namespace Larco
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoggerHelper.Info("Site.Master Page_Load Start.");
            if (!IsPostBack)
            {
                string loginName = GetUserLogin();
                LoggerHelper.Debug("loginName = " + loginName);
                Entity user = GetUser(loginName);
                IList<Entity> modules = null;
                if (user != null)
                {
                    modules = GetUserModules(user);
                    Session["CurrentUserName"] = user.GetProperty("USER_NAME");
                }

                if (!UserHavePermissions(modules))
                //if (false)
                {
                    LoggerHelper.Debug("user don't have permissions to access this page redirenting.");
                    Response.Redirect(Request.ApplicationPath + "/InvalidAccess.aspx");
                }

                if (!Page.ClientScript.IsClientScriptBlockRegistered("menuGlobals"))
                {
                    StringBuilder menuGlobals = new StringBuilder();
                    menuGlobals.Append("\n<script type='text/javascript'>\n");
                    menuGlobals.Append("const LOGIN_NAME = '").Append(loginName).Append("';\n");                    
                    if (user != null)
                    {

                        menuGlobals.Append("const USER_ID = '").Append(user.GetProperty("USE_ID")).Append("';\n");
                        menuGlobals.Append("const USER_NAME = '").Append(user.GetProperty("USER_NAME")).Append("';\n");
                    }

                    //Modules data
                    if (modules != null)
                    {
                        menuGlobals.Append("var USER_MODULES = '[").Append(SerializeModules(modules)).Append("]';\n");
                        Entity module = GetModule(modules);
                        if (module != null)
                        {
                            //menuGlobals.Append("const EDIT_ACCESS = ").Append(module.GetProperty("EditAccess").ToLower()).Append(";\n");
                            //menuGlobals.Append("const DELETE_ACCESS = ").Append(module.GetProperty("DeleteAccess").ToLower()).Append(";\n");
                        }
                    }

                    menuGlobals.Append("</script>");

                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "menuGlobals", menuGlobals.ToString());
                }
            }
            LoggerHelper.Info("Site.Master Page_Load End.");
        }

        private Entity GetUser(string userName)
        {
            if (Session["CurrentUser"] == null)
            {
                BS.Common.Entities.Page.Page usersPage = DAOFactory.Instance.GetPageInfoDAO().GetPageConfig("", "Users");
                Entity entity = EntityUtils.CreateEntity(usersPage);
                entity.SetProperty("USE_Login", userName);

                IList<Entity> list = DAOFactory.Instance.GetCatalogDAO().FindEntities(entity);
                if (list.Count == 1)
                {
                    Session["CurrentUser"] = list[0];
                }

                Entity user = (Entity)Session["CurrentUser"];
                Session["CurrentUserName"] = user.GetProperty("USE_Name");
            }
                        
            return (Entity) Session["CurrentUser"];
        }

        //TODO: Move security methods to a class and use the system cache instead of the session so it can be refreshed when necessary.
        private string SerializeModules(IList<Entity> roleMods)
        {
            JavaScriptSerializer ser = new JavaScriptSerializer();
            ser.MaxJsonLength = int.MaxValue;
            StringBuilder modules = new StringBuilder();

            foreach (Entity ent in roleMods)
            {
                modules.Append(ser.Serialize(ent.GetProperties())).Append(",");
            }

            if (modules.Length > 0)
            {
                modules.Remove(modules.Length - 1, 1);
            }

            return modules.ToString();
        }

        private Entity GetModule(IList<Entity> modules)
        {
            string reqPath = Request.Path;
            string path = reqPath.Replace(Request.ApplicationPath + "/", "");
            return ((List<Entity>)modules).Find(x => x.GetProperty("URL").Equals(path, StringComparison.InvariantCultureIgnoreCase));
        }

        private string GetRequestPage()
        {
            string reqPath = Request.Path;
            reqPath = reqPath.ToUpper().Replace(Request.ApplicationPath.ToUpper() + "/", "");

            return reqPath.ToLower();
        }

        private bool UserHavePermissions(IList<Entity> userModules)
        {
            return UserHavePermissions(GetRequestPage(), userModules);
        }

        private bool UserHavePermissions(string path, IList<Entity> userModules)
        {
            if (path == "InvalidAccess.aspx") return true;
            if (userModules == null || userModules.Count <= 0) return false;

            foreach (Entity userMod in userModules)
            {
                if (path.Equals(userMod.GetProperty("URL"), StringComparison.InvariantCultureIgnoreCase))
                {
                    return true;
                }
            }

            return false;
        }

        private IList<Entity> GetUserModules(Entity user)
        {
            LoggerHelper.Debug("Getting user roles.");
            if (Session["CurrentUserModules"] == null)
            {
                BS.Common.Entities.Page.Page userRolePage = DAOFactory.Instance.GetPageInfoDAO().GetPageConfig("", "UserRoles");
                Entity userRoleEntity = EntityUtils.CreateEntity(userRolePage);
                userRoleEntity.SetProperty("USE_ID", user.GetProperty("USE_ID"));
                IList<Entity> roles = DAOFactory.Instance.GetCatalogDAO().FindEntities(userRoleEntity);

                string _userRoles = "";
                foreach (Entity role in roles)
                {
                    _userRoles += role.GetProperty("Group_ID") + ",";                    
                }

                if (_userRoles.Length > 0)
                {
                    _userRoles = _userRoles.Remove(_userRoles.Length - 1);
                }


                LoggerHelper.Debug("User roles are " + _userRoles);
                BS.Common.Entities.Page.Page pageRoleMods = DAOFactory.Instance.GetPageInfoDAO().GetPageConfig("", "RoleModules");

                Entity roleModEntity = EntityUtils.CreateEntity(pageRoleMods);
                roleModEntity.SetProperty("Group_ID", "LIST_" + _userRoles);
                IList<Entity> roleMods = DAOFactory.Instance.GetCatalogDAO().FindEntities(roleModEntity);

                //TODO: sort by moduleId then removed duplicates
                ((List<Entity>)roleMods).Sort((x, y) => SortRoleModules(x, y));
                string _prevModule = "";
                for (int i = roleMods.Count -1; i >= 0; i--)
                {
                    Entity roleMod = roleMods[i];
                    if (_prevModule.Equals(roleMod.GetProperty("ModuleName")))
                    {
                        roleMods.RemoveAt(i);
                    }

                    _prevModule = roleMod.GetProperty("ModuleName");
                }

                Session["CurrentUserModules"] = roleMods;
            }

            return (IList<Entity>) Session["CurrentUserModules"];
        }

        private int SortRoleModules(Entity ent1, Entity ent2)
        {
            return ent1.GetProperty("ModuleId").CompareTo(ent2.GetProperty("ModuleId"));
        }

        private string GetUserLogin()
        {
            string loginName = "";
            if (Session["CurrentUserLogin"] == null)
            {
                try
                {
                    string[] name = { "" };
                    if (!string.IsNullOrEmpty(System.Web.HttpContext.Current.User.Identity.Name))
                    {
                        loginName = System.Web.HttpContext.Current.User.Identity.Name;
                    }

                    LoggerHelper.Debug("loginName before split = " + loginName);

                    if (name.Length > 1)
                    {
                        loginName = name[1];
                    }
                }
                catch (Exception e)
                {
                    LoggerHelper.Error(e);
                }

                if (!string.IsNullOrEmpty(loginName))
                {
                    Session["CurrentUserLogin"] = loginName;
                }
            }
            else
            {
                loginName = (string)Session["CurrentUserLogin"];
            }

            return loginName;
        }
    }
}
