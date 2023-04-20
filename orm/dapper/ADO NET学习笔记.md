# 连接数据库

```csharp
MySqlConnectionStringBuilder builder = new MySqlConnectionStringBuilder();
builder.Server = "localhost";
builder.Port = 3306;
builder.UserID = "root";
builder.Password = "123456";
builder.Database = "mysql";

//string connectionString = "server=localhost;port=3306;userid=root;password=123456";
using(MySqlConnection conn = new MySqlConnection(builder.ToString()))
{
    if(conn.State != System.Data.ConnectionState.Open)
        conn.Open();
    Console.WriteLine(conn.DataSource);
    Console.WriteLine(conn.ServerVersion);
    Console.WriteLine(conn.Database);
    Console.WriteLine(conn.ConnectionTimeout);
}
```

# ExecuteNonQuery

```c#
using(MySqlConnection conn = new MySqlConnection(builder.ToString()))
{
    if(conn.State != System.Data.ConnectionState.Open)
        conn.Open();
    using(MySqlCommand cmd = new MySqlCommand())
    {
        cmd.Connection = conn;
        cmd.CommandText = @"INSERT INTO student
                            (NO,NAME,gender,birthday,mobile,email,address)
                            VALUES(95123,'hualaishi','男','1995/6/22',
                            '13555555555','hls@iLync.cn','上海市闵行区'); ";
        cmd.CommandType = System.Data.CommandType.Text;

        int lines = cmd.ExecuteNonQuery();
        if(lines < 1)
        {
            throw new Exception();
        }
    }
}
```

# ExecuteScalar

```csharp
using(MySqlConnection conn = new MySqlConnection(builder.ToString()))
{
    if(conn.State != System.Data.ConnectionState.Open)
        conn.Open();
    using(MySqlCommand cmd = new MySqlCommand())
    {
        cmd.Connection = conn;
        cmd.CommandText = "SELECT MAX(birthday) FROM student";
        cmd.CommandType = System.Data.CommandType.Text;

        object dateTime = cmd.ExecuteScalar();
        Console.WriteLine(dateTime);
    }
}
```

# ExecuteReader

```csharp
string connectionString = "server=localhost;port=3306;userid=root;password=123456;database=testdb";
using (MySqlConnection conn = new MySqlConnection(connectionString))
{
    if (conn.State != System.Data.ConnectionState.Open)
        conn.Open();
    using (MySqlCommand cmd = new MySqlCommand())
    {
        cmd.Connection = conn;
        cmd.CommandText = "SELECT * FROM student";
        cmd.CommandType = System.Data.CommandType.Text;

        using (MySqlDataReader reader = cmd.ExecuteReader())
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    Console.WriteLine(reader.GetInt32("no"));
                    Console.WriteLine(reader.GetString("name"));
                    Console.WriteLine(reader.GetString("mobile"));
                }
            }
    }
}
```

```csharp
string connectionString = "server=localhost;port=3306;userid=root;password=123456;database=testdb";
using (MySqlConnection conn = new MySqlConnection(connectionString))
{
    if (conn.State != System.Data.ConnectionState.Open)
        conn.Open();
    using (MySqlCommand cmd = new MySqlCommand())
    {
        cmd.Connection = conn;
        cmd.CommandText = "SELECT * FROM student";
        cmd.CommandType = System.Data.CommandType.Text;
        // 设置关闭MysqlDataReader时，同时自动关闭MysqlConnection
        using (MySqlDataReader reader = cmd.ExecuteReader(CommandBehavior.CloseConnection))
            if (reader.HasRows)
            {
                  DataTable dataTable = new DataTable();
                  dataTable.Load(reader);
            }
    }
}
```

# 参数化查询

```sql
SELECT * FROM login WHERE username = @username AND password = @password
```

最简语法

```csharp
MysqlCommand cmd = new MysqlCommand(sql,connection);
cmd.parameters.AddWithValue("@username",loginID);
cmd.parameters.AddWithValue("@password",loginPwd);
```

复杂但性能最高的语法

```csharp
MysqlCommand cmd = new MysqlCommand(sql,connection);
SqlParameter para1 = new SqlParameter("@username",SqlDbType.VarChar,16);
para1.Value = loginID;
cmd.Parameters.Add(param1);
SqlParameter para2 = new SqlParameter("@password",SqlDbType.VarChar,16);
para2.Value = loginPwd;
cmd.Parameters.Add(param2);
```
