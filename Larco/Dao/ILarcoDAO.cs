using System.Collections.Generic;
using BS.Common.Dao;
using BS.Common.Entities;

namespace BS.Larco.Dao
{
    public interface ILarcoDAO : IBaseDAO
    {
        IList<Entity> GetLatestOrderByClient(Entity entity);
    }
}
