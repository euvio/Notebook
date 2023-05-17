# 对象判等

## 前言

C#的一切类型都派生自Object（除了Interface和Intptr）。

**Object的一些方法的介绍**

```csharp
public static bool ReferenceEquals(Object objA, Object objB);
```

功能：判断两个引用变量是否指向堆中的同一个实例，通常用于验证同一性。

执行逻辑：

1. objA和objB都等于null，返回true

2. objA和objB仅有一个等于null，返回false

3. objA和objB存放的地址相同，返回true，否则返回false

原则上，objA和objB的实参至少有一个是引用类型才有意义，即不要同时是值类型。若两个实参都是值类型，经过装箱，即使objA和objB是同一个值类型变量，ReferenceEquals也会返回false 。

`ReferenceEquals(1,1) ; // false  `                     ` ReferenceEquals(“1”,“1”) ; // true 字符串常量池`

----



```c#
public static bool Equals(Object objA, Object objB);
```

功能：验证两个对象的相等性。

执行逻辑：

1. objA和objB都等于null，返回true
2. objA和objB仅有一个等于null，返回false
3. 执行objA.Equals(objB)判等，Equals是从object继承的方法，默认判断objA和objB的同一性，若被重写，则调用的是重写后的object-Equals.

----



```csharp
public virtual bool Equals(object obj)
```
Object-Equals的默认实现是，如果两者（this和obj）地址相同，即指向托管堆的同一个实例，返回`true`，否则返回`false`。
```c#
public virtual bool Equals(object obj)
{
    if(ReferenceEquals(this,obj)) 
        return true;
    return false;
}
```

这种默认实现存在3个问题，导致其往往满足不了我们的需求，这也是C#将Equals实现成虚方法，让我们在自定义类型时有机会通过重写改造以满足我们的需求。

3个问题如下：

（1）同一性和相等性。

			引用类型：绝大部分情况，如果两个引用指向不同的实例，但这两个实例的所有字段相等，也认为这两个实例相等。
	
			值类型：值类型 <---ValueType <--- Object，微软已经为ValueType重写了Object-Equals，不再是简单的比较引用地址是否指向同一个实例，故，值类型不在此问题。

（2）性能损伤。

			值类型：其一，Object-Equals的参数类型是`object`，如果自定义类型是值类型，发生装箱；其二，值类型都继承自ValueType，微软已经为ValueType重写了Object-Equals，它通过反射比较值类型的每一个字段是否相等。谈及反射，性能色变。

（3）类型不安全：Object-Equals的参数类型是Object，导致任何类型的实例都可以作为参数，这不利于编译期就发现异常。

## 实现引用类型的判等

### 第一步：重写Equals方法

```csharp
public class RefPoint
{
    public int X { get; set; }
    public int Y { get; set; }

    public override bool Equals(object obj)
    {
        // 如果指向同一个实例，必然相等
        if (ReferenceEquals(this, obj))
        {
            return true;
        }

        // 如果obj是NULL或不是RefPoint类型或不是RefPoint的派生类，认为不相等
        var point = obj as RefPoint;
        if (point == null)
        {
            return false;
        }

        // obj必须是RefPoint类型，否则认为不相等
        if (obj.GetType() != GetType())
        {
            return false;
        }
        // 比较此类型定义的新增字段
        if (X == point.X && Y == point.Y)
        {
            return true;
            // return base.Equals(point); // RefPoint直接继承于Object，所以没必要比较从基类继承来的字段
        }

        return false;
    }
}
```

这一步解决了同一性和相等性问题，类型能够以自定义逻辑进行判等。

解释下`base.Equals(point)`

使用base可以调用由于重写被隐藏的基类方法，base.Equals的非空检查，类型检查中的this,GetType()都会基于派生类解释，所以能正常通过，后面的字段判等，其实就是利用基类中现成的方法，去判断派生类中从基类继承来的那部分字段。

### 第二步：重载==和!=

```csharp
public class RefPoint
{
    public int X { get; set; }
    public int Y { get; set; }

    public override bool Equals(object obj)
    {
        // 如果指向同一个实例，必然相等
        if (ReferenceEquals(this, obj))
        {
            return true;
        }

        // 如果obj是NULL或不是RefPoint类型或不是RefPoint的派生类，认为不相等
        var point = obj as RefPoint;
        if (point == null)
        {
            return false;
        }

        // obj必须是RefPoint类型，否则认为不相等
        if (obj.GetType() != GetType())
        {
            return false;
        }
        // 比较此类型定义的新增字段
        if (X == point.X && Y == point.Y)
        {
            return true;
            // return base.Equals(point); // 直接继承Object，所以没必要比较从基类继承来的字段
        }

        return false;
    }
    
    // 第二个参数的类型个人建议是object而非RefPoint，这样才能和Equals完全等价，即可比较任意对象
    public static bool operator ==(RefPoint p1, object p2)
    {
        return Equals(p1, p2);
    }

    // 第二个参数的类型个人建议是object而非RefPoint，这样才能和Equals完全等价，即可比较任意对象
    public static bool operator !=(RefPoint p1, object p2)
    {
        return !Equals(p1, p2);
    }
}
```

Object-Equals(object obj)，==，!= 的语义相同，完全等价，所以应该遵守规范：**若重写了Object-Equals(object obj)，务必也重载运算符 == 和 !=**。

重载==和!=的方法是静态方法，且至少有一个参数的类型是RefPoint，也就是运算符的宿主类型。在编译时，==和!=根据它的操作数类型确定调用哪一个方法。

### 第三步：检查

自反性：x.Equals(x)肯定返回true

对称性：x.Equals(y)和y.Equals(x)返回相同的值

传递性：x.Equals(y)返回true，y.Equals(z)返回true，那么x.Equals(z)必须也返回true

一致性：x和y未变，那么x.Equals(y)的返回值也不能变

### 总结

（1）重写从Object继承的Equals方法

* 如果obj是null,返回false。因为能成功调用Equals的this必然不为null。

