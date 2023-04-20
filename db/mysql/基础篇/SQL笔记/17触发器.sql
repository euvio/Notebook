-- 触发器的定义
当某张表发生 INSERT UPDATE DELETE 前或后，可以自动触发执行一段SQL。

-- 适用场景
（1）当一个数据表中新增了数据后，就立马同步到另一个表中。
（2）当购买一个商品后，订单表中新增一条数据，势必会造成库存减少。可用 mysql 触发器来实现。
（3）在写入数据前，进行数据的校验。

-- 触发器的语法
CREATE TRIGGER 触发器的名称
[ AFTER | BEFORE] [INSERT DELETE UPDATE] ON 表
FOR EACH ROW
BEGIN
   触发器SQL语句;
END

触发时机： AFTER  BEFORE 发生在表插入/删除/更新 之后/之前
触发事件： INSERT UPDATE DELETE
触发器SQL语句内部可以使用关键字 NEW 和 OLD ; NEW 表示新记录， OLD 表示旧记录；
触发事件是 INSERT 时，无 OLD 有 NEW ; UPDATE 时，有 NEW 有 OLD ； DELETE 时，无 NEW 有 OLD 

-- 实战案例
-- 使用日志记录表中插入数据
CREATE TABLE test_trigger(
    id1 INT PRIMARY KEY AUTO_INCREMENT,
    record VARCHAR(20)
);

CREATE TABLE test_trigger_log(
    id2 INT PRIMARY KEY AUTO_INCREMENT,
    insert_log VARCHAR(30)
);

DELIMITER //
CREATE TRIGGER tri
AFTER INSERT ON test_trigger
FOR EACH ROW
BEGIN
INSERT INTO test_trigger_log(insert_log) VALUES (CONCAT('inserted ',NEW.record));
END //
DELIMITER ;

INSERT INTO test_trigger (record) VALUES('lovely');

SELECT * FROM test_trigger;
SELECT * FROM test_trigger_log;

-- 定义触发器“salary_check_trigger”，基于员工表“employees”的INSERT事件，在INSERT之前检查
-- 将要添加的新员工薪资是否大于他领导的薪资，如果大于领导薪资，则报sqlstate_value为'HY000'的错
-- 误，从而使得添加失败。

DELIMITER $
CREATE TRIGGER salary_check_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
  DECLARE leader_sal DOUBLE DEFAULT 0;
  SELECT salary INTO leader_sal
  FROM employees
  WHERE employee_id = NEW.manager_id;
  IF NEW.salary > leader_sal THEN
	SIGNAL SQLSTATE 'HY000' SET MESSAGE_TEXT = '薪资高于领导薪资错误';
  END IF;
END $
DELIMITER ;

INSERT INTO employees(employee_id,`first_name`,`last_name`,`email`,`phone_number`,`hire_date`,`job_id`,`salary`,`commission_pct`,`manager_id`,`department_id`)
VALUES(302,'Michael','Jackson','mj4@gmail.com','+1 77329-334','9999-12-21','AD_VP',1010,0.3,100,90);


-- 触发器的注意事项
含触发器的表是 INNODB 引擎，触发器SQL和事件是原子的，二者其中一个失败，另一个不再执行或回滚。
含触发器的表是 MYISAM 引擎，不是原子的,其中一个失败，另一个仍旧会执行。

如果从表存在监控自身的 UPDATE DELETE 的触发器, 在外键约束的情况下， 由于主表更新或删除间接的导致从表的 UPDATE DELETE 
不会执行触发器；如果是直接 UPDATE DELETE 从表，才会执行触发器。

-- 触发器的优点
1. 触发器基于行触发，具有事务的原子特性。
2. 自动执行逻辑相关的SQL，保证数据的完整性。
3. 可以对数据进行校验。

-- 触发器的缺点
1. 可移植性差
2. 数据库层面自动调用，非触发器创建者的应用层开发者可能注意不到，版本难以维护
3. 应用层执行SQL语句，如果触发器的SQL执行失败，报错信息是有关触发器的，与应用层SQL无关，可能会让应用层开发者傻一会。
