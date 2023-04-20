视图
-- 虚拟表，动态临时从物理表中生成。
-- 可以把SELECT语句制作成视图，调用视图便是执行SELECT语句。
-- 适用于复杂的和经常使用的SQL语句。
-- 一些复杂的SQL语句都有共同的部分，可以把共同部分创建成视图，
-- 这些复杂语句由视图加简短的SQL语句组成，方便开发者使用。

应用场景：查询指定的部门名的所有员工的薪资。

-- drop view view1;

CREATE VIEW view1 AS
SELECT last_name,salary,department_name FROM employees e LEFT JOIN departments d
ON e.department_id = d.department_id;

SELECT * FROM view1 WHERE department_name = 'IT';


-- 视图和存储过程的区别
存储过程传入参数即可，视图需要拼接SQL。

CALL procedure1('IT');
SELECT * FROM view1 WHERE department_name = 'IT';

