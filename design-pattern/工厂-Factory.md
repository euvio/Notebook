## 开闭原则

**开闭原则等同于面向接口的软件设计。封装改变，既然要封装改变，自然也就要找到改变的代码，然后把改变的代码用接口和具体类来封装**

工厂模式与控制反转的区别：工厂模式是get，控制反转是set，工厂模式在需要对象的时候，去某个地方自己去拿，控制反转，你需要对象的时候，别人直接主动递给你。

Microsoft.DependecyInject.Extension支持两种工作模式：（1）服务定位器 ServiceLocator（2）依赖注入 DependencyInject

前者的工作模式是工厂模式，get模式；后者是控制反转模式，set模式。



# 工厂模式

## 前言

**使用工厂模式的目的**

----

工厂模式可以使客户端"无痛"的切换服务供应商。

举例：

记录日志的方式有（1）记录到数据库（2）记录到磁盘（3）记录到控制台。

客户端前期使用方式（1）记录日志

`Logger.Debug("entry method...")`

`Logger.Info("exit method...")`

`Logger.Error("failed to connect www.youtube.com")`

后期可以在不修改或修改客户端极少的一部分代码，将记录日志的方式更换成方式（2）或方式（3）.

**体现的设计原则**

-------

开闭原则：对扩展开放，对修改关闭。

在客户端使用实例方法前，必须要先`new`一个对象，最终导致客户端散乱的充斥着大量的`DatabaseLogger logger = new DatabaseLogger()`，如果切换日志记录方式为磁盘，在客户端，必须要用`FileLogger logger = new FileLogger()`替换所有的`DatabaseLogger logger = new DatabaseLogger()`，这存在两个问题：（1）量多，更改麻烦。（2）可能要动很多使用了DatabaseLogger已经完成的类，违背了开闭原则。

如果使用工厂模式，则可以只更改客户端的一行代码，轻松更换客户端的日志记录方式。

**<font color=red>工厂模式并没有完全消除改变，只是将经常变化的部分挤压到一个固定的地方，并将变化量降低到最小</font>**

**适用场景**

----

客户端需要一些服务，把这些服务定义成接口，只要供应商实现这些接口，那么就可以服务于客户端；同样，只要服务商实现了这些接口，那么客户端就可以随时更换自己当前的供应商为另外一个满足接口的供应商。

如果客户端经常更换或未来可能更换供应商，则十分适合工厂方法。

工厂模式体现了公司间相互合作的真相：甲方不依赖某家具体的乙方，只要当前乙方出现服务，质量，技术落伍等问题，甲方就可以随时踢掉它换成别的供应商。

工厂模式解决了以下问题：

（1）接口相当于契约，可约束供应商的功能实现并为供应商实现功能的提供参照。

（2）更换供应商时，不需要去所有使用供应商服务的地方更改代码，只需要集中修改一处即可，甚至可以将客户端要使用的供应商信息存储于配置文件，这样开发者只需要维护一份源代码。

（3）扩展供应商列表时，无需修改已经完成的类。

（4）工厂模式解决了客户端直接依赖于具体对象的问题。

## 简单工厂方法

简单工厂方法只是把零散繁多的改变，挤压到集中的一处，这样改变服务起来会更方便。但是扩展服务时，需要修改工厂方法添加if else结构，违背了开闭原则。但如果很少增删服务供应商名单，则简单工厂方法足够适用。

需求：

交通工具库现有货车Truck，摩托车Motorcycle，小轿车Car 3种交通工具。主程序采用其中一种交通工具运行，将来可能更换成其他种类的交通工具。

**初版**

`vehicle library`

```csharp
public class Car
{
    public void Run()
    {
        Console.WriteLine("Car is running...");
    }
}

public class Motorcycle
{
    public void Run()
    {
        Console.WriteLine("Motorcycle is running...");
    }
}

public class Truck
{
    public void Run()
    {
        Console.WriteLine("Truck is running...");
    }
}
```

`vehicle library client`

```csharp
public static void Main(string[] args)
{
    Truck vehicle = new Truck();
    vehicle.Run();
}
```

**缺点**

主程序目前使用的是货车，` Truck vehicle = new Truck()` 会杂乱的充斥着主程序的各个角落。当更换交通工具时，我们需要去使用了Truck的各种类和源文件修改替换，改动很多也很麻烦，同时因为要改动所有使用了交通工具的类，导致也违背了开放封闭原则。

**第一次优化**

使用接口，引用变量不用更改。使用方法代替new，就能解除对具体对象的强依赖。

`vehicle library`

```csharp
public class Car : IVehicle
{
    public void Run()
    {
        Console.WriteLine("Car is running...");
    }
}

public class Motorcycle : IVehicle
{
    public void Run()
    {
        Console.WriteLine("Motorcycle is running...");
    }
}

public class Truck : IVehicle
{
    public void Run()
    {
        Console.WriteLine("Truck is running...");
    }
}


public enum VehicleOption
{
    Car,
    Motorcycle,
    Truck
}

public static class VehicleFactory
{
    public static IVehicle CreateVehicle(VehicleOption option)
    {
        if (option == VehicleOption.Car)
        {
            return new Car();
        }

        if (option == VehicleOption.Motorcycle)
        {
            return new Motorcycle();
        }

        if (option == VehicleOption.Truck)
        {
            return new Truck();
        }

        throw new ArgumentException($"{option} isn't supported", nameof(option));
    }
}

```

