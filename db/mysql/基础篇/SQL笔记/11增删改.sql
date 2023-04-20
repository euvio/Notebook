CREATE TABLE test_dml ( 
	id INT PRIMARY KEY AUTO_INCREMENT,
	age MEDIUMINT DEFAULT 0, 
	email VARCHAR ( 50 ) NOT NULL 
);

插入数据有两种方式：

-- 方式一：带列名的插入

① 可以写出所有的列名，也可以只写出部分列名，列名的书写顺序随意，可与表定义的字段顺序不同。
② 未书写出的列，必须能够让MySQL自动推算出值，如具有自增性，可为空，具有默认约束。
③ 无法让MySQL自动推算出的值的列必须书写，如具有非空约束的列，未设置自增的主键列。
④ 值的顺序、数量必须和列的顺序、数量相同，类型一致或或兼容。

-- 方式二：不带列名的插入

① 严格按照表的字段顺序提供值，表有多少字段，就必须提供多少值，不能省略任何字段。
② 为自增的主键列提供的值可以是NULL或0,表示按照MySQL内部的计数器自增。


注意：实际生产环境下的SQL语句最好按照方式一插入记录！


INSERT INTO test_dml VALUES(NULL,20,'baiyun@gmail.com');

-- Column count doesn't match value count at row 
INSERT INTO test_dml VALUES(20,'baiyun@gmail.com');
INSERT INTO test_dml VALUES(NULL,'baiyun@gmail.com');


INSERT INTO 
test_dml(age,id,email) 
VALUES
(20,NULL,'sky@gmail.com');


INSERT INTO 
test_dml(email) 
VALUES
('pearls@gmail.com');

--  Field 'email' doesn't have a default value
INSERT INTO 
test_dml(age,id) 
VALUES
(20,NULL);


# 一条语句插入多条记录
INSERT INTO 
test_dml(email) 
VALUES
('pearls@gmail.com'),
('ruby@gmail.com'),
('dollar@gmail.com');

注意：一条SQL语句插入多条记录比使用多条SQL语句性能要高得多，且是原子操作。

# 将查询的结果集插入表中
USE myemployees;

INSERT INTO
	test_dml(age,email)
(
SELECT department_id,email 
FROM employees
LIMIT 0,5
);



# 更新记录

-- 更新整张表
UPDATE test_dml 
SET age = 30;

-- 更新部分行
UPDATE test_dml
SET age = 25
WHERE email LIKE '%l%';

-- 更新多个字段
UPDATE test_dml
SET age = 20,email = 'info@outlook.com';


# 删除记录

-- 删除id是1的记录
DELETE FROM test_dml
WHERE id = 1;

-- 清空整张表
DELETE FROM test_dml;

























