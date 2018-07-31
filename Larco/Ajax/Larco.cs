using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using EPE.Common.Ajax;
using EPE.Common.Dao;
using EPE.Common.Entities;
using EPE.Common.Entities.Page;
using EPE.Common.Utils;
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

        public string SaveTemplate(HttpRequest request)
        {
            LoggerHelper.Info("Start");
            Entity entity = null;
            try
            {
                Page page = GetPage(request);
                entity = CreateEntity(request, page);

                List<PageField> fields = GetEscapeFields(page);
                foreach (PageField field in fields)
                {
                    LoggerHelper.Debug(field.FieldName + " is escapetext");
                    string escapeText = Microsoft.JScript.GlobalObject.unescape(entity.GetProperty(field.FieldName));
                    entity.SetProperty(field.FieldName, escapeText);
                }

                GetCatalogDAO(page).SaveEntity(entity);
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

            return SuccessResponse(entity);
        }

        public string CreateDocument(HttpRequest request)
        {
            LoggerHelper.Debug("start");
            try
            {
                Page page = GetPage(request);
                Entity entity = CreateEntity(request, page);
                Entity templateEnt = GetTemplate(request);

                string template = Microsoft.JScript.GlobalObject.unescape(templateEnt.GetProperty("Template"));
                template = ReplaceTemplateValues(template, entity);
                template = ReplaceTemplateImagePath(request, template);

                return GetHtmlWrapper(template);
            }
            catch (Exception e)
            {
                LoggerHelper.Error(e);
                return ErrorResponse(e);
            }
        }

        private string ReplaceTemplateValues(string template, Entity entity)
        {
            string path = @"#(\w+)#"; //match #anything_inside#
            Regex r = new Regex(path, RegexOptions.IgnoreCase);

            // Match the regular expression pattern against a text string.
            Match m = r.Match(template);
            while (m.Success)
            {
                string match = m.ToString();
                string property = match.Replace("#", "");
                string value = entity.GetProperty(property);

                if (value != null)
                {
                    template = template.Replace(match, value);
                }

                m = m.NextMatch();
            }

            return template;
        }

        private string ReplaceTemplateImagePath(HttpRequest request, string template)
        {
            string srcString = "src=\"" + request.Url.Scheme + "://" + request.Url.Host + ":" + request.Url.Port + request.Url.Segments[0] + request.Url.Segments[1] + "Images/";
            template = template.Replace("src=\"Images/", srcString);
            template = template.Replace("src=\"../Images/", srcString);

            return template;
        }

        private static string GetHtmlWrapper(string escapeText)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<html ");
            sb.Append("xmlns:o='urn:schemas-microsoft-com:office:office' ");
            sb.Append("xmlns:w='urn:schemas-microsoft-com:office:word'");
            sb.Append("xmlns='http://www.w3.org/TR/REC-html40'>");

            sb.Append("<head>");

            sb.Append("<!--[if gte mso 9]>");
            sb.Append("<xml>");
            sb.Append("<w:WordDocument>");
            sb.Append("<w:View>Print</w:View>");
            sb.Append("<w:Zoom>100</w:Zoom>");
            sb.Append("<w:DoNotOptimizeForBrowser/>");
            sb.Append("</w:WordDocument>");
            sb.Append("</xml>");
            sb.Append("<![endif]-->");

            sb.Append("<style>");
            sb.Append("<!-- /* Style Definitions */");
            sb.Append("@page Section1 {");
            sb.Append("   size:8.5in 11.0in; ");
            sb.Append("   margin:0.5in 0.5in 0.5in 0.5in; ");
            sb.Append("   mso-header-margin:.5in; ");
            sb.Append("   mso-footer-margin:.5in; ");
            sb.Append("   mso-paper-source:0; ");
            sb.Append("}");

            sb.Append(" div.Section1 {");
            sb.Append("   page:Section1;");
            sb.Append("}");

            sb.Append("-->");
            sb.Append("</style>");

            sb.Append("</head>");

            sb.Append("<body lang=EN-US style='tab-interval:.5in;font-family:Calibri;'>");
            sb.Append("<div class=Section1>");

            sb.Append(escapeText);

            sb.Append("</div>");
            sb.Append("</body>");
            sb.Append("</html>");

            return sb.ToString();
        }

        private Entity GetTemplate(HttpRequest request)
        {
            string templateName = request.Params["templateName"];
            string templateType = request.Params["templateType"];
            IPageInfoDAO pageDAO = (IPageInfoDAO)FactoryUtils.GetDAO(ConfigurationManager.AppSettings["IPageInfoDAO"]);
            EPE.Common.Entities.Page.Page pageLetter = pageDAO.GetPageConfig("", "Templates");

            Entity entityLetter = EntityUtils.CreateEntity(pageLetter);
            entityLetter.SetProperty("TemplateName", templateName);
            entityLetter.SetProperty("TemplateTypeText", templateType);

            IList<Entity> templates = DAOFactory.Instance.GetCatalogDAO().FindEntities(entityLetter, FilterInfo.SearchType.AND);

            return templates[0];
        }

        private List<PageField> GetEscapeFields(Page page)
        {
            List<PageField> fields = new List<PageField>();
            foreach (PageTab tab in page.Tabs)
            {
                foreach (PageField field in tab.Fields)
                {
                    if (field.Type.Equals("escapetext", StringComparison.InvariantCultureIgnoreCase))
                    {
                        fields.Add(field);
                    }
                }
            }

            return fields;
        }

        /// <summary>
        /// Returns the Catalog data source, with the proper query QueryBuilder depending on the specified page.connName
        /// </summary>
        /// <param name="page">The page</param>
        /// <returns>The Catalog data source</returns>
        protected virtual ICatalogDAO GetCatalogDAO(Page page)
        {
            return GetCatalogDAO(page.ConnName);
        }

        /// <summary>
        /// Returns the Catalog data source, with the proper query QueryBuilder depending on the specified connName
        /// </summary>
        /// <param name="connName">The connection name string</param>
        /// <returns>The Catalog data source</returns>
        protected virtual ICatalogDAO GetCatalogDAO(string connName)
        {
            BaseSqlDAO dao = (BaseSqlDAO)FactoryUtils.GetDAO(ConfigurationManager.AppSettings["ICatalogDAO"], connName);
            dao.SetQueryBuilder(DbUtils.GetQueryBuilder(connName));

            return (ICatalogDAO)dao;
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