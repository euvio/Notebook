# 连接字符串

SqlConnection实例化的初始状态是Closed，且一个连接不能重复打开。

User ID  uid   Password pwd

连接字符串生成器可以避免SQL注入。多次配置同一个KEY，以后面的为准。







# 存储过程和存储函数的区别

MySQL的存储过程和存储函数设计的不如SqlServer，因为SqlServer的存储过程也支持返回值。

存储函数的参数默认且只能是IN，有且仅有一个返回值。

存储过程的参数可以是IN，OUT，INOUT，但是没有返回值。INOUT指参数可以当输入参数在过程内部使用，同时可以对参数赋值作为过程的输出。

存储过程可以返回表结构，存储函数不可以，只能返回字符串，整数，字符。

存储过程的OUT，INOUT，以及内部的SELECT返回表可以作为输出，所以存储函数可以完全被存储过程替代。

```sql
CREATE PROCEDURE myprocedure ( IN employeeId INT, OUT salary DECIMAL )
BEGIN
	SELECT // 输出表
		'Hello AdoNet'; 
		
	SELECT
		employees.salary INTO salary // 不会输出结果集，因为SELECT输出到输出参数中了
		FROM employees
	WHERE
		employees.employee_id = employeeId;
		
	SELECT // 输出表
		last_name,
		phone_number,
		hiredate 
	FROM
		employees;
END
```

```csharp
MySqlConnectionStringBuilder builder = new MySqlConnectionStringBuilder()
{
    Server = "localhost",
    Port = 3306,
    UserID = "root",
    Password = "123456",
    Database = "myemployees",
    CharacterSet = "utf8",
    ConnectionTimeout = 3
};

MySqlConnection conn;
MySqlCommand cmd;

using (conn = new MySqlConnection(builder.ConnectionString))
{
    if (conn.State == System.Data.ConnectionState.Closed)
        conn.Open();

    using (cmd = new MySqlCommand())
    {
        cmd.CommandType = CommandType.StoredProcedure; // 标记成存储过程而不是Sql语句
        cmd.CommandText = "myprocedure"; // 存储过程的名称
        cmd.Connection = conn; // 命令使用的连接

        cmd.Parameters.AddRange(new MySqlParameter[]
        {
            new MySqlParameter
            {
                ParameterName = "@employeeId", // 必须与存储过程的参数名称相同
                MySqlDbType = MySqlDbType.Int32, // 参数类型
                Direction = ParameterDirection.Input, // 输入参数
                Value = 100, // 实参
                IsNullable = false // 不允许实参是NULL
            },

            new MySqlParameter
            {
                ParameterName = "@salary", // 参数名称
                MySqlDbType = MySqlDbType.Decimal, // 参数类型
                Direction = ParameterDirection.Output // 输出参数
            }
        });


        using (MySqlDataReader reader = cmd.ExecuteReader())
        {
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    Console.WriteLine(reader.GetString(0));
                }

                reader.NextResult(); // 读取下一个结果集

                while (reader.Read())
                {
                    Console.WriteLine(reader.GetString("last_name"));
                    Console.WriteLine(reader.GetString("phone_number"));
                    Console.WriteLine(reader.GetString("hiredate"));
                }
            }
        }
    }
}

decimal salary = Convert.ToDecimal(cmd.Parameters["@salary"].Value);
Console.WriteLine(salary);
```

（1）存储过程中的SELECT语句返回表，存储过程执行ExecuteReader或ExecuteScale可以读取表

（2）如果存储过程不返回表，存储过程执行ExecuteNoQuery即可

（3）必须关闭连接后，才能获取输出参数

（4）命令参数占位符名称带@，占位符名称必须与存储过程的参数名称完全相同。

```csharp
CREATE FUNCTION myfunction ( score INT ) RETURNS CHAR BEGIN
	DECLARE
		LEVEL CHAR DEFAULT 'A';
	IF
		score < 60 THEN
			SET LEVEL = 'E';
		ELSEIF score < 70 THEN
		SET LEVEL = 'D';
		ELSEIF score < 80 THEN
		SET LEVEL = 'C';
		ELSEIF score < 90 THEN
		SET LEVEL = 'B';
		ELSE 
			SET LEVEL = 'A';
	END IF;
	RETURN LEVEL;
	END
```

```csharp
MySqlConnection conn;
MySqlCommand cmd;

using (conn = new MySqlConnection(builder.ToString()))
{
    if (conn.State == System.Data.ConnectionState.Closed)
        conn.Open();

    using (cmd = new MySqlCommand())
    {
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.CommandText = "myfunction";
        cmd.Connection = conn;

        cmd.Parameters.AddRange(new MySqlParameter[]
        {
            new MySqlParameter
            {
                ParameterName = "@score",
                MySqlDbType = MySqlDbType.Float,
                Direction = ParameterDirection.Input,
                Value = 85,
                IsNullable = false
            },

            new MySqlParameter
            {
                ParameterName = "@returnValue", // 名称随意
                MySqlDbType = MySqlDbType.String,
                Direction = ParameterDirection.ReturnValue // 返回值用ReturnValue标记
            }
        });

        cmd.ExecuteNonQuery();
    }
}

string level = Convert.ToString(cmd.Parameters["@returnValue"].Value);
Console.WriteLine(level);
```

（1）命令输入参数的占位符名称必须与存储函数的参数名称相同，且参数类型必须是input

（2）命令返回参数的占位符名称随意，但类型必须是ReturnValue

（3）必须关闭连接后，获取返回值
