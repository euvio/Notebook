# UNION 和 UNION ALL : 合并两个结果集(把多张表的数据合并到一张表，前提是多张表的字段数量，类型的顺序要相同，不要求字段名称相同)

UNION 会去重
UNION ALL 不去重
什么算是重复？所有列的值都相同才算重复。
-- 2条记录
SELECT 'A',1
UNION ALL
SELECT 'A',1;
-- 1条记录
SELECT 'A',1
UNION
SELECT 'A',1;
-- 2条记录
SELECT 'A',1
UNION
SELECT 'B',1;

# ①由于UNION ALL无需去重，效率会比UNION高点，在两者都可以使用的场景下优先使用UNION ALL.
# ②UNION和UNION ALL一般用于合并来自不同数据表的记录。同一张表可以使用OR代替UNION
# ③分库分表方案中需要跨表查询时使用
# ④MySQL未实现全外连接，通过UNION ALL合并左外和右外连接的结果，可以产生与满外连接相同的效果。


# 为什么要设计多表
优点
① 避免存储冗余。单表每一行记录都要完全存储同一逻辑的多个字段块信息；多表存储个块信息索引即可。
② 容易修改字段。修改一行主表即可，单表要逐行判断修改
③ 加载不感兴趣的字段增大了磁盘IO压力
④ 面向对象思想
缺点：
多表连接相当于N层for循环，会大大降低查询的效率
【阿里巴巴规范】我们要控制连接表的数量。多表连接就相当于嵌套 FOR 循环一样，非常消耗资源，会让SQL查询性能下降得很严重，因此不要连接不必要的表。在许多DBMS中，也都会有最大连接表的限制。
超过三个表禁止 join。需要 JOIN 的字段，数据类型保持绝对一致；多表关联查询时，保证被关联的字段需要有索引。

# ER模型 Entity-Relationship Model
# 新建一张表的过程相当于定义一个类。一张表插入一条记录，相当于一次类的实例化。
# 包括复杂成员的类，相当于存储了另外一张表的主键的表。
任何两张表都可以产生笛卡尔积，也可以产生连接（等值连接，非等值连接，自连结，左连接，右连接，全连接，交叉连接），
连接条件就像遍历泛型集合的元素那样，随便搞。
但一般我们只会让有业务逻辑关系的两张表进行连接。最典型的表关系有三种：
1. 一对一
   一对一关系的两张表完全可以使用合成一张表替代。表A的一行只与表B的一行关联，且表B的一行也只与表A的一行关联。常用于垂直分库，将一个记录的字段存储到两张表中，两张表的主键相同，行数相同，经常被查询的字段放到一个表中，不经常查询的字段放到另外一张表中，这样能在查询时，避免加载过多的不需要的字段，减少磁盘IO压力。
2. 一对多【**最常用**】
   表A的一行只与表B的一行关联，且表B的一行与表A的多行关联。
	 举例：① 部门表的department_id唯一标识一个部门，员工表的每一个员工信息存放一个department_id。这种案例在数据库设计中最为常见，常搭配外键约束。
	 ② 载具和产品的绑定关系。一个载具对应多个产品，而一个产品只对应一个载具。
3.多对多
	 表A的一行与表B的多行关联，且表B的一行与表A的多行关联。
	 举例：
	 ① 课程表 course_id,course_name 学生表 school_id,NAME,age. 现需要存储学生的选课信息和成绩信息。
		  解答：一个学生可以选多门课程，一门课程可以被多个学生选择。

假设使用两张表，课程表的“选课学生字段”需要存储多个学生的school_id,学生表中的“选课字段”需要存储多个course_id，这便是多对多的场景。数据库字段永远不建议单个字段存储列表，多对多关系使用三张表表示，第三张表存储两张表的关系。
	 
	 
笛卡尔积（交叉连接 CROSS JOIN）
两个集合X和Y，X和Y的笛卡尔积就是X和Y的所有可能组合，也就是第一个对象来自于X，第二个对象来自于Y的所有可能。组合的个数即为两个集合元素个数的乘积数。

分类
# 连接方式
匹配不到是否保留
① 不保留  内连接  INNER JOIN
② 保留 左外连接 LEFT JOIN  右外连接 RIGHT JOIN 匹配不到的话，右表的字段全为NULL
# 连接条件的类别
等值连接：连接条件是字段相等
非等值连接：其他的比较自由的连接条件
# 表的来源
自连接 ：同一张表连接
非自连接：不同的表连接

全外连接：FULL JOIN 全外连接的结果集 = 左连接的结果集 + 右连接未匹配的结果集
MySQL不支持FULL JOIN，可以使用UNION ALL实现FULL JOIN的效果。
# 全外连接案例
SELECT e.last_name,d.department_name
FROM employees e
LEFT JOIN departments d
ON e.department_id = d.department_id
UNION ALL
SELECT e.last_name,d.department_name
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.department_id
WHERE e.department_id IS NULL;
# 交叉连接: CROSS JOIN  笛卡尔积  M × N行记录


左外连接如何找不匹配的行？
不匹配行的右表字段全是NULL（无论字段加没加主键约束，非空约束或默认值约束），必须以右表的【具有非空约束】的列作为筛选字段，最好用右表的主键，因为匹配行的可空字段也可能为NULL.


# 查询所有员工的工资级别
SELECT e.last_name,e.salary,jg.grade_level
FROM employees e
LEFT JOIN job_grades jg
ON e.salary BETWEEN jg.lowest_sal AND jg.highest_sal
ORDER BY jg.grade_level DESC;
-- 左外 + 非等值 + 非自连接


# 查询员工id，姓名及其管理者的id和姓名
SELECT e1.employee_id,e1.last_name,e1.manager_id,e2.last_name
FROM employees e1
LEFT JOIN employees e2
ON e1.manager_id = e2.employee_id;
-- 左外 + 等值 + 自连接

# 选择在城市Toronto工作的员工的last_name,job_id,department_id,department_name
SELECT e.last_name,e.job_id,e.department_id,d.department_name
FROM employees e
INNER JOIN departments d
ON e.department_id = d.department_id
INNER JOIN locations l
ON l.location_id = d.location_id
WHERE l.city = 'toronto';
-- 内连接 + 等值 + 非自连接

# 查询哪些部门没有员工
SELECT d.department_name
FROM departments d
LEFT JOIN employees e
ON e.department_id = d.department_id
WHERE e.employee_id IS NULL;
-- 左外 + 等值 + 非自连接