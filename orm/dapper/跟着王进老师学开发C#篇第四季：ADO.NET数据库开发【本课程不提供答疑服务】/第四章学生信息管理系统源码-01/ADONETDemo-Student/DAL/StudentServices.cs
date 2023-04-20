using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using System.Data.SqlClient;
using DBUtility;

namespace DAL
{
    /// <summary>
    /// 学生信息访问的类
    /// </summary>
    public class StudentServices
    {
        //获取所有的学生信息
        public List<Student> GetAllStudent()
        {
            List<Student> objList = new List<Student>();

            string sql = "Select SNO, SName, Gender, Birthday, Mobile, Email, HomeAddress, PhotoPath from Student ";
            try
            {
                //通过数据库通用访问类获取数据
                SqlDataReader objReader = SQLHelper.GetReader(sql);
                if (!objReader.HasRows) return null;
                else
                {
                    while (objReader.Read())
                    {
                        objList.Add(
                            new Student
                            {
                                SNO = Convert.ToInt32(objReader["SNO"]),
                                SName = objReader["SName"].ToString(),
                                Gender = objReader["Gender"].ToString(),
                                Birthday= Convert.ToDateTime(objReader["Birthday"]),
                                Mobile=objReader["Mobile"].ToString(),
                                Email=objReader["Email"].ToString(),
                                HomeAddress=objReader["HomeAddress"].ToString(),
                                PhotoPath=objReader["PhotoPath"].ToString(),
                            }
                         );
                    }
                    objReader.Close();
                    return objList;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
   
        }
        //获取当前一个学生信息
        public Student GetCurrentStudent(string sno)
        {
            
            string sql = "Select SNO, SName, Gender, Birthday, Mobile, Email, HomeAddress, PhotoPath from Student  Where SNO={0}";
            sql = string.Format(sql, sno);
            try
            {
                //通过数据库通用访问类获取数据
                SqlDataReader objReader = SQLHelper.GetReader(sql);
                if (!objReader.HasRows) return null;
                else
                {
                    Student objStudent = new Student();
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
                            PhotoPath = objReader["PhotoPath"].ToString(),
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
        //获取学生的数量 
        public int GetStudentNumber()
        {
            string sql = "Select Count(*) from Student ";
            try
            {
                return Convert.ToInt32(SQLHelper.GetOneResult(sql));
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        //按照学号进行查询 
        public List<Student> GetStudentBySNO(string sno)
        {
            //准备sql语句 
            string sql = " Select SNO,SName,Gender,Birthday,Mobile,Email,HomeAddress,PhotoPath ";
            sql += " from Student Where SNo Like '{0}%'";
            sql = string.Format(sql,sno);

            //访问数据库
            try
            {
                SqlDataReader objReader = SQLHelper.GetReader(sql);
                if (!objReader.HasRows) return null;
                else
                {
                    List<Student> objList = new List<Student>();
                    //读取数据集
                    while (objReader.Read())
                    {
                        objList.Add(
                            new Student
                            {
                                SNO = Convert.ToInt32(objReader["SNO"]),
                                SName = objReader["SName"].ToString(),
                                Gender = objReader["Gender"].ToString(),
                                Birthday = Convert.ToDateTime(objReader["Birthday"]),
                                Mobile = objReader["Mobile"].ToString(),
                                Email = objReader["Email"].ToString(),
                                HomeAddress = objReader["HomeAddress"].ToString(),
                                PhotoPath = objReader["PhotoPath"].ToString(),
                            }
                        );
                    }
                    //关闭Datareader 
                    objReader.Close();
                    //返回 
                    return objList;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        //按照姓名进行查询 
        public List<Student> GetStudentBySName(string sname)
        {
            //准备sql语句 
            string sql = " Select SNO,SName,Gender,Birthday,Mobile,Email,HomeAddress,PhotoPath ";
            sql += " from Student Where SName Like '%{0}%'";
            sql = string.Format(sql, sname);

            //访问数据库
            try
            {
                SqlDataReader objReader = SQLHelper.GetReader(sql);
                if (!objReader.HasRows) return null;
                else
                {
                    List<Student> objList = new List<Student>();
                    //读取数据集
                    while (objReader.Read())
                    {
                        objList.Add(
                            new Student
                            {
                                SNO = Convert.ToInt32(objReader["SNO"]),
                                SName = objReader["SName"].ToString(),
                                Gender = objReader["Gender"].ToString(),
                                Birthday = Convert.ToDateTime(objReader["Birthday"]),
                                Mobile = objReader["Mobile"].ToString(),
                                Email = objReader["Email"].ToString(),
                                HomeAddress = objReader["HomeAddress"].ToString(),
                                PhotoPath = objReader["PhotoPath"].ToString(),
                            }
                        );
                    }
                    //关闭Datareader 
                    objReader.Close();
                    //返回 
                    return objList;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        //按照手机号码进行查询 
        public List<Student> GetStudentByMobile(string mobile)
        {
            //准备sql语句 
            string sql = " Select SNO,SName,Gender,Birthday,Mobile,Email,HomeAddress,PhotoPath ";
            sql += " from Student Where Mobile Like '%{0}%'";
            sql = string.Format(sql, mobile);

            //访问数据库
            try
            {
                SqlDataReader objReader = SQLHelper.GetReader(sql);
                if (!objReader.HasRows) return null;
                else
                {
                    List<Student> objList = new List<Student>();
                    //读取数据集
                    while (objReader.Read())
                    {
                        objList.Add(
                            new Student
                            {
                                SNO = Convert.ToInt32(objReader["SNO"]),
                                SName = objReader["SName"].ToString(),
                                Gender = objReader["Gender"].ToString(),
                                Birthday = Convert.ToDateTime(objReader["Birthday"]),
                                Mobile = objReader["Mobile"].ToString(),
                                Email = objReader["Email"].ToString(),
                                HomeAddress = objReader["HomeAddress"].ToString(),
                                PhotoPath = objReader["PhotoPath"].ToString(),
                            }
                        );
                    }
                    //关闭Datareader 
                    objReader.Close();
                    //返回 
                    return objList;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        //判断学号是否存在 
        public bool IsExistSNO(string sno)
        {
            string sql = "Select SName from Student Where SNo='{0}'";
            sql = string.Format(sql,sno);
            try
            {
                SqlDataReader objReader = SQLHelper.GetReader(sql);
                if (!objReader.HasRows) return false;
                else return true;
            }
            catch (Exception ex)
            {

                throw ex;
            }


        }
        //添加学生信息 
        public int AddStudent(Student objStudent)
        {
            //准备SQL语句
            string sql = "Insert into Student (SNO, SName, Gender, Birthday, Mobile, Email, HomeAddress, PhotoPath) ";
            sql += " values({0},'{1}','{2}','{3}','{4}','{5}','{6}','{7}')";
            sql = string.Format(sql, objStudent.SNO, objStudent.SName, objStudent.Gender, objStudent.Birthday, objStudent.Mobile,
                objStudent.Email, objStudent.HomeAddress, objStudent.PhotoPath);
            //提交
            try
            {
                return SQLHelper.Update(sql);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        //修改学生信息 
        public int UpdateSutdent(Student objStudent)
        {
            //准备修改SQL语句
            string sql = "Update Student Set Sname = '{1}', Gender = '{2}', Birthday = '{3}', Mobile = '{4}',";
            sql += "Email = '{5}', HomeAddress = '{6}', PhotoPath = '{7}'  Where SNO = {0}";
            sql = string.Format(sql, objStudent.SNO, objStudent.SName, objStudent.Gender, objStudent.Birthday, objStudent.Mobile,
               objStudent.Email, objStudent.HomeAddress, objStudent.PhotoPath);

            //提交修改
            try
            {
                return SQLHelper.Update(sql);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        //删除学生信息
        public int DeleteStudent(string sno)
        {
            string sql = "Delete from Student Where SNO={0}";
            sql = string.Format(sql, sno);
            try
            {
                return SQLHelper.Update(sql);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}

 