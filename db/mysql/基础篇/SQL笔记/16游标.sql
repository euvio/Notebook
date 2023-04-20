# 游标
-- 一种遍历结果集的方法

游标是 MySQL 的一个重要的功能，为 逐条读取 结果集中的数据，提供了完美的解决方案。跟在应用层
面实现相同的功能相比，游标可以在存储程序中使用，效率高，程序也更加简洁。
但同时也会带来一些性能问题，比如在使用游标的过程中，会对数据行进行 加锁 ，这样在业务并发量大
的时候，不仅会影响业务之间的效率，还会 消耗系统资源 ，造成内存不足，这是因为游标是在内存中进
行的处理。
建议：养成用完游标之后就关闭的习惯，这样才能提高系统的整体效率。

DELIMITER //
CREATE PROCEDURE get_count_by_limit_total_salary(IN limit_total_salary DOUBLE,OUT total_count INT)
BEGIN
  DECLARE sum_salary DOUBLE DEFAULT 0; #记录累加的总工资
  DECLARE cursor_salary DOUBLE DEFAULT 0; #记录某一个工资值
  DECLARE emp_count INT DEFAULT 0; #记录循环个数
  
  #定义游标
  DECLARE emp_cursor CURSOR FOR SELECT salary FROM employees ORDER BY salary DESC;
  #打开游标
  OPEN emp_cursor;
  REPEAT
  #使用游标（从游标中获取数据）
  FETCH emp_cursor INTO cursor_salary;
  SET sum_salary = sum_salary + cursor_salary;
  SET emp_count = emp_count + 1;
  UNTIL sum_salary >= limit_total_salary
  END REPEAT;
  SET total_count = emp_count;
  #关闭游标
  CLOSE emp_cursor;
END //
DELIMITER ;





