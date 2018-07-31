using System.Collections.Generic;
using EPE.Common.Entities;
using EPE.Common.Dao;

namespace BS.Larco.Dao
{
    public interface ILarcoDAO : IBaseDAO
    {
        IList<Entity> GetLatestOrderByClient(Entity entity);
    }
}
