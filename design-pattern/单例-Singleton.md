```csharp
public class Singleton<T> where T : class, new()
{
    private static volatile T instance;
    private static object locker = new Object();

    public Singleton()
    { }

    public static T Instance
    {
        get
        {
            if (instance == null)
            {
                lock (locker)
                {
                    if (instance == null) instance = new T();
                }
            }
            return instance;
        }
    }
}
```

