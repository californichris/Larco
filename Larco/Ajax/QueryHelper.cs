using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BS.Larco.Ajax
{
    public class QueryHelper : EPE.Common.Ajax.QueryHelper
    {
        protected override bool CheckPermissions()
        {
            return true;
        }
    }
}