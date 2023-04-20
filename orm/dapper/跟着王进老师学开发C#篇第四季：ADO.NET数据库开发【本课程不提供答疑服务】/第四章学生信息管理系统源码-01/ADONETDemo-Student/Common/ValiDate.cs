using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace Common
{
    /// <summary>
    /// 用来判断输入是否合法的静态类
    /// </summary>
    public static class ValiDate
    {
        //判断学号是否是95开头的5位数字
        public static bool ValiDateSNO(string txt)
        {
            Regex objRegex = new Regex(@"^[9][5]\d{3}$");
            return objRegex.IsMatch(txt);
        }
        //判断手机号码
        public static bool ValiDateMobile(string txt)
        {
            Regex objRegex = new Regex(@"^[1][3578]\d{9}$");
            return objRegex.IsMatch(txt);
        }
        //判断手机号码
        public static bool ValiDateEmail(string txt)
        {
            Regex objRegex = new Regex(@"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
            return objRegex.IsMatch(txt);
        }
    }
}
