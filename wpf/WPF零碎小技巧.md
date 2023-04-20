# Properties

public System.Collections.IDictionary Properties { get; }

Gets a collection of application-scope properties.

```C#
namespace CSharp
{
    public partial class App : Application
    {
        void App_Startup(object sender, StartupEventArgs e)
        {
            // Parse command line arguments for "/SafeMode"
            this.Properties["SafeMode"] = false;
            for (int i = 0; i != e.Args.Length; ++i)
            {
                if (e.Args[i].ToLower() == "/safemode")
                {
                    this.Properties["SafeMode"] = true;
                    break;
                }
            }
        }
    }
}
```

[Application](https://docs.microsoft.com/en-us/dotnet/api/system.windows.application?view=netframework-4.8) exposes a dictionary via [Properties](https://docs.microsoft.com/en-us/dotnet/api/system.windows.application.properties?view=netframework-4.8) which you can use to store application-      scope properties. This allows you to share state amongst all code in an [AppDomain](https://docs.microsoft.com/en-us/dotnet/api/system.appdomain?view=netframework-4.8) in a thread-safe fashion, without the need to write your own state code.

Properties stored in [Properties](https://docs.microsoft.com/en-us/dotnet/api/system.windows.application.properties?view=netframework-4.8) must be converted to the appropriate type returned.

The [Properties](https://docs.microsoft.com/en-us/dotnet/api/system.windows.application.properties?view=netframework-4.8) property is thread safe and is available from any thread.

![S形曲线.png](https://i.loli.net/2020/07/13/eU2WXkrLNJInfET.png)

```
![S形曲线.png](https://i.loli.net/2020/07/13/eU2WXkrLNJInfET.png)
```

```
![S形曲线.png](https://i.loli.net/2020/07/13/eU2WXkrLNJInfET.png)
```

## 很快就会受苦的还是

## 交换机回复

#### 但是v空间hi hi和

### 很快就会的文化

