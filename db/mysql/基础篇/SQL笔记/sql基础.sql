SQL语句必须格式化后（具有必要的换行和缩进后），才能复制到高级语言的源代码文件使用。

自定义标识符只允许使用字母，数字，下划线，开头不能数字和下划线，结尾不能是下划线
反例：`2_second `       `_name`         ` name_    ` 
   
起别名时，不要省略AS，增强SQL的可读性

数据库名，表名，字段名，别名只能小写；关键字，存储过程名，存储函数名必须大写

生产环境中的SQL语句不得出现SELECT * ,即使要输出表的全部字段，也需逐一列出所有字段名，这是为了提高高级语言
的源代码文件的可维护性。
示例：`SELECT f1,f2,f3 FROM table;`

可视化界面的连接名起名为 username-ip-port-version

大小写规范：UNIX区分大小写。Windows不区分大小写。 


命令行导入sql文件的方式
mysql> SOURCE d:\mysqldb.sql



USE atguigudb;
SELECT 1+1, 2*3,'hello sql';


	
MySQL支持的运算符
位运算符
& |  ^  ~  >>   <<
与 或 异或 逐位取反  左移  右移
OR ||  AND && NOT ! XOR
逻辑运算符
OR ||  AND && NOT ! XOR
注意异或运算，它是很强大的功能，应该时刻放在心中
SELECT last_name,salary,department_id
FROM employees
WHERE department_id = 50 XOR salary > 6000;
#练习：查询第2个字符是_且第3个字符是'a'的员工信息
#需要使用转义字符: \ 
SELECT last_name
FROM employees
WHERE last_name LIKE '_\_a%';

LIKE 模糊查询
% 表示0或多个字符
_ 表示一个字符
如果字符串中包含% 和 _ 可以使用转义字符 \