* 如果obj和this指向同一个实例，返回true，对于包含大量字段的实例，这一步有助于提升性能。

* 如果obj与this类型不一致，返回false。

* 比较类型定义的新增字段（不包括从基类继承的字段）是否相等，只要有一个字段不相等，就返回false。

* 类型字段=本类型定义的新增字段+基类字段，如果类型不是直接继承Object，则调用基类的Equals来比较继承自基类的字段，如果基类的Equals返回false，就返回false，否则返回true。

（2）重载运算符== 和 !=，内部使用 `public static bool Equals(object object1,object object2)`

（3）检查Equals是否满足4个特性。

## 实现值类型的判等

### 第一步：添加bool Equals(T other)

Object-Equals的形参是object类型，所以当实参是值类型时，存在装箱操作，损伤性能。所有的值类型都派生自ValueType，微软已经为ValueType重写了Equals，内部通过反射对值类型的字段逐一判等，谈及反射，这更损伤性能。换句话说，即使不为自定义的值类型重写Equals，值类型也能通过默认的Equals用合理的逻辑进行判等，但这是兜底的方案，因为值类型存在的价值就是利用它的内存模型来提高程序的性能，但是默认的Equals的装箱和反射又把带来的性能冲击没了，所以，极其强烈建议一定必须让自定义值类型实现`bool Equals(T other)`.

```csharp
public struct StructPoint
{
    public int X { get; set; }
    public int Y { get; set; }

    public bool Equals(StructPoint other)
    {
        /*
         * 不要傻傻的在这里判断other是否等于null或者this是否与other指向同一个实例，
         * 如other == null,ReferenceEquals(this,other),
         * 因为other是值类型，值类型存在于栈中，不指向堆，所以没有null的概念，
         * public static bool ReferenceEquals(object objA, object objB)
         * this和other会装箱，装箱会在堆中开辟两块空间，即使objA和objB是同一个结构体，ReferenceEquals(this,other)也必然
         * 永远返回false，所以完全不应该这么做。
         */
        return X == other.X && Y == other.Y;
        // 永远不要调用base.Equals(other),因为结构体所含有的字段已全在自己内部。同时，base.Equals(other)执行的是ValueType的反射判等，多此一举。
    }
}
```

### 第二步：重写Object.Equals()

虽然自定义值类型即使不重写从Object继承的Equals，下面的代码也能按照期望的判等逻辑执行。

```csharp
object obj = new StructPoint();
StructPoint point = new StructPoint();
point.Equals(obj); // 执行的是 public override bool Equals(object obj)
```

但是前边说过，反射会影响性能，所以，必须重写。

```csharp
public struct StructPoint
{
    
    public int X { get; set; }
    public int Y { get; set; }

    public bool Equals(StructPoint other)
    {
        /*
         * 不要傻傻的在这里判断other是否等于null或者this是否与other指向同一个实例，
         * 如other == null,ReferenceEquals(this,other),
         * 因为other是值类型，值类型存在于栈中，不指向堆，所以没有null的概念，
         * public static bool ReferenceEquals(object objA, object objB)
         * this和other会装箱，装箱会在堆中开辟两块空间，即使objA和objB是同一个结构体，ReferenceEquals(this,other)也必然
         * 永远返回false，所以完全不应该这么做。
         */
        return X == other.X && Y == other.Y;
        // 永远不要调用base.Equals(other),因为结构体所含有的字段已全在自己内部。同时，base.Equals(other)执行的是ValueType的反射判等，多此一举。
    }

    public override bool Equals(object obj)
    {
        return obj is StructPoint other && Equals(other);

        // 也可以这么写，等价。上面是简写模式，算是语法糖
        //if (obj != null && (obj is StructPoint))
        //{
        //    return Equals((StructPoint)obj));
        //}


        /*
         * 千万不要这么写，虽然可以，但不是最佳也没必要.
         * 因为自定义值类型默认已经继承了类ValueType，而C#不支持多继承，所以自定义值类型不能继承另外一个值类型，自定义值类型的继承链仅有2层，自定义值类型<-ValueType<-Object
         * 那么，obj.GetType() == GetType()和obj is StructPoint都是仅在obj的类型严格是StructPoint时，才可能让Equals返回true，但后者的性能比前者的性能约高3倍。
         */
        //if (obj != null && (obj.GetType() == GetType()))
        //{
        //    return Equals((StructPoint)obj);
        //}

        return false;
    }
}
```

### 第三步：继承IEquatable&lt;T&gt;接口

```csharp
public interface IEquatable<T>
{
    bool Equals(T other);
}
```

IEquatable&lt;T&gt;的`bool Equals(T other)`方法和我们第一步添加的Equals方法签名完全一致，那么我们有必要通过接口添加类型安全的Equals方法吗？这和直接添加类型安全的Equals有什么区别吗？我们来分析一下。

下面的代码会调用`public bool Equals(StructPoint other)`，这很好。

```csharp
StructPoint point1 = new StructPoint();
StructPoint point2 = new StructPoint();
point1.Equals(point2); // 调用 public bool Equals(StructPoint other)
```

但是我们继续看下泛型集合的场景，以List&lt;T&gt;为例。

```csharp
List<StructPoint> points = new List<StructPoint>();
StructPoint point = new StructPoint();
points.Contains(point);
points.Remove(point);
points.IndexOf(point);
```

集合查找值类型变量，显然要进行判等，那么判等时调用的是`public bool Equals(StructPoint other)`还是`public override bool Equals(object obj)`呢？我们反编译一下List&lt;T&gt;。

<img src="D:\OneDrive\Notebook\asserts\image-20220522002739595-1684224189977-1.png" alt="image-20220522002739595" style="zoom:67%;" />

![image-20220522003040417](D:\OneDrive\Notebook\asserts\image-20220522003040417-1684224217390-3.png)

