using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using DBUtility;
using Models;


namespace DAL
{
    /// <summary>
    /// 针对Student操作的方法
    /// </summary>
    public class StudentServices
    {
        //获取所有学生信息
        public DataTable GetAllStudent()
        {
            try
            {
                SqlDataReader objReader = SQLHelper.GetReaderByProcedure("GetAllStudent",null);
                DataTable dt = new DataTable();
                dt.Load(objReader);
                return dt;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        //获取所有学生的数量 
        public object GetStudentNumber()
        {
            try
            {
                return SQLHelper.GetOneResultByProcedure("GetStudentNumber", null);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        //查询学生信息
        public DataTable GetStudent(string sno, string sname, string gender, string mobile)
        {
            //准备参数 
            SqlParameter[] para = new SqlParameter[] 
            {
                new SqlParameter("@SNO",sno+'%'),
                new SqlParameter("@SName",'%'+sname+'%'),
                new SqlParameter("@Gender",gender+'%'),
                new SqlParameter("@Mobile",mobile+'%'),
            };
            //开始执行
            try
            {
                SqlDataReader objReader = SQLHelper.GetReaderByProcedure("GetStudent", para);
                DataTable dt = new DataTable();
                dt.Load(objReader);
                return dt;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        //根据学号查询某一个学生信息
        public Student GetStudentBySNO(int sno)
        {
            SqlParameter[] para = new SqlParameter[]
            {
                new SqlParameter("@SNO",sno),
            };
            try
            {
                SqlDataReader objReader = SQLHelper.GetReaderByProcedure("GetOneStudent", para);
                if (!objReader.HasRows) return null;
                else
                {
                    Student objStudent = new Student() ;
                    if (objReader.Read())
                    {
                        objStudent = new Student
                        {
                            SNO = Convert.ToInt32(objReader["SNO"]),
                            SName = objReader["SName"].ToString(),
                            Gender = objReader["Gender"].ToString(),
                            Birthday = Convert.ToDateTime(objReader["Birthday"]),
                            Mobile = objReader["Mobile"].ToString(),
                            Email = objReader["Email"].ToString(),
                            HomeAddress = objReader["HomeAddress"].ToString(),
                            PhotoPath=objReader["PhotoPath"].ToString(),
                        };
                       
                    }
                    objReader.Close();
                    return objStudent;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        //添加学生
        public bool AddStudent(Student objStudent)
        {
            SqlParameter[] para = new SqlParameter[]
            {
                new SqlParameter("@SNo",objStudent.SNO),
                new SqlParameter("@SName",objStudent.SName),
                new SqlParameter("@Gender",objStudent.Gender),
                new SqlParameter("@Birthday",objStudent.Birthday),
                new SqlParameter("@Mobile",objStudent.Mobile),
                new SqlParameter("@Email",objStudent.Email),
                new SqlParameter("@HomeAddress",objStudent.HomeAddress),
                new SqlParameter("@PhotoPath",objStudent.PhotoPath),
            };

            //调用
            try
            {
                if (SQLHelper.UpdateByProcedure("AddStudent", para) == 1) return true;
                else return false;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        //修改学生
        public bool UpdateStudent(Student objStudent)
        {
            //封装参数数据
            SqlParameter[] para = new SqlParameter[]
            {
                new SqlParameter("@SNo",objStudent.SNO),
                new SqlParameter("@SName",objStudent.SName),
                new SqlParameter("@Gender",objStudent.Gender),
                new SqlParameter("@Birthday",objStudent.Birthday),
                new SqlParameter("@Mobile",objStudent.Mobile),
                new SqlParameter("@Email",objStudent.Email),
                new SqlParameter("@HomeAddress",objStudent.HomeAddress),
                new SqlParameter("@PhotoPath",objStudent.PhotoPath),
            };

            //执行
            try
            {
                if (SQLHelper.UpdateByProcedure("UpdateStudent", para) == 1) return true;
                else return false;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        //删除学生
        public bool DeleteStudent(int sno)
        {
            SqlParameter[] para = new SqlParameter[]
            {
                new SqlParameter("@SNO",sno),
            };
            //执行 
            try
            {
                if (SQLHelper.UpdateByProcedure("DeleteStudent", para) == 1) return true;
                else return false;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}

