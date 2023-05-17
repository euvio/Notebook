using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
/* **************************************************************
 * 目的：
 * 验证重置Binding的Source，能更新目标控件的依赖属性
 * **************************************************************
 */
namespace Test.Scenario1
{
    /// <summary>
    /// Interaction logic for View.xaml
    /// </summary>
    public partial class View : Window
    {
        public View()
        {
            InitializeComponent();
            this.DataContext = new Model() { Name = "陈一发" };
        }

        /* 重新设置binding的Source，目标属性刷新，从 陈一发 变成 许嵩
         */
        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.DataContext = new Model() { Name = "许嵩" };
        }
    }
}