查看源码可以得知，List&lt;T&gt;使用比较器EqualityCompare&lt;T&gt;.Default进行元素判等，它通过CreateCompare()创建，CreateCompare()检查T是否继承IEquatable&lt;T&gt;，如果是，则调用`public bool Equals(StructPoint other)`判等，如果不是，则调用`public override bool Equals(object obj)`。如果调用后者，又发生了装箱，所以，自定义值类型必须通过继承IEquatable&lt;T&gt;的方式添加`bool Equals(T other)`方法，不能直接添加`bool Equals(T other)`方法，否则导致微软提供的泛型集合当元素是值类型时，性能由于装箱大幅度降低。

```csharp
public struct StructPoint : IEquatable<StructPoint>
{
    public int X { get; set; }
    public int Y { get; set; }

    public bool Equals(StructPoint other)
    {
        /*
         * 不要傻傻的在这里判断other是否等于null或者this是否与other指向同一个实例，
         * 如other == null,ReferenceEquals(this,other),
         * 因为other是值类型，值类型存在于栈中，不指向堆，所以没有null的概念，
         * public static bool ReferenceEquals(object objA, object objB)
         * this和other会装箱，装箱会在堆中开辟两块空间，即使objA和objB是同一个结构体，ReferenceEquals(this,other)也必然
         * 永远返回false，所以完全不应该这么做。
         */
        return X == other.X && Y == other.Y;
        // 永远不要调用base.Equals(other),因为结构体所含有的字段已全在自己内部。同时，base.Equals(other)执行的是ValueType的反射判等，多此一举。
    }

    public override bool Equals(object obj)
    {
        return obj is StructPoint other && Equals(other);

        // 也可以这么写，等价。上面是简写模式，算是语法糖
        //if (obj != null && (obj is StructPoint))
        //{
        //    return Equals((StructPoint)obj));
        //}


        /*
         * 千万不要这么写，虽然可以，但不是最佳也没必要.
         * 因为自定义值类型默认已经继承了类ValueType，而C#不支持多继承，所以自定义值类型不能继承另外一个值类型，自定义值类型的继承链仅有2层，自定义值类型<-ValueType<-Object
         * 那么，obj.GetType() == GetType()和obj is StructPoint都是仅在obj的类型严格是StructPoint时，才可能让Equals返回true，但后者的性能比前者的性能约高3倍。
         */
        //if (obj != null && (obj.GetType() == GetType()))
        //{
        //    return Equals((StructPoint)obj);
        //}
        return false;
    }
}
```

### 第四步：重载运算符==和!=

```csharp
public struct StructPoint : IEquatable<StructPoint>
{
    public int X { get; set; }
    public int Y { get; set; }

    public bool Equals(StructPoint other)
    {
        /*
         * 不要傻傻的在这里判断other是否等于null或者this是否与other指向同一个实例，
         * 如other == null,ReferenceEquals(this,other),
         * 因为other是值类型，值类型存在于栈中，不指向堆，所以没有null的概念，
         * public static bool ReferenceEquals(object objA, object objB)
         * this和other会装箱，装箱会在堆中开辟两块空间，即使objA和objB是同一个结构体，ReferenceEquals(this,other)也必然
         * 永远返回false，所以完全不应该这么做。
         */
        return X == other.X && Y == other.Y;
        // 永远不要调用base.Equals(other),因为结构体所含有的字段已全在自己内部。同时，base.Equals(other)执行的是ValueType的反射判等，多此一举。
    }

    public override bool Equals(object obj)
    {
        return obj is StructPoint other && Equals(other);

        // 也可以这么写，等价。上面是简写模式，算是语法糖
        //if (obj != null && (obj is StructPoint))
        //{
        //    return Equals((StructPoint)obj));
        //}


        /*
         * 千万不要这么写，虽然可以，但不是最佳也没必要.
         * 因为自定义值类型默认已经继承了类ValueType，而C#不支持多继承，所以自定义值类型不能继承另外一个值类型，自定义值类型的继承链仅有2层，自定义值类型<-ValueType<-Object
         * 那么，obj.GetType() == GetType()和obj is StructPoint都是仅在obj的类型严格是StructPoint时，才可能让Equals返回true，但后者的性能比前者的性能约高3倍。
         */
        //if (obj != null && (obj.GetType() == GetType()))
        //{
        //    return Equals((StructPoint)obj);
        //}
        return false;
    }

    public static bool operator ==(StructPoint point1, StructPoint point2)
    {
        // 值类型不可能是null，所以可以直接调用Equals
        return point1.Equals(point2);
    }

    public static bool operator !=(StructPoint point1, StructPoint point2)
    {
        // 值类型不可能是null，所以可以直接调用Equals
        return !point1.Equals(point2);
    }
}
```

### 第五步：分析泛型类和泛型方法如何判等

```csharp
struct StructPoint : IEquatable<StructPoint>
{
    public int X { get; set; }
    public int Y { get; set; }

    public bool Equals(StructPoint other)
    {
        Console.WriteLine("IEquatable<T> Equals...");
        return true;
    }

    public override bool Equals(object obj)
    {
        Console.WriteLine("Object Equals...");
        return true;
    }
}
```

情况一

```csharp
public class Program
{
    public static bool IsEquals<T>(T t1, T t2) /*where T : IEquatable<T>*/
    {
        return t1.Equals(t2);
    }

    private static void Main(string[] args)
    {
        StructPoint point1 = new StructPoint();
        StructPoint point2 = new StructPoint();
        IsEquals(point1, point2);
    }
}
```

控制台输出：

![image-20220522013248216](D:\OneDrive\Notebook\asserts\image-20220522013248216-1684224234586-5.png)

情况二

```csharp
public class Program
{
    public static bool IsEquals<T>(T t1, T t2) where T : IEquatable<T>
    {
        return t1.Equals(t2);
    }

    private static void Main(string[] args)
    {
        StructPoint point1 = new StructPoint();
        StructPoint point2 = new StructPoint();
        IsEquals(point1, point2);
    }
}
```

控制台输出：

![image-20220522013430511](D:\OneDrive\Notebook\asserts\image-20220522013430511-1684224260739-7.png)

