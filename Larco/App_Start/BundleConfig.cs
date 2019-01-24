﻿using EPE.Common;
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

            var cssBundle = bundles.GetBundleFor(BaseBundleConfig.SiteMasterCSSVirtualPath);
            cssBundle.Include(BaseBundleConfig.StylesPath + "app.css");

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
            /*****************************/

            var ventasJSBundle = new ScriptBundle(BaseBundleConfig.ScriptsPath + "ventas_js")
                .Include(ScriptsPath + "app/ventas.js");
            bundles.Add(ventasJSBundle);

            var dvJSBundle = new ScriptBundle(BaseBundleConfig.ScriptsPath + "dias_vencido_js")
                .Include(ScriptsPath + "app/dias_vencido.js");
            bundles.Add(dvJSBundle);

            var uveJSBundle = new ScriptBundle(BaseBundleConfig.ScriptsPath + "urgentes_vencidas_empleado_js")
                .Include(ScriptsPath + "app/urgentes_vencidas_empleado.js");
            bundles.Add(uveJSBundle);

            var materialesJSBundle = new ScriptBundle(BaseBundleConfig.ScriptsPath + "materiales_js")
                .Include(ScriptsPath + "app/materiales.js");
            bundles.Add(materialesJSBundle);

            var prodsJSBundle = new ScriptBundle(BaseBundleConfig.ScriptsPath + "productos_js")
                .Include(ScriptsPath + "app/productos.js");
            bundles.Add(prodsJSBundle);

            var tasksJSBundle = new ScriptBundle(BaseBundleConfig.ScriptsPath + "tareas_js")
                .Include(ScriptsPath + "app/tareas.js");
            bundles.Add(tasksJSBundle);
        }
    }
}