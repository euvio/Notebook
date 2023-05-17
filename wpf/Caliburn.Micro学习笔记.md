```xaml
<Grid MinWidth="300" MinHeight="300" Background="LightBlue">
  <RepeatButton Name="IncrementCount" Content="Up" Margin="15" VerticalAlignment="Top" />
  <TextBlock Name="Count" FontSize="150" VerticalAlignment="Center" HorizontalAlignment="Center" />
</Grid>
```

```csharp
public class AppViewModel : PropertyChangedBase
{
  private int _count = 50;
 
  public int Count
  {
    get { return _count; }
    set
    {
      _count = value;
      NotifyOfPropertyChange(() => Count);
      NotifyOfPropertyChange(() => CanIncrementCount);
    }
  }
}
```

PropertyChangedBase ：实现INotifyPropeertyChnaged最简单的抽象基类,相当于MVVM Light中的NotifyObject.

数据绑定：文本框的的Text自动与ViewModel中的同Name的属性绑定。

CM的名称约定：按钮自动寻找与ViewModel中与Name相同的方法或属性，点击按钮时调用。