情况一调用的是Object的bool Equals(object obj)，情况二调用的是bool Equals<T>(T other)，这很诡异。我们来分析下原因。

一个合情合理的.NET编译器规则实现：在泛型类和泛型方法中，泛型调用的成员必须是任何可能的泛型类型具有的，不然泛型类和泛型方法没有通用性。这也是C#有泛型约束语法的原因。

泛型类和泛型方法编译时，所调用的成员必须精确确定是哪一个，且可能的泛型参数类型都具有此成员，不存在模糊性。运行时，为泛型参数传入具体类型后，会调用参数类型上的成员。

情况一，由于没有泛型约束，为了适应所有的类型，只能调用从Object继承的Equals。

反编译IL代码

![image-20220522015059257](D:\OneDrive\Notebook\asserts\image-20220522015059257-1684224287283-9.png)

情况二，由于存在泛型约束，强大的C#编译器完美的选择性能最佳的bool Equals<T>(T other)

反编译IL代码

![image-20220522015244974](D:\OneDrive\Notebook\asserts\image-20220522015244974-1684224305784-11.png)

### 总结

***实现值类型的判等的步骤：***

（1）继承IEquatable&lt;T&gt;，实现`bool Equals<T>(T other)`，这能让微软提供的泛型集合不发生装箱

（2）重写从Object继承的`bool Equals(object obj)`，内部调用`bool Equals<T>(T other)`实现

（3）重载运算符`==`和`!=`

## 强调

泛型T，如果确定只可能是值类型，请添加泛型约束`wher T : IEquatable<T>`，调用类型安全的Equals即可。如果未添加约束，务必一定使用`EqualityCompare<T>.Default.Equals(T x,T y)`进行判等。

泛型T，如果确定只可能是引用类型，直接调用Equals即可。

泛型T，如果可能是任何类型，务必一定使用`EqualityCompare<T>.Default.Equals(T x,T y)`进行判等。

## GetHashCode()

![hash](D:\OneDrive\Notebook\asserts\hash-1684224331512-13.png)

**1. 如果对象会作为哈希集合的Key使用，如Dictionary和HashSet，则必须重写其GetHashCode()**

简而言之：引用类型不重写GetHashCode，会导致仍进哈希集合的对象丢失和添加重复的Key，值类型虽然不存在上述的两个问题，但是反射性能极低，所以也必须要重写。

* 引用类型不重写GetHashCode，可能会导致“泥牛入海”，原因如下：

Object-GetHashCode返回的是在对象生存期内保证不变的固定编号，可以理解成UUID，每个Object实例返回的哈希码不同，所以一个未重写GetHashCode的自定义的引用类型的对象实例的HashCode与实例并未产生关联，一旦放入哈希集合，除非存有其地址的引用变量，否则无法通过新的相等的实例找到它。

```csharp
object obj1 = new object();
object obj2 = new object();
object obj3 = new object();
Console.WriteLine(obj1.GetHashCode());
Console.WriteLine(obj2.GetHashCode());
Console.WriteLine(obj3.GetHashCode());
```

![image-20220526150429227](D:\OneDrive\mdimg\image-20220526150429227.png)

```csharp
class Point
{
    public int X { get; set; }
    public int Y { get; set; }
}

Point obj1 = new Point() { X = 1, Y = 2 };
Dictionary<Point,int>  points = new Dictionary<Point,int>();
points.Add(obj1, 1);
Point obj2 = new Point() { X = 1, Y = 2 };
Console.WriteLine(points.ContainsKey(obj2)); // 输出false,因为虽然obj1和obj2相等，但不是同一个实例，默认的GetHashCode生成的HashCode不同，无法命中，查找不到
```

* 引用类型不重写GetHashCode，会导致插入相等的Key，因为每个实例对应一个UUID似的哈希码，插入到哈希集合时，必然不会产生哈希冲突，就轮不到Equals的运作。

```csharp
class Point
{
    public int X { get; set; }
    public int Y { get; set; }
}

Point obj1 = new Point() { X = 1, Y = 2 };
Point obj2 = new Point() { X = 1, Y = 2 };
Point obj3 = new Point() { X = 1, Y = 2 };

Dictionary<Point,int>  points = new Dictionary<Point,int>();
points.Add(obj1, 1); // OK
points.Add(obj2, 2); // OK
points.Add(obj3, 3); // OK
```



* 值类型派生自ValueType，微软为ValueType重写的GetHashCode是通过反射字段计算得出哈希码，不会出现上述引用类型的两个问题，但是由于反射性能低，会损伤为高速查找元素而诞生的哈希集合的性能。

**2. 如果对象会作为哈希集合的Key使用，如Dictionary和HashSet，推荐重写其Equals**

简而言之：引用类型不重写Equals，会导致仍进哈希集合的元素丢失和添加重复的Key；值类型反射性能低。

往哈希集合添加元素的过程：计算对象的HashCode，寻找哈希桶，如桶中无元素，放入，如有元素，调用Equals判等，不相等则放入桶中，相等则抛出异常。

引用类型默认Equals只有引用指向同一个实例才认为相等，所以会导致相等的对象多次正常的放入哈希集合，这大概率不是我们所期望的。值类型虽然不存在这种问题，但是其默认的Equals使用反射判等所有字段，也会损伤为了高速查找元素的哈希集合的性能。

其实对于`List<T>`,`Array<T>`等其他集合也是同样的道理。

`引用类型两次添加都成功`

```csharp
class Point
{
    public int X { get; set; }
    public int Y { get; set; }
    
    public override int GetHashCode()
	{
    	return X.GetHashCode() ^ Y.GetHashCode();
	}
}

Point point1 = new Point { X = 1, Y = 2 };
Point point2 = new Point { X = 1, Y = 2 };
HashSet<Point> points = new HashSet<Point>();
Console.WriteLine(points.Add(point1)); // True
Console.WriteLine(points.Add(point2)); // True
```

`值类型第二次添加失败`

