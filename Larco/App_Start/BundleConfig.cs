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
                .Include(SCRIPTS_PATH + "date.js")
                .Include(SCRIPTS_PATH + "spin.js");
            bundles.Add(siteMasterBundle);

            const string STYLES_APP_ROOT = "~/Styles/";
            var cssBundle = new StyleBundle(STYLES_APP_ROOT + "site_master_css")
                .Include(STYLES_APP_ROOT + "Site.css");
            bundles.Add(cssBundle);

            var styleBundle = new StyleBundle(STYLES_APP_ROOT + "blitzer/jquery_css")
                .Include(STYLES_APP_ROOT + "blitzer/jquery-ui.css")
                .Include(STYLES_APP_ROOT + "blitzer/jquery-horizontal-menu.css")
                .Include(STYLES_APP_ROOT + "blitzer/dataTables.jqueryui.css");                       
            bundles.Add(styleBundle);

            var multiSelectJSBundle = new ScriptBundle(SCRIPTS_PATH + "multiselect_js")
                .Include(SCRIPTS_PATH + "jquery.multiselect.js")
                .Include(SCRIPTS_PATH + "jquery.multiselect.filter.js");
            bundles.Add(multiSelectJSBundle);

            var multiSelectCSSBundle = new StyleBundle(STYLES_APP_ROOT + "multiselect_css")
                .Include(STYLES_APP_ROOT + "jquery.multiselect.css")
                .Include(STYLES_APP_ROOT + "jquery.multiselect.filter.css");
            bundles.Add(multiSelectCSSBundle);


            var jqplotJSBundle = new ScriptBundle(SCRIPTS_PATH + "jqplot_js")
               .Include(SCRIPTS_PATH + "dashboard_common.js")
               .Include(SCRIPTS_PATH + "jqplot/jquery.jqplot.js")
               .Include(SCRIPTS_PATH + "jqplot/jqplot.pieRenderer.js")
               .Include(SCRIPTS_PATH + "jqplot/jqplot.barRenderer.js")
               .Include(SCRIPTS_PATH + "jqplot/jqplot.categoryAxisRenderer.js")
               .Include(SCRIPTS_PATH + "jqplot/jqplot.pointLabels.js")
               .Include(SCRIPTS_PATH + "jqplot/jqplot.canvasOverlay.js");
            bundles.Add(jqplotJSBundle);

            var jqplotBundle = new StyleBundle(STYLES_APP_ROOT + "jqplot_css")
                .Include(STYLES_APP_ROOT + "jquery.jqplot.css");
            bundles.Add(jqplotBundle);
        }
    }
}