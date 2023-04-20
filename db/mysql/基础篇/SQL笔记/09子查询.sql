# 子查询
-- 定义 ：
 一个查询语句嵌套在另一个查询语句内部的查询。
-- 注意
（1）子查询必须用括号包裹，且结尾不能是逗号。
（2）子查询的结果集被外查询使用。

 分类： 
 -- 从子查询执行次数角度： 
（1）不相关子查询：
 先执行一次子查询，后续外查询查询每一行时都使用子查询的结果集。（子查询只被执行一次） 
 （2） 相关子查询
 先从外查询开始，外查询将相关字段传送给子查询，子查询查询结束后将结果集反馈再反馈给外查询，外查询最终再执行一次查询。
 外查询查询每一行时，都会执行一次子查询。（子查询中使用了主查询中的列，子查询被执行多次） 
 
 -- 从子查询的结果集角度：
 （1）单值 ：多与等于号一起使用 
 （2）单列 ：多用做集合使用，搭配 IN ANY ALL EXISTS 
 （3）多列 ：多用于中间表，进行表连接  
 
所有的子查询其实都是先得到1个中间表，再将中间表与外表进行连接。当中间表如果是一行一列(一个值)和多行一列(相同类型的向量集合，多个单值) 比较特殊，
可以借助运算符 IN ALL ANY EXISTS 简化查询而不需要(但可以使用)表连接。

【JOIN 多行多列】 >【EXISTS 某种条件(字段,多行多列)】 > 【字段 = ANY 多行单列】  > 【字段 IN 多行单列 】 
 
 
 子查询适合一行一列子查询，多行一列的查询，因为相当于一个集合，多行肯定很少，因为类型不相同。 子查询是表的情况下，多多考虑连接查询！ 
 如果是相关子查询的话，建议从外往里写。 单列子查询 单值子查询 多列子查询（表连接，或 物理表 ） 所有种类的子查询都能转换成连接查询。 
 如果是多列的话，优先考虑使用 ALL ANY IN EXISTS NOT EXISTS IN EXISTS ANY 可以等价互换， exists最强大， ANY 其次， IN 最后 
 
   ALL ANY IN 的含义：
  IN 列表 ： 
  -- 与列表中至少一个元素相等，结果才为真。
  -- 等价于 = ANY 列表
  比较运算符 + ALL 列表 ：
  -- 等价于 (运算符 + 列表元素1) and (运算符 + 列表元素2) AND (运算符 + 列表元素...) AND (运算符 + 列表元素n)
  -- 每一个元素都满足运算符，结果才为真。
  比较运算符 + ANY 列表：
  -- 等价于 (运算符 + 列表元素1) OR (运算符 + 列表元素2) OR (运算符 + 列表元素...) OR (运算符 + 列表元素n)
  -- 至少有一个元素满足运算符，结果才为真。
 
  IN 的列表支持手写， ANY 和 ALL 不支持，必须是查询得来的。
  
  
 # 谁的工资比Abel的工资高？（假设表中只有一个叫Abel的员工）
-- 方式一：子查询
 SELECT
    *
FROM
    employees
WHERE salary >
    (SELECT
        salary
    FROM
        employees
    WHERE last_name = 'abel');

-- 方式二：自连接
 SELECT
    *
FROM
    employees e1
    INNER JOIN employees e2
        ON e2.last_name = 'abel'
WHERE e1.salary > e2.salary;


# 查询工资最低的员工的信息
 SELECT
    *
FROM
    employees
WHERE salary =
    (SELECT
        MIN (salary)
    FROM
        employees);
-- 这种方式很好，能够筛选出多个是最低薪资的员工。
-- 如果使用 ORDER BY ASC salary LIMIT 0,1,只能
-- 拿到一个最低薪资的员工。
        

# 查询最低工资大于50号部门最低工资的部门id和其最低工资
SELECT
    MIN (salary), department_id
FROM
    employees
GROUP BY department_id
HAVING MIN (salary) >
    (SELECT
        MIN (salary)
    FROM
        employees
    WHERE department_id = 50);

    

# 显式员工的employee_id,last_name和location。其中，若员工department_id与location_id为1800
# 的department_id相同，则location为’Canada’，其余则为’USA’。
SELECT
    employee_id, last_name, IF (
        (
            department_id IN
            (SELECT
                department_id
            FROM
                departments
            WHERE location_id = 1800)
        ), 'Canada', 'USA'
    ) AS location
FROM
    employees e;

    

  
  # 返回其它job_id中比job_id为‘IT_PROG’的工种的任一工资低的员工的员工号、姓名、job_id 以及salary
  


SELECT 'hello' WHERE 1  ALL=(1,2,3);



SELECT
    '1'
FROM
    DUAL
WHERE 100 ALL 
# 查询员工中工资大于本部门平均工资的员工的last_name,salary和其department_id
 SELECT
    last_name, salary, department_id
FROM
    employees e
WHERE salary >
    (SELECT
        AVG (salary)
    FROM
        employees
    WHERE department_id = e.department_id);
    
    

# 查询和zlotkey相同部门的员工姓名和工资
 SELECT
    *
FROM
    employees
WHERE department_id IN
    (SELECT
        department_id
    FROM
        employees
    WHERE last_name = 'zlotkey');

# 选择工资大于所有JOB_ID = 'SA_MAN'的员工的工资的员工的last_name,job_id,salary.
SELECT * FROM employees
WHERE salary > ALL
(
SELECT DISTINCT salary
FROM employees
WHERE job_id = 'SA_MAN'
);

# 查询管理者是King的员工的信息
SELECT * FROM employees e1
INNER JOIN employees e2
ON e1.manager_id = e2.employee_id
WHERE e2.last_name = 'King';


# 查询工资最低的员工的信息

SELECT * FROM employees
WHERE salary = 
(SELECT MIN(salary) FROM employees);