```csharp
struct StructPoint
{
    public int X { get; set; }
    public int Y { get; set; }
}

Point point1 = new Point { X = 1, Y = 2 };
Point point2 = new Point { X = 1, Y = 2 };
HashSet<Point> points = new HashSet<Point>();
Console.WriteLine(points.Add(point1)); // True
Console.WriteLine(points.Add(point2)); // False
```

**3. 在对象的生命周期，若对象的任何字段都未变化，则算法的HashCode也一定不能发生变化。**

不遵守此规则，对象一旦放入哈希集合中，便无法再寻找到它。

```csharp
class Point
{
    public int X { get; set; }
    public int Y { get; set; }

    public override int GetHashCode()
    {
        return X + Y + DateTime.Now.Second;
    }
}

Point K1 = new Point() { X = 2, Y = 3 };
Dictionary<Point,Int32> points = new Dictionary<Point,Int32>();
points.Add(K1,1);
Thread.Sleep(2000);
Console.WriteLine(points.ContainsKey(K1)); // False，不存在此key
```

**4. Equals判断两个对象相等，则两个对象的哈希算法返回的HashCode也必须相等.**

道理同3，虽然不是同一个实例，但只要相等，理论上应该需要满足使用其中一个实例去判断哈希集合中是否存在另外一个实例。

**5. 允许Equals不相等的两个对象具有相同的HashCode**

哈希冲突能解决这种问题，但要尽量保证哈希码的随机分布，减少哈希碰撞。

**6. GetHashCode必须随机分布，减少哈希冲突，这是哈希集合能按照期望运行高性能查找的保证**

往哈希集合添加元素的过程是先根据对象的GetHashCode返回的哈希码计算出存放的哈希桶(bucket)，如果无法满足哈希码随机分布，查找性能会退化成链表，时间复杂度从O(1)退化成O(n).

**7. 算法运算要足够快，值类型如果要作为哈希集合的Key，则必须重写其GetHashCode，因为ValueType使用反射生成的HashCode.**

**8. 必须至少使用一个实例字段生成hashcode，禁止使用静态字段生成hashcode。对象肯定被一个唯一的哈希码标识才能被准确索引。**

**9. 最好只利用在对象构造时初始化，在对象生存期内永不改变的实例字段生成hashcode，但不强求，这是为了避免误修改对象后无法再次在哈希集合中寻找到此对象。**

![image-20220527231631876](D:\OneDrive\Notebook\asserts\image-20220527231631876-1684224356884-15.png)

**10. 需要修改哈希表中的Key对象时，正确的做法是移除原来的键值对，修改key对象，再将新的键值对添加回哈希表。否则导致元素丢失和永远不会被使用到的元素占用浪费哈希集合空间**

**11. 永远不要持久化对象的GethashCode的返回值，因为基元类型生成哈希码的算法可能随着CLR版本会变化，导致持久化的哈希码失效。另外，.NET只承诺对象的GetHashCode在一个应用程序的生命周期内,任何相等的对象调用GetHashCode()生成的HashCode都相同，维持掉电即失的哈希数据结构正常运行而已，但应用程序被重启后，再次生成的哈希码也未必和重启前相同**。

重新启动后，str1和str2生成的哈希码发生了变化。

```csharp
public static void Main()
{
    string str1 = "NB0903100006";
    string str2 = "NB0904140001";
    Console.WriteLine(str1.GetHashCode());
    Console.WriteLine(str2.GetHashCode());
    Console.WriteLine(str1.GetHashCode());
    Console.WriteLine(str2.GetHashCode());
}
```

 ![17点13分 2022年4月10日-16537320350151](D:\OneDrive\Notebook\asserts\17点13分 2022年4月10日-16537320350151-1684224381030-17.gif)

**12. 不要跨应用程序域或进程发送哈希代码。 在某些情况下，哈希代码可以按进程或按应用程序域计算，在不同时间或不同应用域(APPDomains)中使用GetHashCode时，没有办法保证值不变，即GetHashCode不具有分布性**

**13. 如果需要加密对象，请不要加密GetHashCode返回的哈希码，而是以对象的字段为参数，使用明确的加密哈希函数如System.Security.Cryptography.HashAlgorithm类下的SHA256，MD5.**

**14. 如果用作哈希表中Key的对象未重写GetHashCode或Equals，则可以通过`EqualityComparer<T>`实现GetHashCode的判等器作为哈希集合的构造方法的参数去实例化，那么哈希集合会采用判等器的GetHashCode和Equals运行。**

```csharp
public HashSet(IEqualityComparer<T> comparer);
public Dictionary(IEqualityComparer<TKey> comparer);
```

**15. 哈希码相同不代表对象相等，严格的讲，相等性和HashCode无关，只是当作key时顺便利用一下它能加速判等而已。**

**16. 其实微软如果将GetHashCode()从Object剥离，放在一个姑且称作`IHashCode`的接口里面，如果在哈希集合中使用了对象，就自动检查对象是否继承了`IHashCode`，未继承，便抛出异常，这样也未尝不能说是一种良好实现.**

**17. 个人推荐：实现自定义类型时都去重写GetHashCode和Equals，如果感觉暂时没必要实现，建议抛出异常，后续发现此类型需要参与判等和用于哈希运算，通过异常提醒开发者未重写，避免程序“带病”运行。**

```c#
class Point
{
    public override int GetHashCode()
    {
        throw new InvalidOperationException("未重写GetHashCode()");
    }

    public override bool Equals(object obj)
    {
        throw new InvalidOperationException("未重写Equals(object obj)");
    }
}
```

**18.  常见的GetHashCode()实现方式**

