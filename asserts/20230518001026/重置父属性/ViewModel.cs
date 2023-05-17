using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Test.Scenario2
{
    internal class ViewModel : INotifyPropertyChanged
    {
        private Model _model;

        public event PropertyChangedEventHandler PropertyChanged;

        public Model Model {
            get { return _model; } set { _model = value; PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(Model))); } 
        }

        public ViewModel(Model model) {
            this.Model = model;
        }
    }
}
