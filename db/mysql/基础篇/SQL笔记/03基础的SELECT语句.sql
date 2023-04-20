SQL: Structured Query Language

# 三种注释方法
①
SELECT * FROM employees; # 我是一条注释
②
SELECT * FROM employees; -- 我是一条注释
③
/*
我是注释
我是注释
我是注释
*/


# 大小写
Windows不区分库名，表名，字段名，存储过程和函数名,变量名等的大小写。
但Linux区分大小写，库名，表名，字段名严格区分大小写，关键字，函数名不区分大小写。
SELECT * FROM EmployEEs;
SELECT * FROM employees;
为了SQL代码的兼容性，有以下命名规范：
1. 关键字，存储过程，存储函数大写。
2. 库名，表名，字段名，别名只能由字母数字下划线组成，字母小写，开头不能是数字。
3. 库，表，字段尽量不要和关键字,内置的函数，内置的变量重名。
MySQL匹配字符串时，字符串也不分大小写，这不是Windows和Linux的坑，是沙雕MySQL的锅。
SELECT last_name FROM employees WHERE last_name LIKE '%king%';

# 导入SQL脚本
① 登录MYSQL
② SOURCE C:\Users\Administrator\Desktop\mydb.sql


mysql的三种注释
① # 我是注释
② -- 我是注释
③ /*我是注释*/


# 列别名 alias,SQL执行后返回的表的列名是别名而非原来表达式的字符串形式
# AS可省略，但不建议省略，带AS的可读性比较好
# 起别名的目的：①别名比原名简短 或 ②别名比原名更加让人见名知意
SELECT salary * 12 * (1 + IFNULL(commission_pct,0)) AS anuual_salary,department_id AS did
FROM employees;
#######################################################################################


SELECT DISTINCT department_id FROM employees;



# 去除重复的行
# 单列去重
# 查看有哪些部门
SELECT DISTINCT department_id 
FROM employees;
	
# 多列去重
SELECT DISTINCT department_id,last_name,salary 
FROM employees;

# 错误示例：
SELECT last_name,DISTINCT department_id
FROM employees;
#因为DISTINCT是对最终的结果集进行去重，不可能分别对多列去重，不符合逻辑，如果只是department_id去重了，那该保留哪一个department_id对应的last_name呢？
/*
distinct 可以对单列，多列去重，多列需要所有列都相同才认为是重复，只要有一列不同便不是重复。
distinct 放到所有列名的前面，select后第一位
distinct salary,department_id是对的，但 salary,distinct department_id是错误的,
*/

# NULL
# 任何运算符碰到NULL的结果都是NULL
# 在SQL中，1表示真，0和NULL表示假。如果一个表达式为NULL，作为WHERER后的筛选条件则不会有任何记录输出。
# 错误案例：查询无奖金的员工
SELECT last_name 
FROM employees
WHERE commission_pct = NULL;
# 满足条件返回1，返回1才会被筛选出来。
# 正确案例：查询无奖金的员工
SELECT last_name 
FROM employees
WHERE commission_pct IS NULL;
# 查询员工的月工资和年薪
SELECT employee_id,salary AS "月工资",salary * 12 * (1 + commission_pct) AS "年薪" FROM employees;
# 这种方式错误，你会发现很多人的工资是NULL
SELECT NULL IN (1,2,3); # 结果是NULL
SELECT NULL BETWEEN 1 AND 100; # 结果是NULL
SELECT NULL = NULL  返回NULL
SELECT 1 = NULL  返回NULL
#实际问题的解决方案：引入IFNULL，IS NULL, IS NOT NULL,<=> 
# =只能用于判段一个表达式是否等于指定的非空字面值，
# IS只能用于判段一个表达式是否等于NULL, <=>可用于判段两者。
SELECT employee_id,salary "月工资",salary * (1 + IFNULL(commission_pct,0)) * 12 "年工资"
FROM employees;

SELECT NULL IS NULL,返回1
SELECT 1 IS NULL，返回0

mysql> SELECT NULL <=> NULL;
+---------------+
| NULL <=> NULL |
+---------------+
|             1 |
+---------------+
1 row in set (0.00 sec)

mysql> SELECT 1 <=> NULL;
+------------+
| 1 <=> NULL |
+------------+
|          0 |
+------------+
1 row in set (0.00 sec)

mysql> select 1 = null;
+----------+
| 1 = null |
+----------+
|     NULL |
+----------+
1 row in set (0.00 sec)

# 判断字段是不是NULL，使用IS，而不是=.安全等于<=>，可以兼容NULL和非NULL
SELECT last_name 
FROM employees
WHERE commission_pct <=> NULL;
# 查询奖金不是 0.1 的所有员工
SELECT last_name,commission_pct FROM employees WHERE NOT commission_pct <=> 0.1;
SELECT last_name,commission_pct FROM employees WHERE commission_pct != 0.1 OR commission_pct IS NULL;
# 查询奖金 >0.1 的所有员工
SELECT last_name,commission_pct FROM employees WHERE commission_pct > 0.1;
# 判断题
SELECT * FROM employees; 和 SELECT * FROM employees WHERE last_name LIKE '%%';输出的结果是否一致？
# 答案：不一定。前者输出行数>=后者输出行数。如果last_name字段不为NULL，则相同，否则不一致。

# 结论：对SQL语句的每一个字段都考虑是否为NULL，这样很麻烦，且因为NULL会出现各种bug,
# 所以数据表的字段在定义时几乎都会设置成NOT NULL（非空约束），将一个与字段类型一致的特殊的值配上默认值约束代替NULL表示的未知。


# 着重号
# 在SQL语句中，库名，表名，字段名使用着重号包裹，但是因为着重号和单引号很像，影响SQL的可读性，一般都会省略。
# 但当库名，表名，字段名与MySQL关键字相同时，就一定要使用着重号包裹.
SELECT `last_name`,`employee_id` FROM `atguigudb`.`employees`;
SELECT * FROM `order`; 


# 查询常数
# 常数会填写到每一行。
mysql> SELECT '尚硅谷', last_name FROM employees;
+--------+-------------+
| 尚硅谷 | last_name   |
+--------+-------------+
| 尚硅谷 | K_ing       |
| 尚硅谷 | Kochhar     |
| 尚硅谷 | De Haan     |
| 尚硅谷 | Hunold      |
| 尚硅谷 | Ernst       |
| 尚硅谷 | Austin      |
| 尚硅谷 | Pataballa   |
| 尚硅谷 | Lorentz     |
| 尚硅谷 | Greenberg   |
| 尚硅谷 | Gietz       |
+--------+-------------+
10 rows in set (0.01 sec)

# 应用场景很少，一般当你想为返回的结果集多加一列时使用。比如联合查询时区分来源
SELECT 't1', last_name FROM employees WHERE salary < 6000
UNION ALL
SELECT 't2',last_name FROM employees WHERE department_id < 70;

# 查看表结构
DESCRIBE employees;
























































