using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace DBUtility
{
    /// <summary>
    /// 连接SQL Server静态通用类库
    /// </summary>
    public static class SQLHelper
    {
        //连接字符串
        private static string connString = ConfigurationManager.ConnectionStrings["connString"].ToString();

        //增删改---方法 
        public static int Update(string sql)
        {
            //实例化连接类 Connection--SqlConnection
            SqlConnection conn = new SqlConnection(connString);

            //实例化Command对象 
            SqlCommand cmd = new SqlCommand(sql, conn);

            //执行
            try
            {
                //打开连接
                conn.Open();

                //执行command 
                return cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                //关闭数据库连接
                conn.Close();
            }

        }

        //获取单个结果集---方法
        public static object GetOneResult(string sql)
        {
            //实例化连接类
            SqlConnection conn = new SqlConnection(connString);
            //实例化Command 
            SqlCommand cmd = new SqlCommand(sql, conn);
            //执行
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

        //获取多个结果集---方法
        public static SqlDataReader GetReader(string sql)
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
    }
}
