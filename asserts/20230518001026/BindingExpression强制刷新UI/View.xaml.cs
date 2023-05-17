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

namespace Test.Scenario3
{
    /// <summary>
    /// Interaction logic for ViewModel.xaml
    /// </summary>
    public partial class View : Window
    {
        Model model = new Model() { Name = "陈一发" };
        public View() {
            InitializeComponent();
            this.DataContext = model;
        }

        private void Button_Click(object sender, RoutedEventArgs e) {
            model.Name = "许嵩";
            txt.GetBindingExpression(TextBlock.TextProperty).UpdateTarget();
        }
    }
}
