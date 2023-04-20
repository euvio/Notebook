存储过程: STORED PROCEDURE，一组经过预先编译的SQL语句的封装。

执行过程：存储过程预先编译好存储在 MySQL 服务器上，需要执行的时候，客户端只需要向服务器端发出调用
存储过程的命令，服务器端就可以把预先存储好的这一系列SQL语句全部执行。

优点
1、存储过程可以一次编译多次使用。存储过程只在创建时进行编译，之后的使用都不需要重新编译，
这就提升了 SQL 的执行效率；简化操作，提高了sql语句的重用性，减少了开发程序员的压力，减少操作过程中的失误，提高效率

2、可以减少开发工作量。将代码 封装 成模块，实际上是编程的核心思想之一，这样可以把复杂的问题
拆解成不同的模块，然后模块之间可以 重复使用 ，在减少开发工作量的同时，还能保证代码的结构清
晰。

3、存储过程的安全性强。我们在设定存储过程的时候可以 设置对用户的使用权限 ，这样就和视图一样具
有较强的安全性。

4、可以减少网络传输量。因为代码封装到存储过程中，每次使用只需要调用存储过程即可，这样就减
少了网络传输量。

5、良好的封装性。在进行相对复杂的数据库操作时，原本需要使用一条一条的 SQL 语句，可能要连接
多次数据库才能完成的操作，现在变成了一次存储过程，只需要 连接一次即可 。

缺点
1、可移植性差。存储过程不能跨数据库移植，比如在 MySQL、Oracle 和 SQL SERVER 里编写的存储过
程，在换成其他数据库时都需要重新编写。
2、调试困难。只有少数 DBMS 支持存储过程的调试。对于复杂的存储过程来说，开发和维护都不容
易。虽然也有一些第三方工具可以对存储过程进行调试，但要收费。
3、存储过程的版本管理很困难。比如数据表索引发生变化了，可能会导致存储过程失效。我们在开发
软件的时候往往需要进行版本管理，但是存储过程本身没有版本控制，版本迭代更新的时候很麻烦。
4、它不适合高并发的场景。高并发的场景需要减少数据库的压力，有时数据库会采用分库分表的方
式，而且对可扩展性要求很高，在这种情况下，存储过程会变得难以维护， 增加数据库的压力 ，显然就
不适用了。


存储过程的参数类型可以是IN、OUT和INOUT。
IN 输入参数
OUT 输出参数
INOUT 既可以作为输入，也可以作为输出


因为MySQL默认的语句结束符号为分号‘;’。为了避免与存储过程中SQL语句结束符相冲突，需要使用
DELIMITER改变存储过程的结束符。
比如：“DELIMITER //”语句的作用是将MySQL的结束符设置为//，并以“END //”结束存储过程。存储过程定
义完毕之后再使用“DELIMITER ;”恢复默认结束符。DELIMITER也可以指定其他符号作为结束符。

-- 创建存储过程show_someone_salary，查看某个员工的薪资
-- SQL SECURITY 有两种值：definer 只允许调用者是存储过程的调用者。invoker 拥有此存储过程权限的用户都可以调用。

DELIMITER //

CREATE PROCEDURE show_someone_salary (
  IN empname VARCHAR (20),
  OUT empsalary DOUBLE
)
SQL SECURITY DEFINER
COMMENT '查看最高薪资'

BEGIN
  SELECT
    salary INTO empsalary
  FROM
    employees
  WHERE last_name = empname;

END //

DELIMITER ;


SET @empname = 'Abel';
SET @empsalary = 0;
CALL show_someone_salary(@empname,@empsalary);
SELECT @empsalary;

存储过程的用处：
批量插入模拟数据
删除数据库中的所有索引
以上在测试环境测试SQL性能比较有用。
动态传入字段的值，复用SQL语句，减少应用层的开发难度。

-- 创建存储过程show_mgr_name，查询某个员工领导的姓名

DROP PROCEDURE show_mgr_name;

DELIMITER //

CREATE PROCEDURE show_mgr_name (INOUT empname VARCHAR (20))
BEGIN
  
  SELECT
    last_name INTO empname
  FROM
    employees
  WHERE employee_id =
    (SELECT
      manager_id
    FROM
      employees
    WHERE last_name = empname);
  
END //

DELIMITER;

SET @empname = 'Abel';
CALL show_mgr_name(@empname);
SELECT @empname;



-- 存储函数

DELIMITER //

CREATE FUNCTION email_by_id (emp_id INT) RETURNS VARCHAR (25) 
BEGIN
  RETURN
  (SELECT
    email
  FROM
    employees
  WHERE employee_id = emp_id);
END //

DELIMITER;

SET @emp_id = 102;
SELECT email_by_id(102);


存储过程和存储函数的区别
① 存储函数可以放在查询语句中使用，存储过程不行。
② 存储过程可以有多个返回值

调试存储注意查询为空的情况，仔细测试各种特例情况。
 
 