```csharp
public override int GetHashCode()
{
    unchecked // Overflow is fine, just wrap
    {
        /*
         * 自定义引用类型，务必让base.GetHashCode()参与重写其GetHashCode(),
         * 除非它的base是object或base.GetHashCode()从未被重写一直保持是
         * 从object的继承而来的默认实现（RuntimeHelper.GetHashCode(this)）.
         * 这样做的目的是让自定义类型的所有字段都参与生成哈希码，增强随机分布性。
         * ************************************************************
         * 自定义值类型，由于只可能有且仅有一个基类ValueType,所以没必要(ValueType无字段)
         * 也万万不可(反射+造成同一个字段多次参与运算)让base.GetHashCode()参与重写其GetHashCode()。
         */

        return -2849573 ^ Age.GetHashCode() ^ SchoolNo.GetHashCode() ^ StringComparer.Ordinal.GetHashCode(Name)
               ^ StringComparer.OrdinalIgnoreCase.GetHashCode(Email); // ^ base.GethashCode() 
        // Email不区分大小写，所以使用忽略大小写的EqualityCompare<string>
    }
}
```

## 判等比较器

微软为.NET实现的泛型和非泛型集合中涉及查找元素的API，其内部使用的是元素类型自带的Equals(优先调用类型安全的，无则才会调用Object-Equals)。在开发应用时，我们不可避免的要使用别人的dll，我们无权、无法修改其dll，但如果别人的类没有重写Equals怎么办？或者别人重写的Equals效果并不是我们使用时想要的怎么办？

.NET自带的集合容器涉及查找元素的API，支持自定义判等器的API，让我们可以临时自定义判等器，替代类的成员方法Equals和GetHashCode.如

```csharp
public Dictionary(IEqualityComparer<TKey> comparer)
```

```csharp
public bool Contains(string target,IEqualityComparer<string> compare)
```

我们看下接口`IEqualityComparer<in T>`和 `IEqualityComparer`
```csharp
public interface IEqualityComparer
{
    new bool Equals(object x, object y);
    int GetHashCode(object obj);
}
```

```csharp
public interface IEqualityComparer<in T>
{
    bool Equals(T x, T y);
    int GetHashCode(T obj);
}
```
`IEqualityComparer`提供类型不安全的判等方法，相当于类型内置的从Object继承的Equals。`IEqualityComparer<T>`提供类型安全的Equals。我们可以继承这两个接口实现比较器，但强烈推荐继承` EqualityComparer<T>`实现比较器.

```csharp
public abstract class EqualityComparer<T> : IEqualityComparer, IEqualityComparer<T>
{
    public static EqualityComparer<T> Default;

    public abstract bool Equals(T x, T y);

    public abstract int GetHashCode(T obj);

    int IEqualityComparer.GetHashCode(object obj);

    bool IEqualityComparer.Equals(object x, object y);
    
    internal virtual int IndexOf(T[] array, T value, int startIndex, int count);
    
    internal virtual int LastIndexOf(T[] array, T value, int startIndex, int count)
}
```

因为它已经继承了上述的两个接口，且比直接继承接口有如下三个优点：

（1）我们只需要实现类型安全的`abstract bool Equals(T x, T y)` 和`abstract int GetHashCode(T obj)`即可，类型不安全的`int IEqualityComparer.GetHashCode(object obj)`和`bool IEqualityComparer.Equals(object x, object y)`已经通过调用类型安全的Equals和GetHashCode实现了。

（2）Default属性是默认的比较器，内部优先调用类型的类型安全的`Equals<T>()`，如果未提供，则调用类型不安全的Object-Equals。`CustomModelEqualityComparer<Model>.Default.Equals()`，非常适合值类型判等。

（3）提供了在数组中查找元素的方法，我们用一个public方法封装一下就可以直接使用了。

举例说明：

```csharp
public class Entity
{
    public int ID { get; set; }
    public string Name { get; set; }
}


IDictionary<Entity, string> dic = new Dictionary<Entity, string>();
dic.Add(new Entity { ID = 1, Name = "小明" }, "C++");
dic.Add(new Entity { ID = 2, Name = "小王" }, "VB");

// 下面的代码并不能查找到findkey，因为HashCode虽然命中，但是Equals无法命中
Entity findkey = new Entity
{
	ID = 2,
	Name = "小王"
};

if (dic.ContainsKey(findkey))
{
	Console.WriteLine(dic[findkey]);
}
```

实例化字典时以自定义判等器当作参数，便能找到findkey。哈希数据结构会使用参数判等器的HashCode和Equals.

```csharp
public sealed class CustomEqComparer : EqualityComparer<Entity>
{
    public override bool Equals(Entity x, Entity y)
    {
        if (x.ID == y.ID && x.Name == y.Name)
            return true;
        return false;
    }

    public override int GetHashCode(Entity obj)
    {
        return obj.ID.GetHashCode();
    }
}

CustomEqComparer comp = new CustomEqComparer();
IDictionary<Entity, string> dic = new Dictionary<Entity, string>(comp);
```

# 迭代器

## IEnumerable\<out T>

> 如果对象想作为数据源提供一系列元素供外界使用，那么该对象可以实现迭代器，调用者无需知晓数据源对象内部如何迭代，只需要通过foreach触发数据源对象吐出元素然后处理。

继承`IEnumerator<out T>`的对象实现迭代规则，数据源对象自身继承`IEnumerable<out T>`返回迭代规则。

**迭代偶数数据源对象**

```csharp
public class EvenNumbersGenerator : IEnumerable<int>
{
    private readonly int[] numbers;

    public EvenNumbersGenerator()
    {
        numbers = new int[] { 2, 4, 8, 6, 3, 5 };
    }

    public IEnumerator<int> GetEnumerator()
    {
        return new EvenNumbersGeneratorEnumerator(this);
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public class EvenNumbersGeneratorEnumerator : IEnumerator<int>
    {
        private readonly int[] numbers;
        private int index = -1;

        public EvenNumbersGeneratorEnumerator(EvenNumbersGenerator generator)
        {
            numbers = generator.numbers;
        }

        public int Current
        {
            get
            {
                return numbers[index];
            }
        }

        object IEnumerator.Current => Current;

        public void Dispose()
        {
            return;
        }

        public bool MoveNext()
        {
            if (index++ >= numbers.Length)
            {
                return false;
            }

            return Current % 2 == 0;
        }

        public void Reset()
        {
            index = -1;
        }
    }
}
```

**调用方法**

