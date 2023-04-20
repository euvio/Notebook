using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinformPropertyGrid
{
    //public class AppSetting
    //{
    //    [Category("PLC")]
    //    public PLC PLC { get; set; }

    //    [Category("视觉")]

    //    [TypeConverter(typeof(ExpandableObjectConverter))]
    //    public Vision Vision { get; set; } = new Vision()
    //    {
    //        XOffset = 1,
    //        YOffset = 2,
    //        AngleOffset = 3
    //    };
    //}


    public class PLC
    {
        public string IP { get; set; }
        public int Port { get; set; }
        public int HeartbeatTimeoutMilliseconds { get; set; }
    }

    public class Vision
    {
        public double XOffset { get; set; }
        public double YOffset { get; set; }
        public double AngleOffset { get; set; }
    }
}
