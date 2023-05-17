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

namespace Test.Scenario2
{
    /* 目的：
     * 子属性未实现通知机制，父属性实现了通知机制，但重置父属性能刷新绑定子属性的UI
     */
    /// <summary>
    /// Interaction logic for View.xaml
    /// </summary>
    public partial class View : Window
    {
        public View() {
            InitializeComponent();

            this.DataContext = new ViewModel(new Model() { Name = "陈一发", Id = 1 });
        }

        private void Button_Click(object sender, RoutedEventArgs e) {
            // 重置父属性
            (this.DataContext as ViewModel).Model = new Model() { Name = "许嵩", Id = 2 };
        }
    }
}
