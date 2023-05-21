# 路径

## 获取程序的运行目录

```csharp
System.Diagnostics.Process.GetCurrentProcess().ProcessName;
System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName;
System.Diagnostics.Process.GetCurrentProcess().MainModule.ModuleName;
```

```tex
MainModule测试
D:\杂项\测试代码工程\MainModule测试\bin\Debug\net6.0\MainModule测试.exe
MainModule测试.exe
```

`System.Diagnostics.Process.GetCurrentProcess().MainModule.FileName;`这种方法获取exe目录是最靠谱的方法，其他方法都存在陷阱。