# 流程控制

# 顺序结构
# 分支结构
# 循环结构

循环结构只能在存储过程(函数)中使用,分支结构可用于存储过程(函数)或SELECT后。

# 分支结构
DROP PROCEDURE p2

-- 单选
DELIMITER //
CREATE PROCEDURE p2()
BEGIN
	DECLARE score INT DEFAULT 75;
	IF(score % 3 = 0) 
	    THEN SELECT '是3的整数倍';
	ELSEIF(score % 5 = 0) 
	    THEN SELECT '是5的整数倍';
	ELSE
       SELECT '既不是3的倍数，也不是5的倍数';
	END IF;
END //
DELIMITER ;

CALL p2();


-- 多选
DELIMITER //
CREATE PROCEDURE p1()
BEGIN
	DECLARE score INT DEFAULT 75;	
	
	IF(score % 3 = 0) 
	    THEN SELECT '是3的整数倍';
	END IF;  # 完整的IF结构
	
	IF(score % 5 = 0) 
	    THEN SELECT '是5的整数倍';
	END IF;  # 完整的IF结构
END //
DELIMITER ;

CALL p1();

-- 单选
DELIMITER //
CREATE PROCEDURE p4()
BEGIN
	DECLARE score INT DEFAULT 75;
	
	CASE # 此处可省略表达式
		WHEN(score % 5 = 0)
			THEN SELECT '是5的整数倍';
		WHEN (score % 3 = 0)
			THEN SELECT '是3的整数倍';
		ELSE 
			SELECT '既不是3的倍数，也不是5的倍数';
	END CASE;
END //
DELIMITER ;

CALL p4();


-- 多选
DELIMITER //
CREATE PROCEDURE p3()
BEGIN
	DECLARE score INT DEFAULT 75;
	
	CASE # 此处可省略表达式
	WHEN(score % 5 = 0)
	        THEN SELECT '是5的整数倍';
	END CASE;
	
	CASE
	WHEN (score % 3 = 0)
		THEN SELECT '是3的整数倍';
	END CASE;
END //
DELIMITER ;

CALL p3();


-- CASE 判断表达式 结构，相当于CSharp的SWITCH CASE结构

# 声明存储过程 update_sal_by_eid，输入员工的ID, 入职0年涨薪100，
# 入职1年涨薪200，入职2年涨薪300，其他涨薪500. 
# 输入的员工ID不存在则返回“查无此人”。

DELIMITER //
CREATE PROCEDURE update_sal_by_eid (IN empid INT)
BEGIN
  DECLARE hire_year INT DEFAULT NULL;
  SELECT DATEDIFF (CURRENT_DATE (), hire_date) / 365 INTO hire_year FROM employees
  WHERE employee_id = empid;
  IF(hire_year IS NULL) 
    THEN SELECT '查无此人';
  ELSE
    CASE hire_year
      WHEN 0
        THEN UPDATE employees SET salary = salary + 100   WHERE employee_id = empid;
      WHEN  1
        THEN UPDATE employees SET salary = salary + 200  WHERE employee_id = empid;
      WHEN  2
        THEN UPDATE employees SET salary = salary + 300  WHERE employee_id = empid;
      ELSE UPDATE employees SET salary = salary + 500  WHERE employee_id = empid;
    END CASE;
  END IF;
END //
DELIMITER ;


CALL update_sal_by_eid(1000)
CALL update_sal_by_eid(100)
SELECT salary FROM employees WHERE employee_id = 100;


-- 循环语句
 # 累加直到i不小于10
DELIMITER //
CREATE PROCEDURE test_while()
BEGIN
	DECLARE i INT DEFAULT 0;
	WHILE i < 10 DO
		SET i = i + 1;
	END WHILE;
	SELECT i;
END //
DELIMITER ;
#调用
CALL test_while();

LEAVE 和 ITERATE
LEAVE 用于跳出 BEGIN END 结构体，或者跳出循环，相当于CSharp中的break

# LEAVE 跳出 BEGIN END结构体
DELIMITER //
CREATE PROCEDURE leave_begin(IN num INT)
begin_label: BEGIN
	IF num<=0
		THEN LEAVE begin_label;
	ELSEIF num=1
		THEN SELECT AVG(salary) FROM employees;
	ELSEIF num=2
		THEN SELECT MIN(salary) FROM employees;
	ELSE
		SELECT MAX(salary) FROM employees;
	END IF;
	SELECT COUNT(*) FROM employees;
END //
DELIMITER ;

# 跳出循环
当市场环境不好时，公司为了渡过难关，决定暂时降低大家的薪资。声明存储过程“leave_while()”，声明
OUT参数num，输出循环次数，存储过程中使用WHILE循环给大家降低薪资为原来薪资的90%，直到全公
司的平均薪资小于等于10000，并统计循环次数。

DELIMITER //
CREATE PROCEDURE leave_while(OUT num INT)
BEGIN
	DECLARE avg_sal DOUBLE; # 记录平均工资
	DECLARE while_count INT DEFAULT 0; # 记录循环次数
  SELECT AVG(salary) INTO avg_sal FROM employees; 
  while_label: WHILE TRUE DO
    IF avg_sal <= 10000 THEN
      LEAVE while_label;
    END IF;
    UPDATE employees SET salary = salary * 0.9;
    SET while_count = while_count + 1;
    SELECT AVG(salary) INTO avg_sal FROM employees;
  END WHILE;
  SET num = while_count;
END //
DELIMITER ;

-- ITERATE 只能用于跳出循环
DROP PROCEDURE pp;

DELIMITER //
CREATE PROCEDURE pp()
BEGIN
  DECLARE i TINYINT DEFAULT 5;
  while_label: WHILE i > 0 DO
    IF(i % 2 = 0)
      THEN 
        SELECT CONCAT(i,'是偶数'); 
        SET i = i - 1; 
    ELSE 
      SET i = i - 1;
      ITERATE while_label; 
      SELECT CONCAT(i,'是奇数');
    END IF;
  END WHILE;
END //
DELIMITER ;

CALL pp();

-- SELECT语句中使用IF和CASE

SELECT IFNULL(commission_pct,'无奖金') 
FROM employees;

SELECT IF(commission_pct IS NULL,'无奖金','有奖金') 
FROM employees;

SELECT 
  CASE commission_pct IS NULL 
    WHEN 1 THEN '无奖金' 
    ELSE '有奖金' 
  END
FROM employees;












