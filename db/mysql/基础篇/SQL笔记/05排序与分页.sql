升序 ASC (ascend)
降序 DESC (descend)
# 如果没有排序，返回的记录顺序是添加记录的顺序。
SELECT * FROM employees;
# 按照单列排序： 按照部门编号升序排序结果集
SELECT * FROM employees ORDER BY department_id ASC;
# 按照多列排序：按照部门编号升序，薪资降序
SELECT * FROM employees ORDER BY department_id ASC,salary DESC;
-- 如果第一列都不相同，这样已经足够决定了结果集的顺序了，就不会再去看第二列排序。
-- 如果第一列相同时，再比较第二列排序。




# 从表中取出若干条连续的行
LIMIT 起始索引，行数 （起始索引从0开始）
SELECT * FROM employees;
# 查询前10条记录
SELECT * FROM employees LIMIT 0,10;
# 查询第10-14条记录
SELECT * FROM employees LIMIT 9,5;

优点：
① 降低网络传输的数据量，降低带宽
② 提高查询效率

应用场景
①
# 分页查询
# 每页显示pagesize条，如何显示第page页？
SELECT * FROM employees LIMIT (page-1)*pagesize,pagesize;
# 每页显示3条，取出第2页的数据
SELECT * FROM employees LIMIT 3,3;
②
# 检查表中是否存在满足某种条件的记录
# 员工信息表中是否存在1990年前入职的员工
SELECT COUNT(*) FROM employees 
WHERE hire_date < '1990-01-01'; -- 效率低，扫描全表

SELECT * FROM employees 
WHERE hire_date < '1990-01-01' LIMIT 0,1; -- 效率高，找到即停止 
③
# 查询工资最高的员工
SELECT * FROM employees ORDER BY salary DESC LIMIT 0,1;

# 经常犯的错误
LIMIT的第二个参数是查询的条数，而不是结束的索引。第一个参数的额索引是从0开始的，不是从1开始的。








