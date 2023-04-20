using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace DBUtility
{
    /// <summary>
    /// SQLServer数据库访问通用静态类
    /// </summary>
    public static class SQLHelper
    {
        //连接字符串
        private static string connString = ConfigurationManager.ConnectionStrings["connString"].ToString();

        #region 标准化SQL语句 
        //标准化SQL语句实现数据库的增删改
        public static int Update(string sql)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                conn.Open();
                return cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        //标准化SQL语句获取单个结果
        public static object GetOneResult(string sql)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                conn.Open();
                return cmd.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        //标准化SQL语句实现结果集
        public static SqlDataReader GetResult(string sql)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                conn.Open();
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        //标准化SQL语句获得DataSet---未对表命名 
        public static DataSet GetDataSet(string sql)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            try
            {
                conn.Open();
                sda.Fill(ds);
                return ds;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        //标准化SQL语句获得DataSet--对表重命名 
        public static DataSet GetDataSet(Dictionary<string, string> sqlDic)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand();
            cmd.CommandType = CommandType.Text;
            cmd.Connection = conn;
            SqlDataAdapter sda = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            try
            {
                conn.Open();
                foreach (KeyValuePair<string, string> item in sqlDic)
                {
                    cmd.CommandText = item.Value;
                    sda.Fill(ds, item.Key);
                }
                return ds;
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                conn.Close();
            }

        }
        #endregion

        #region 参数化SQL语句
        //参数化SQL语句实现数据库的增删改
        public static int Update(string sql, SqlParameter[] para)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                conn.Open();
                if (para != null)
                {
                    cmd.Parameters.AddRange(para);
                }
                return cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        //参数化SQL语句获取打个结果
        public static object GetOneResult(string sql, SqlParameter[] para)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                conn.Open();
                if (para != null)
                {
                    cmd.Parameters.AddRange(para);
                }
                return cmd.ExecuteScalar();
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        //参数化SQL语句获取结果集
        public static SqlDataReader GetResult(string sql, SqlParameter[] para)
        {

            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand(sql, conn);
            try
            {
                conn.Open();
                if (para != null)
                {
                    cmd.Parameters.AddRange(para);
                }
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        #endregion

        #region 使用存储过程执行
        //调用存储过程实现增删改 
        public static int UpdateByProcedure(string procedureName, SqlParameter[] para)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = procedureName;
            try
            {
                conn.Open();
                if (para != null)
                {
                    cmd.Parameters.AddRange(para);
                }
                return cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
               conn.Close();
            }
        }
        //调用存储过程获得单个结果
        public static object GetOneResultByProcedure(string procedureName, SqlParameter[] para)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = procedureName;
            try
            {
                conn.Open();
                if (para != null)
                {
                    cmd.Parameters.AddRange(para);
                }
                return cmd.ExecuteScalar() ;
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                conn.Close();
            }
        }
        //调用存储过程获得结果集 
        public static SqlDataReader GetReaderByProcedure(string procedureName, SqlParameter[] para)
        {
            SqlConnection conn = new SqlConnection(connString);
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.CommandText = procedureName;
            try
            {
                conn.Open();
                if (para != null)
                {
                    cmd.Parameters.AddRange(para);
                }
                return cmd.ExecuteReader(CommandBehavior.CloseConnection);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        #endregion

    }
}


