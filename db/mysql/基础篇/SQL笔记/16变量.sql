
变量：系统变量和自定义变量。

系统变量：系统内置的服务器层级变量。
（1）全局变量 = 仅能全局(max_connections) + 可以复制一份给会话(character_set_client)。影响所有会话,重启服务器失效。默认值来自my.ini
（2）会话变量。可复制的全局变量的副本 +  新增的会话专属变量。屏蔽全局变量，仅影响当前会话。

SELECT @@global.character_set_client = '';


自定义变量：开发者定义的变量
（1）全局变量。当前会话内全局可用
（2）局部变量。存储过程，存储函数的变量，位于BEGIN，END中，BEGIN END的第一句话。


-- 系统变量-全局变量
SHOW GLOBAL VARIABLES;
SHOW GLOBAL VARIABLES LIKE '%char%';
SELECT @@GLOBAL.character_set_connection;
SET @@GLOBAL.character_set_connection='utf8mb4';

-- 系统变量-会话变量
SHOW SESSION VARIABLES;
SHOW SESSION VARIABLES LIKE '%char%';
SELECT @@SESSION.character_set_connection;
SET @@SESSION.character_set_connection='utf8mb3';



-- 自定义全局变量：作用域与会话变量相同。
-- 自定义局部变量： 只能在BEGIN和END之间，且位于BEGIN和END的第一句，只能用于存储过程和存储函数


-- 定义自定义全局变量
SET @global_variable='K_ing';
-- 赋值自定义全局变量
SET @global_variable = 'Jerry';
SELECT AVG(salary) INTO @global_variable FROM employees;
-- 输出自定义全局变量
SELECT @global_variable;
-- 自定义全局变量计算两数之和
SET @num1 = 1;
SET @num2 = 1;
SET @sum = @num1 + @num2;
SELECT @sum;


-- 自定义局部变量
DECLARE local_variable INT DEFAULT 0;
-- 赋值自定义局部变量
SET local_variable=1;
SELECT MAX(salary) INTO @local_variable FROM employees;
-- 输出自定义局部变量
SELECT local_variable;
-- 自定义局部变量计算两数之和

SET GLOBAL log_bin_trust_function_creators = 1;

DELIMITER //
CREATE FUNCTION myfunction() RETURNS INT
BEGIN
DECLARE num1 INT DEFAULT 1;
DECLARE num2 INT DEFAULT 2;
DECLARE SUM INT DEFAULT 0;
SELECT num1 + num2 INTO SUM;
RETURN SUM;
END //
DELIMITER ;

SELECT myfunction();


