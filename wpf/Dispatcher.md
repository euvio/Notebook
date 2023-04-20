# 前言

继承自DispatcherObject的对象(WPF元素)具有线程关联性(Thread Affinity),具有线程关联性的对象的部分属性和方法(内部含有通过对象的Dispatcher属性实现的VerifyAccess())必须在UI线程中调用，其他属性，方法，以及所有字段，可在任意线程中被调用。
非线程关联性的对象(未继承Dispatcher)的所有属性，方法，字段可在任意线程中被调用。

# UI线程

1. UI线程即主线程Main( )
2. 一个WPF应用程序只开一个UI线程
3. UI线程天然的串行，无需资源同步lock
4. UI线程执行的任务必须耗时极短，否则界面卡顿
5. WPF元素的带有Dispatcher审查的属性和方法只能在UI线程中被调用
6. WPF元素的字段和无Dispatcher审查的属性或方法可在任意线程调用

# WPF元素

何谓WPF元素？

必须是继承自DispatcherObject的对象

在窗体或用户控件中实例化的辅助类，并不继承自DispatcherObject，可以另开子线程访问，即任何线程都能访问，无线程制约。

# Dispatcher

Dispatcher是一个密封类，单例类。

private static Dictionary<Thread,Dispatcher> _dispatchers;

```c#
public static Dispatcher CurrentDispatcher {get;}
```

静态属性 CurrentDispatcher，以当前线程为key，从字典中获取对应得Dispatcher，若字典中无key，则新增key - value。

故，CurrentDispatcher是获取与调用该属性的线程绑定的Dispatcher。

```c#
public Thread Thread{get;}
```

获得与与Dispatcher绑定的Thread。

# DispatcherObject

```c#
namespace System.Windows.Threading
{
    //
    // Summary:
    //     Represents an object that is associated with a System.Windows.Threading.Dispatcher.
    public abstract class DispatcherObject
    {
        //
        // Summary:
        //     Initializes a new instance of the System.Windows.Threading.DispatcherObject class.
        protected DispatcherObject();

        //
        // Summary:
        //     Gets the System.Windows.Threading.Dispatcher this System.Windows.Threading.DispatcherObject
        //     is associated with.
        //
        // Returns:
        //     The dispatcher.
        [EditorBrowsable(EditorBrowsableState.Advanced)]
        public Dispatcher Dispatcher { get; }
        //
        // Summary:
        //     Enforces that the calling thread has access to this System.Windows.Threading.DispatcherObject.
        //
        // Exceptions:
        //   T:System.InvalidOperationException:
        //     the calling thread does not have access to this System.Windows.Threading.DispatcherObject.
        [EditorBrowsable(EditorBrowsableState.Never)]
        public void VerifyAccess();
    }
}
```

## 继承链

Object --> DispatcherObject  --> DependencyObject --> Visual --> UIElement --> FrameworkElement

WPF中，继承自DispatcherObject的对象，在使用该对象的属性或方法时，会调用该对象的VerifyAccess( )方法，检查该对象能不能在当前线程中访问。如果不能，会抛出异常，InvalidOperationException。

## 检查的机制：

WPF应用启动时，会有一个UI线程，<UI线程,Dispatcher>会存储在Dispatcher的Dictionary<Thread,Dispatcher>中。所有的WPF元素都继承了DispatcherObject对象,都有一个Dispatcher属性，这些属性都是【UI线程】(key)对应的那个Dispatcher(value)。WPF在WPF元素的绝大部分属性和方法中，添加VerifyAccess().

```C#
void CheckAccess()
{
    if(Dispatcher != Dictionary[UI线程])
        throw new InvalidOperationException("调用线程无法访问此对象，因为另一个线程拥有该对象");
)
}
```

当访问WPF元素（继承自DispatcherObject）的属性或方法时，会以当前的Thread为key，在Dispatcher的static Dictionary<Thread,Dispatcher>中找到对应的Dispatcher，如果该Dispatcher与WPF元素的Dispatcher属性不同，则抛出异常。这就是DispatcherObject的VerifyAccess( )方法的机制。字段中无法添加逻辑检查，所以WPF元素的字段可以在任意线程调用，如假设Window类中的Button字段，则Window.Button.ToString()可以在任意线程中被调用，因为Button是字段，ToString()虽然是方法，但是方法中没有添加VerifyAccess().
我们可以自己实现一个具有线程关联性的对象。

```C#
public class MyCtrl:DispatcherObject
{
    public MyCtrl(string name)
    {
        _name = name;
    }
    private string _name;
    public string Name
    {
        get
        {
            if(Application.Current.Dispatcher != Dispatcher)
            {
                throw new InvalidOperationException();
            }
            return _name;
        }
    }
}
```

# 处理措施

检查到是非法的，那就拿到UI线程对应的Dispatcher，利用其invoke()方法，将要执行的代码调度到UI线程执行。

# 如何获得Dispatcher

1. WPF元素.Dispatcher
2. Dispatcher.CurrentDispatcher
3. Application.Current.Dispatcher;
4. Application.Current.MainWindow.Dispatcher
* 任何WPF元素（继承自DispatchederObject）的Dispatcher是相同的，完全等价的。所以1和4是等效的。
* 2中Application也继承自Dispatcher
* 3中CurrentDispatcher的值在不同线程中的值不同。在UI线程(Main( ))中所获得的值才是UI线程对应的Dispatcher。开发UI插件时，最好使用1，3，4.

# 练习题

1. 请分析理解下面代码的每一行和代码的运行结果。

   ```C#
   class Program
   {
    [STAThread]
    public static void Main()
    {
        Window win = new Window();
        win.Show();
        Thread.CurrentThread.Name = "bingo";
        Application app = new Application();
        if(app.Dispatcher.Thread.Name == "bingo")
        {
            MessageBox.Show("BINGO");
        }
        app.Run();
    }
   }
   ```

   Dispatcher.Invoke(),阻塞当前线程，直到Invoke中的代码在UI线程中执行完毕。
   Dispatcher.BeginInvoke()异步执行，而且还可以设置进入UI线程的优先级。
   如果我们需要等待UI线程执行的结果，就使用Invoke().

2. 实现数据驱动UI模式的用户控件
   方法一：将用户控件的依赖属性暴露出来，在使用用户控件的时候，创建一个数据包，将数据体与依赖属性绑定，然后开线程更新数据包。
   方法二：将数据包定义成用户控件的public属性，在用户控件的构造方法中完成依赖属性和数据包的绑定。使用用户控件时，程序员可以开线程更新用户控件的public数据包。