```csharp
EvenNumbersGenerator ints = new EvenNumbersGenerator();
/* 调用方法一 */
IEnumerator<int> enumerator = ints.GetEnumerator();
while (enumerator.MoveNext())
{
    Console.WriteLine(enumerator.Current);
}
/* 调用方法二 语法糖 */
//foreach (var item in ints)
//{
//    Console.WriteLine(item);
//}
```

## yield return

```csharp
IEnumerator<int> ProduceEvenNumbers()
{
    var numbers = new int[] { 2, 4, 8, 6, 3, 5 };
    foreach (var number in numbers)
    {
        if(number % 2 == 0)
        {
            yield return number;
        }
        else
        {
            yield break;
        }
    }
}
```

当一个方法返回IEnumerator\<out T> 时，理论上需要返回一个继承了IEnumerator\<out T>的对象，但是C#提供了yield语法糖，yield return 表示提供序列的下一个值，相当于Current；yield break 表示迭代结束，相当于MoveNext() == false。

**yield关键字其实是一种语法糖，最终还是通过实现IEnumberable<T>、IEnumberable、IEnumberator<T>和IEnumberator接口实现的迭代功能**

## 迭代器的优点

迭代器是对象向外界提供一系列元素的手段，返回IEnumerable\<T>相比于返回List\<T>或Array\<T>有哪些优点呢？

1. 调用者无需知晓数据源对象内部复杂的迭代吐出机制，只需要通过foreach拿到吐出的元素即可
2. 数据源对象提供的是迭代方法，调用者执行迭代时才触发数据源对象`吐出`元素，而不是数据源对象把所有元素全部迭代到内存后供调用者使用，这样可以避免大内存分配，还可以让调用者根据某些条件提前结束迭代。
3. 如果数据源对象`吐出`一个元素是耗时过程，那么调用者在迭代过程中可以提前处理先`吐出`的元素，而不是长时间等待数据源`吐出`所有元素再进行处理。

# 值元组 ValueTuple

## 什么是ValueTuple?

​		可以认为ValueTuple是一种可以存放多个不同类型的元素的集合类型。

##  创建ValueTuple

```csharp
ValueTuple<int, double> vt = new ValueTuple<int, double>(1, 3.1415);

ValueTuple<int, double> vt = ValueTuple.Create<int, double>(1, 3.1415);

var vt = (sum: 1, pai : 3.1415);

(int sum, double pai) vt = (1, 3.14);
```

显然第3和4种方式最好，不仅语法简洁，而且可以利用有意义的名称访问元组内的成员。

## 访问值元组成员

1. ItemX

   ```csharp
   ValueTuple<int, double> vt = new ValueTuple<int, double>(1, 3.1415);
   vt.Item1 = 2;
   vt.Item2 = 3.14;
   ```

2. 有意义的名称

   ```csharp
   var vt = (sum: 1, pai : 3.1415);
   vt.sum = 2;
   vt.pai = 3.14;
   
   (int sum, double pai) vt = (1, 3.14);
   vt.sum = 83;
   vt.pai = 3.1415926;
   ```

   显然方式2采用有意义的名称，程序的可读性更好，建议永远使用方式2使用值元组。

## 最多8个成员的限制

​        ValueTuple最多支持8个泛型，超出后，第8个成员可以定义成ValueTuple，来定义更多数量的元素。

```csharp
var vt = new ValueTuple<int, int, int, int, int, int, int, ValueTuple<int, int, int>>(1, 2, 3, 4, 5, 6, 7, (8, 9, 10));
Console.WriteLine(vt.Item10);    // 访问第10个元素 -- 10
Console.WriteLine(vt.Rest.Item3); // 访问第10个元素 -- 10
```

## 常见的应用场景

1. 方法有多个返回值

==现有实现方法和缺点==

```csharp
// 方法1：out
public void DoSomething1(out int id, out string message) { id = 10; message = "Hi"; }
// 方法2：额外类
public WorkResult DoSomething2() => new WorkResult { Code = 10, Message = "Hi" };
// 方法3：dynamic
public dynamic DoSomething3() => new { Code = 10, Message = "Hi" };
// 方法4：object
public object DoSomething4() => new { Code = 10, Message = "Hi" };
```

4种方法的缺点

方法1：out不支持async/await，await异步方法后，并不会将输出以返回值形式返回。

方法2：定义额外的类，让项目充满了许多无关紧要的小类，看起来冗杂。

方法3：需要以字符串形式访问返回值的各个成员，没有智能提示，易出错。

方法4：需要通过反射访问返回值的各个成员，更加复杂。

==利用值元组返回多个值==

```csharp
 static (string, int, double) GetStudentInfo(int id)
 {
     return ("Jack", 20, 182);
 }
 
 var studentInfo = GetStudentInfo(1);
 // 通过ItemX访问成员
 Console.WriteLine($"姓名：{studentInfo.Item1}");
 Console.WriteLine($"年龄：{studentInfo.Item2}");
 Console.WriteLine($"身高：{studentInfo.Item3}");
```

输出

```te
姓名：Jack
年龄：20
身高：182
```

上述缺点，需要用Item1，Item2，Item3来访问值元组的成员，可以利用值元组的别名，通过有意义的标识符访问其成员，只需要定义值元组时指定别名即可。

```csharp
static (string name, int age, double height) GetStudentInfo(int id)
{
    return ("Jack", 20, 182);
}

var studentInfo = GetStudentInfo(1);
// 通过别名访问成员
Console.WriteLine($"姓名：{studentInfo.name}");
Console.WriteLine($"年龄：{studentInfo.age}");
Console.WriteLine($"身高：{studentInfo.height}");
```

2. 泛型集合

   放在泛型集合中的元素必须是同一种类型，但是没若干个不同类型甚至同一类型成员成员代表同一个含义。

   可以拿一次性获取Ini文件的多个Key的值为例。

   ```csharp
   string[] GetValue(params (string section, string key)[] keys) => null;
   
   GetValue(("plc", "ip"),("plc","port"));
   ```

