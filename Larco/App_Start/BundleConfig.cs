using EPE.Common;
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
            BaseBundleConfig.RegisterScriptBundles(bundles);
            /*********** Updating base bundleds ******************/
            var siteMasterBundle = bundles.GetBundleFor(BaseBundleConfig.SiteMasterJsVirtualPath);
            siteMasterBundle.Include(BaseBundleConfig.ScriptsPath + "larco_common.js");

            var multiSelectJSBundle = bundles.GetBundleFor(BaseBundleConfig.ExtraWidgetsJsVirtualPath);
            multiSelectJSBundle.Include(BaseBundleConfig.ScriptsPath + "jquery.mask.js");

            /*****************************/
            var styleBundle = new StyleBundle(StylesPath + "blitzer/jquery_css")
                .Include(StylesPath + "blitzer/jquery-ui.css")
                .Include(StylesPath + "blitzer/jquery-horizontal-menu.css")
                .Include(StylesPath + "blitzer/dataTables.jqueryui.css");
            bundles.Add(styleBundle);

            var jqplotBundle = new StyleBundle(StylesPath + "jqplot_css")
                .Include(StylesPath + "jquery.jqplot.css");
            bundles.Add(jqplotBundle);

            var jqplotJSBundle = new ScriptBundle(ScriptsPath + "jqplot_js")
                .Include(ScriptsPath + "dashboard_common.js")
                .Include(ScriptsPath + "jqplot/jquery.jqplot.js")
                .Include(ScriptsPath + "jqplot/jqplot.pieRenderer.js")
                .Include(ScriptsPath + "jqplot/jqplot.barRenderer.js")
                .Include(ScriptsPath + "jqplot/jqplot.categoryAxisRenderer.js")
                .Include(ScriptsPath + "jqplot/jqplot.pointLabels.js")
                .Include(ScriptsPath + "jqplot/jqplot.canvasOverlay.js");
            bundles.Add(jqplotJSBundle);
        }
    }
}