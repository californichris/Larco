
namespace BS.Larco.Ajax
{
    public class Users : EPE.Common.Ajax.Users
    {
        protected override bool CheckPermissions()
        {
            return true;
        }
    }
}