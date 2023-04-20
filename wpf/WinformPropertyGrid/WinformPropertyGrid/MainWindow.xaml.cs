using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WinformPropertyGrid
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        AppSetting AppSettings = new AppSetting();
        public MainWindow()
        {
            Thread.CurrentThread.CurrentUICulture = CultureInfo.GetCultureInfo("en-US");
            Thread.CurrentThread.CurrentCulture = CultureInfo.GetCultureInfo("en-US");
            InitializeComponent();
            pg.SelectedObject= AppSettings;
        }


        [DefaultProperty("FilePath")]
        public class AppSetting
        {
            [Category("系统配置"),DisplayName("网络地址"),Description("PLC的IP地址，如 192.168.0.1")]
            public string IP { get; set; }
            [Category("系统配置"), DisplayName("通信端口"), Description("PLC的端口号，如 6677")]
            public int Port { get; set; }
            [Category("系统配置"), DisplayName("文件路径"), Description("配置文件的路径")]
            public Font FilePath { get; set; }
            [Category("软件信息"), DisplayName("版本号"), Description("软件的版本，格式是0.0.2")]
            [DefaultValue("hkdhskhdkhskhdkshkdhks")]
            public Path Version { get; set; }
            [Category("软件信息"), DisplayName("发布日期")]
            public DateTime ReleaseDate { get; set; }
            [Category("软件信息"), DisplayName("公司名称"), Description("我们是一家杰出的智能科技公司")]
            public string CompanyName { get; set; }
        }
    }
}
