using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models
{
    /// <summary>
    /// 学生的实体类
    /// </summary>
    public class Student
    {
        public int SNO { get; set; }
        public string SName { get; set; }
        public string Gender { get; set; }
        public DateTime Birthday { get; set; }
        public string Mobile { get; set; }
        public string Email { get; set; }
        public string HomeAddress { get; set; }
        public string PhotoPath { get; set; }
    }
}