## 拆包和_

```csharp
(string name, int age, double height)  = GetStudentInfo(1);

// 丢弃不需要的返回值, 可以使用 _ 拆包，表示不会使用的返回值
(_, int age, _) = GetStudentInfo(1);
```

## 迷雾重重

难点：区分( )语法表示 ①拆包②批量赋值还是③创建值元组。

```csharp
static (string, int, double) GetStudentInfo(int id) =>("",0,1.1);

public static void Main(string[] args)
{
    (string name, int age, double height) = GetStudentInfo(1);
}
```

以上代码会被编译成：

```csharp
var info = GetStudentInfo(1);
string name = info.Item1;
int age = info.Item2;
double height = info.Item3;
```

-----

```csharp
(string name, int age, double height) info = GetStudentInfo(1);
```

以上代码会被编译成：

```csharp
ValueTuple<string,int,double> info = GetStudentInfo(0);
info.Item1;info.Item2;info.Item3;
```

----

```csharp
public class Point
{
    public int X { get; set; }
    public int Y { get; set; }

    public Point(int x, int y)
    {
        (X, Y) = (x, y);
    }
}
```

以上代码会被编译成：

```csharp
public class Point
{
    public int X { get; set; }
    public int Y { get; set; }

    public Point(int x, int y)
    {
        this.X = x;
        this.Y = y;
    }
}
```

-----

```csharp
public class Point
{
    public int X { get; set; }
    public int Y { get; set; }

    public Point(int x, int y)
    {
        (X, Y) A = (x, y);  // 编译失败，语法错误
    }
}
```

-----

总结

```csharp
(int age,string name) 要么是声明值元组，要么是拆包
int age; string name; (age,name) 要么是分配元组内存，要么是拆包，要么是批量赋值
(1,"Jack") 要么是分配元组内存，要么是批量赋值
(age:1,name:"Jack") 肯定是分配元组内存
```





## 值元组和序列化

能够给元素命名，方便使用和记忆，这里需要注意虽然命名了，但是实际上value tuple没有定义这样名字的属性或者字段，真正的名字仍然是ItemX，所有的元素名字都只是设计和编译时用的，不是运行时用的（因此注意对该类型的序列化和反序列化操作）；

函数返回的ValueTuple 各元素的名字记录在TupleElementNamesAttribute里，所以运行时也不是没有办法获取到的。

# 原始字符串

## 转义字符

字符分为可显示字符(如A,B,C,1,2,3)和控制字符(回车符CR,换行符LF,空NUL,EOT传输结束,退格BS)。在编辑代码时，可显示字符可使用键盘直接输入，但是控制字符无法输入和表示，所以IT行业规定，利用 `\` + `可视化字符`表示一个控制字符，如回车符 `\r`，换行符 `\n`。由于 \被用来转义，所以`\`用`\\`表示。

==综上，控制字符用 `\` + `可视化字符`表示，可视化字符直接表示，但`\`这个可视化字符由于被用来转义，所以要特殊对待它，用`\\`表示`\`。==

由于在代码中，字符串类型的字面值需要用`""`包裹，来让编译器知道此字面值是字符串类型，所以除了特殊对待`控制字符`，`\` ，还要特殊对待` "`。如果字符串中包含`"`，用`\"`表示`"`，这样可以让编译器能够区分出` "`是作为字符串的内容还是结束标志。

* 如何在C#中书写下面的字符串？

`12/3\ab"cCRLF`  【共计11个字符】

```csharp
string str = "12/3\\ab\"c\r\n";
```

* C#语法可以用@禁止编译器把`\`当转义，如果字符串中含有很多`\`，这样就很省事，常用于路径字符串。

`‪C:\Program Files\Adobe\Acrobat DC\Resource\Font\CourierStd.otf`

不带@

```csharp
string str = "‪C:\\Program Files\\Adobe\Acrobat DC\\Resource\\Font\\CourierStd.otf";
```
带@
```csharp
string str = @"‪C:\Program Files\Adobe\Acrobat DC\Resource\Font\CourierStd.otf";
```

==由于带@时，禁止\转义，所以当我们要输入的字符串含有控制字符时，无法用@这个语法糖。另外，如果字符串含有`"`,不再用`\"`表示，而是用`""`==.

```csharp
string str = @"12/3\ab""c";
```

* 原始字符串
  1. 用"""包裹的字符串，肉眼看到什么，就被解析成什么。
  2. 原始字符串字面量以至少三个双引号 (""") 字符开头， 它以相同数量的双引号字符结尾。
  3. 左引号之后、右引号之前的换行符不包括在最终内容中。
  4. 右双引号左侧的任何空格都将从字符串字面量中删除。
  5. 原始字符串和@一样，禁止转义，所以无法表示带有控制字符的字符串，但是原始字符串排版比@好，也不用特殊处理`"`.
  6. 特别适合表示JSON字符串

```csharp
string longMessage = """
            This is a long message.
            It has several lines.
                Some are indented
                        more than others.
            Some should start at the first column.
            Some have "quoted text" in them.
            """;
```

输出

```tex
This is a long message.
It has several lines.
    Some are indented
            more than others.
Some should start at the first column.
Some have "quoted text" in them.
```
## 如何处理内插变量

`{"level":"info"}`

```csharp
string level = "error";

string msg = $"{{\"level\":\"{level}\"}}";

msg = $@"{{""level"":""{level}""}}";

msg = $$"""
    {"level":"{{level}}"}
    """;
```

==字符串未加$时，`{` 和 `}`是简单的可显示字符。加了$后，`{` 和 `}`用于包裹变量，有了其他专门用途，所以想要表示`{`自身时，用`{{`，同理，`}`用`}}`表示。==



==原始字符串至少用2个 `$` 表示有多少个连续的大括号开始和结束内插。==

```csharp
int x = 100;
string str =$$"""
{{{x}}}
""";
// 输出 {100}
    
str = $$$"""
{{{x}}}
    """;
// 输出 100
```

# 类型转换

