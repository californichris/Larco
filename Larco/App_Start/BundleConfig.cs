using System.Web.Optimization;

namespace BS.Common
{
    public static class BundleConfig
    {
        public static readonly string ScriptsPath = "~/Scripts/";
        public static readonly string StylesPath = "~/Styles/";

        public static readonly string QueryHelperJsVirtualPath = ScriptsPath + "query_helper_js";
        public static readonly string QueryHelperCSSVirtualPath = StylesPath + "query_helper_css";
        
        public static void RegisterScriptBundles(BundleCollection bundles)
        {
            var siteMasterBundle = new ScriptBundle(ScriptsPath + "site_master_js")
                .Include(ScriptsPath + "jquery.js")
                .Include(ScriptsPath + "jquery-ui.js")
                .Include(ScriptsPath + "jquery.dataTables.js")
                .Include(ScriptsPath + "jquery.json-2.4.js")
                .Include(ScriptsPath + "common.js")
                .Include(ScriptsPath + "larco_common.js")
                .Include(ScriptsPath + "date.js")
                .Include(ScriptsPath + "spin.js");
            bundles.Add(siteMasterBundle);

            var queryHelperBundle = new ScriptBundle(QueryHelperJsVirtualPath)
                 .Include(ScriptsPath + "jquery.carousel.js")
                 .Include(ScriptsPath + "prism.js");
            bundles.Add(queryHelperBundle);

            var pageConfigBundle = new ScriptBundle(ScriptsPath + "page_config_js")
                .Include(ScriptsPath + "jquery.carousel.js")
                .Include(ScriptsPath + "pageconfig.js");
            bundles.Add(pageConfigBundle);

            var jqplotJSBundle = new ScriptBundle(ScriptsPath + "jqplot_js")
                .Include(ScriptsPath + "dashboard_common.js")
                .Include(ScriptsPath + "jqplot/jquery.jqplot.js")
                .Include(ScriptsPath + "jqplot/jqplot.pieRenderer.js")
                .Include(ScriptsPath + "jqplot/jqplot.barRenderer.js")
                .Include(ScriptsPath + "jqplot/jqplot.categoryAxisRenderer.js")
                .Include(ScriptsPath + "jqplot/jqplot.pointLabels.js")
                .Include(ScriptsPath + "jqplot/jqplot.canvasOverlay.js");
            bundles.Add(jqplotJSBundle);

            var multiSelectJSBundle = new ScriptBundle(ScriptsPath + "extra_widgets_js")
                .Include(ScriptsPath + "jquery.multiselect.js")
                .Include(ScriptsPath + "jquery.multiselect.filter.js");
            bundles.Add(multiSelectJSBundle);

            var cssBundle = new StyleBundle(StylesPath + "site_master_css")
                .Include(StylesPath + "Site.css");
            bundles.Add(cssBundle);

            var styleBundle = new StyleBundle(StylesPath + "blitzer/jquery_css")
                .Include(StylesPath + "blitzer/jquery-ui.css")
                .Include(StylesPath + "blitzer/jquery-horizontal-menu.css")
                .Include(StylesPath + "blitzer/dataTables.jqueryui.css");                       
            bundles.Add(styleBundle);

            var jqplotBundle = new StyleBundle(StylesPath + "jqplot_css")
                .Include(StylesPath + "jquery.jqplot.css");
            bundles.Add(jqplotBundle);

            var multiSelectCSSBundle = new StyleBundle(StylesPath + "extra_widgets_css")
                .Include(StylesPath + "jquery.multiselect.css")
                .Include(StylesPath + "jquery.multiselect.filter.css");
            bundles.Add(multiSelectCSSBundle);

            var queryHelperCSSBundle = new StyleBundle(QueryHelperCSSVirtualPath)
                .Include(StylesPath + "prism.css");
            bundles.Add(queryHelperCSSBundle);
        }
    }
}