`vehicle library client`

```csharp
public static void Main(string[] args)
{
    // 放到一个全局访问点
    VehicleOption vehicleOption = VehicleOption.Car;
    
    // 在应用程序中使用具体服务
    IVehicle vehicle = VehicleFactory.CreateVehicle(vehicleOption);
    vehicle.Run();
}
```

优点：

1. 只需要更改一处。更换交通工具，只需要修改可以被全局访问的VehicleOption即可。

2. 可以直接修改VehicleOption重新编译或条件编译发布新版本，或将VehicleOption存储到配置文件，无需编译，始终只维护一份源代码。

缺点：

扩展服务供应商的时候，需要修改枚举和工厂方法。

适用场景：

可能更换服务供应商，但很少增删服务供应商。

**第二次优化**

## 工厂方法

工厂方法克服了简单工厂方法在扩展服务供应商时，还需要修改工厂的缺点，它为了更完美的实践开放封闭原则。

简单工厂方法的IF ELSE结构，很容易使用策略模式搞定，使用接口实现动态执行不同的方法。

```csharp
public interface IVehicle
{
    void Run();
}
```
```csharp
public interface IVehicleFactory
{
    IVehicle Create();
}
```

```csharp
public class Car : IVehicle
{
    public void Run()
    {
        Console.WriteLine("Car is running...");
    }
}

public class Motorcycle : IVehicle
{
    public void Run()
    {
        Console.WriteLine("Motorcycle is running...");
    }
}

public class Truck : IVehicle
{
    public void Run()
    {
        Console.WriteLine("Truck is running...");
    }
}
```

```csharp
public class CarFactory : IVehicleFactory
{
    public IVehicle Create()
    {
        return new Car();
    }
}

public class MotorcycleFactory : IVehicleFactory
{
    public IVehicle Create()
    {
        return new Motorcycle();
    }
}

public class TruckFactory : IVehicleFactory
{
    public IVehicle Create()
    {
        return new Truck();
    }
}

public class VehicleFactory
{
    public IVehicle Create(IVehicleFactory vehicleFactory)
    {
        return vehicleFactory.Create();
    }
}
```

```csharp
public static void Main(string[] args)
{
    IVehicleFactory vehicleFactory = new CarFactory();

    IVehicle vehicle = VehicleFactory.CreateVehicle(vehicleFactory);
    vehicle.Run();
}
```

## 抽象工厂方法

抽象工厂方法解决了更换一系列服务供应商的问题，只需要在工厂方法的工厂接口中添加多个服务创建者即可。

假设我们现在要盖房子，需要建筑队，还需要原材料的供应商。如果主程序需要能随时更换这两种服务商，只需要每种服务提供各自的工厂方法即可。但是如果这两种服务存在依赖关系怎么办？比如建筑队分为只会用砖头盖房的建筑队，只会用竹子盖房的建筑队。原材料供应商也分为提供竹子和砖头两种。如果主程序从砖头供应商更换成竹子供应商，显然，我们也必须更换建筑队。这就是更换一种服务，也必须同步更换另一种服务的问题。

抽象工厂方法解决了主程序更换相互依赖的服务的场景。如果抽象工厂方法里面只有一种服务，则直接退化成工厂方法。

```csharp
public interface IConnection
{
    bool Connect();
}

public interface ICommand
{
    object ExecuteScalar();
}
```

```csharp
public interface IDbProviderFactory
{
    IConnection CreateConnection();

    ICommand CreateCommand();
}
```

```csharp
public class SqlConnection : IConnection
{
    public bool Connect()
    {
        Console.WriteLine("Sql server connect...");
        return true;
    }
}

public class OracleConnection : IConnection
{
    public bool Connect()
    {
        Console.WriteLine("Oracle connection...");
        return true;
    }
}

public class MySqlConnection : IConnection
{
    public bool Connect()
    {
        Console.WriteLine("Mysql connection...");
        return true;
    }
}

public class SqlCommand : ICommand
{
    public object ExecuteScalar()
    {
        Console.WriteLine("sql server command...");
        return new object();
    }
}

public class OracleCommand : ICommand
{
    public object ExecuteScalar()
    {
        Console.WriteLine("orcale command...");
        return new object();
    }
}

public class MySqlCommand : ICommand
{
    public object ExecuteScalar()
    {
        Console.WriteLine("mysql command...");
        return new object();
    }
}
```

```csharp
public class SqlProviderFactory : IDbProviderFactory
{
    public IConnection CreateConnection()
    {
        return new SqlConnection();
    }

    public ICommand CreateCommand()
    {
        return new SqlCommand();
    }
}

public class OracleProviderFactory : IDbProviderFactory
{
    public IConnection CreateConnection()
    {
        return new OracleConnection();
    }

    public ICommand CreateCommand()
    {
        return new OracleCommand();
    }
}

public class MySqlProviderFactory : IDbProviderFactory
{
    public IConnection CreateConnection()
    {
        return new MySqlConnection();
    }

    public ICommand CreateCommand()
    {
        return new MySqlCommand();
    }
}
```

```csharp
IDbProviderFactory factory = new OracleProviderFactory();

IConnection conn = factory.CreateConnection();
conn.Connect();

ICommand cmd = factory.CreateCommand();
cmd.ExecuteScalar();
```



