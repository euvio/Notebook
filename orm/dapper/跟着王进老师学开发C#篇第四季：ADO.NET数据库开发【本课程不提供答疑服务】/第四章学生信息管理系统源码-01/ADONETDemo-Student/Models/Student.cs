using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    /// <summary>
    /// 学生信息实体类
    /// </summary>
    public class Student
    {
        public int SNO { get; set; }  //学号
        public string SName { get; set; } //姓名
        public string Gender { get; set; } //性别 
        public DateTime Birthday { get; set; } //出生日期 
        public string Mobile { get; set; } //手机号码 
        public string Email { get; set; } //邮箱地址 
        public string HomeAddress { get; set; } //家庭住址 
        public string PhotoPath { get; set; } //照片路径
    }
}
