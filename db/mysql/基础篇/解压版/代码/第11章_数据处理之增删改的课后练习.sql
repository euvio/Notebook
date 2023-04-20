
#第11章_数据处理之增删改的课后练习
#练习1：
#1. 创建数据库dbtest11
CREATE DATABASE IF NOT EXISTS dbtest11 CHARACTER SET 'utf8';

#2. 运行以下脚本创建表my_employees
USE dbtest11;


CREATE TABLE my_employees(
	id INT(10),
	first_name VARCHAR(10),
	last_name VARCHAR(10),
	userid VARCHAR(10),
	salary DOUBLE(10,2)
);

CREATE TABLE users(
	id INT,
	userid VARCHAR(10),
	department_id INT
);



#3.显示表my_employees的结构

DESC my_employees;

DESC users;

#4.向my_employees表中插入下列数据
ID	FIRST_NAME	LAST_NAME	USERID		SALARY
1	patel		Ralph		Rpatel		895
2	Dancs		Betty		Bdancs		860
3	Biri		Ben		Bbiri		1100
4	Newman		Chad		Cnewman		750
5	Ropeburn	Audrey		Aropebur	1550

INSERT INTO my_employees
VALUES(1,'patel','Ralph','Rpatel',895);

INSERT INTO my_employees VALUES
(2,'Dancs','Betty','Bdancs',860),
(3,'Biri','Ben','Bbiri',1100),
(4,'Newman','Chad','Cnewman',750),
(5,'Ropeburn','Audrey','Aropebur',1550);

SELECT * FROM my_employees;

DELETE FROM my_employees;

#方式2：
INSERT INTO my_employees
SELECT 1,'patel','Ralph','Rpatel',895 UNION ALL
SELECT 2,'Dancs','Betty','Bdancs',860 UNION ALL
SELECT 3,'Biri','Ben','Bbiri',1100 UNION ALL
SELECT 4,'Newman','Chad','Cnewman',750 UNION ALL
SELECT 5,'Ropeburn','Audrey','Aropebur',1550;
			
#5.向users表中插入数据
1	Rpatel		10
2	Bdancs		10
3	Bbiri		20
4	Cnewman		30
5	Aropebur	40
INSERT INTO users VALUES
(1,'Rpatel',10),
(2,'Bdancs',10),
(3,'Bbiri',20),
(4,'Cnewman',30),
(5,'Aropebur',40)

SELECT * FROM users;



#6. 将3号员工的last_name修改为“drelxer”
UPDATE my_employees
SET last_name = 'drelxer'
WHERE id = 3;

#7. 将所有工资少于900的员工的工资修改为1000
UPDATE my_employees
SET salary = 1000
WHERE salary < 900;

#8. 将userid为Bbiri的users表和my_employees表的记录全部删除

#方式1：
DELETE FROM my_employees
WHERE userid = 'Bbiri';

DELETE FROM users
WHERE userid = 'Bbiri';

#方式2：

DELETE m,u
FROM my_employees m
JOIN users u
ON m.userid = u.userid
WHERE m.userid = 'Bbiri';

SELECT * FROM my_employees;
SELECT * FROM users;









