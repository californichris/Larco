using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using BS.Common.Ajax;
using BS.Common.Dao;
using BS.Common.Entities;
using BS.Common.Entities.Page;
using BS.Common.Utils;
using BS.Larco.Dao;

namespace BS.Larco.Ajax
{
    public class Larco : AjaxBase
    {
        protected virtual IPageInfoDAO GetPageInfoDAO()
        {
            return (IPageInfoDAO) FactoryUtils.GetDAO(ConfigurationManager.AppSettings["IPageInfoDAO"]);
        }

        protected virtual ILarcoDAO GetLarcoDAO()
        {
            return (ILarcoDAO) FactoryUtils.GetDAO(ConfigurationManager.AppSettings["LarcoDAO"]);
        }

        public string GetLatestOrderByClient(HttpRequest request)
        {
            LoggerHelper.Info("Start");
            IList<Entity> list = new List<Entity>();

            try
            {
                Page page = GetPage(request);
                Entity entity = CreateEntity(request, page);

                ILarcoDAO larcoDAO = GetLarcoDAO();
                list = larcoDAO.GetLatestOrderByClient(entity);
            }
            catch (Exception e)
            {
                LoggerHelper.Error(e);
                return ErrorResponse(e);
            }
            finally
            {
                LoggerHelper.Info("End");
            }

            return CreateEntityListResponse(list);
        }

        private Page GetPage(HttpRequest request)
        {
            if (string.IsNullOrEmpty(request.Params[PageInfo.PageIdParam]) && string.IsNullOrEmpty(request.Params[PageInfo.PageNameParam])) throw new Exception("pageName can not be null.");

            return GetPageInfoDAO().GetPageConfig(request.Params[PageInfo.PageIdParam], request.Params[PageInfo.PageNameParam]);
        }
    }
}