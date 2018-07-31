using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using EPE.Common.Dao;
using EPE.Common.Dao.Handlers;
using EPE.Common.Entities;
using EPE.Common.Utils;

namespace BS.Larco.Dao.Sql
{
    public class LarcoSqlDAO : BaseSqlDAO, ILarcoDAO
    {
        public LarcoSqlDAO():base()
        {
        }

        public LarcoSqlDAO(string connString) : base(connString)
        {
        }

        public IList<Entity> GetLatestOrderByClient(Entity entity)
        {
            LoggerHelper.Info("Start");

            IList<Entity> list = new List<Entity>();
            try
            {
                StringBuilder query = new StringBuilder();
                IList<DBParam> queryParams = new List<DBParam>();
                
                query.Append("SELECT TOP 1 ITE_Nombre,Interna,Entrega,OrdenCompra,Requisicion,Terminal ");
                query.Append("FROM tblOrdenes WHERE ClientId = @p0 ORDER BY ITE_Nombre DESC");
                LoggerHelper.Debug(query.ToString());
                queryParams.Add(new DBParam(queryParams, entity.GetProperty("ClientId"), DbType.String, false));

                ResultSetHandler<IList<Entity>> h = new EntityHandler<Entity>(entity);
                list = GetQueryRunner().Query(GetConnection(), new StatementWrapper(query, queryParams), h);
            }
            catch (Exception e)
            {
                LoggerHelper.Error(e);
                throw new Exception("Unable to Get Latest Order By Client.", e);
            }
            finally
            {
                LoggerHelper.Info("End");
            }

            return list;
        }
    }
}