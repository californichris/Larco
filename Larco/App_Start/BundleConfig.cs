using System.Web.Optimization;

namespace BS.Common
{
    public static class BundleConfig
    {
        public static void RegisterScriptBundles(BundleCollection bundles)
        {
            const string SCRIPTS_PATH = "~/Scripts/";

            var siteMasterBundle = new ScriptBundle(SCRIPTS_PATH + "site_master_js")
                .Include(SCRIPTS_PATH + "jquery.js")
                .Include(SCRIPTS_PATH + "jquery-ui.js")
                .Include(SCRIPTS_PATH + "jquery.dataTables.js")
                .Include(SCRIPTS_PATH + "jquery.json-2.4.js")
                .Include(SCRIPTS_PATH + "common.js")
                .Include(SCRIPTS_PATH + "spin.js");
            bundles.Add(siteMasterBundle);

            const string STYLES_APP_ROOT = "~/Styles/";
            var cssBundle = new StyleBundle(STYLES_APP_ROOT + "site_master_css")
                .Include(STYLES_APP_ROOT + "Site.css");

            var styleBundle = new StyleBundle(STYLES_APP_ROOT + "cupertino/jquery_css")
                .Include(STYLES_APP_ROOT + "cupertino/jquery-ui.css")
                .Include(STYLES_APP_ROOT + "cupertino/jquery-horizontal-menu.css")
                .Include(STYLES_APP_ROOT + "cupertino/dataTables.jqueryui.css");

            bundles.Add(cssBundle);
            bundles.Add(styleBundle);
        }
    }
}