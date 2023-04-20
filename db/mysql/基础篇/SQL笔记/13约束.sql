约束 CONSTRAINT 约束的目的：对表中字段的限制，避免无效或错误数据存储到数据库 类似于C #的属性，一种防呆。不加约束表也能正常工作，但是加了约束，可以避免或及时发现开发错误。
 约束的种类： CHECK约束 CHECK 默认值约束 DEFAULT 非空约束 NOT NULL 唯一约束 UNIQUE 主键约束 PRIMARY KEY 外键约束 FOREIGN KEY 创建表时未添加约束，后续再为列添加约束，可能因为表中已存在的记录不满足相应的约束导致添加约束失败。 这时候，只能删除不满足约束的记录或者修改字段的值使其满足约束，才能添加成功。 # 查看表中的上述约束的方法
 SHOW CREATE TABLE 表名;

# CHECK约束
 插入记录时，检查字段的值是否满足某种条件，特别像CSharp中的属性。 CREATE TABLE test_check (
  salary DECIMAL (8, 2) CHECK (salary BETWEEN 1800
    AND 18000)
);

INSERT INTO test_check
VALUES
  (2000);

-- success
 -- Check constraint 'test_check_chk_1' is violated.
 INSERT INTO test_check
VALUES
  (1000);

-- error
 # 默认值约束 DEFAULE(默认值)
 插入记录时，如果不指定列的值，则使用默认值。 CREATE TABLE test_default (
  salary DECIMAL (8, 2) NOT NULL DEFAULT (0)
);

INSERT INTO test_default
VALUES
  ();

SELECT
  *
FROM
  test_default;

# 非空约束
 （1）空 代表未知状态。空字符串 '' 和0都不是空，空是NULL.(2) NOT NULL,
限制字段的值不允许为NULL，否则插入记录失败。 （3）①运算符的操作数存在NULL时，结果都是NULL,
会出现各种特例现象会让开发者容易犯错。 ②NULL会导致索引失效。 所以强烈推荐创建表时，将所有列设置成NOT NULL，以一个约定的列类型的值代替NULL表示未知状态，并把该值设置成默认值。 CREATE TABLE test_null (
  id INT NOT NULL,
  `NAME` VARCHAR (15) NOT NULL DEFAULT '',
  email VARCHAR (20)
);

DROP TABLE score;

-- 唯一约束
 UNIQUE ① 列的值不允许重复，但是允许出现多个NULL ② 唯一约束可以是某一个列的值唯一，也可以多个列组合的值唯一。 ③ 如果创建唯一约束时未指定名称，如果是单列，就默认和列名相同；如果是组合列，那么默认和 () 中排在第一个的列名相同。也可以自定义唯一性约束名。 ④ MySQL默认会给唯一约束的列创建一个唯一索引,
唯一索引名称与唯一约束名称相同。 ⑤ 命名规范 uk_表名_列名 -- 创建单列唯一约束。在字段后面添加关键字UNIQUE，这种方式只能添加单列约束
 CREATE TABLE student (
  sid INT UNIQUE,
  age TINYINT,
  NAME VARCHAR (15)
);

-- 创建单列唯一约束。在所有字段后面声明唯一约束。这种方式既可以添加单列约束，也可以添加多列约束
 CREATE TABLE course (
  cid INT,
  NAME VARCHAR (15),
  CONSTRAINT uk_course_cid UNIQUE KEY (cid)
);

-- 创建多列唯一约束
 CREATE TABLE score (
  score FLOAT,
  sid INT,
  cid INT,
  CONSTRAINT uk_score_sid_cid UNIQUE KEY (sid, cid)
);

# 查看表中的唯一索引
 SHOW INDEX FROM score;

-- Non_unique = 0 表示是唯一索引 seq_in_index表示约束的列
 SHOW CREATE TABLE score;

-- 通过查看创建表的语句
-- 通过可视化客户端查看表中的索引最为方便
 -- 删除唯一约束(唯一索引)
 MySQL无法直接删除约束，只能通过删除它对应的唯一索引的方式删除唯一约束。 删除时需要指定唯一索引名，唯一索引名和唯一约束名一样。 ALTER TABLE score
  DROP INDEX uk_score_sid_cid;

# 主键约束 = 非空约束 + 唯一约束
 ① 唯一标记一行记录 
 ② 一张表只能有一个主键约束 
 ③ 主键列不允许重复，不允许为空 
 ④ 主键约束分为单列和复合,复合时多列只要有一列不同即可，且多列任意一列都不可为空 
 ⑤ MySQL自动为主键创建聚簇索引 
 ③ 主键约束和其对应的聚簇索引的名称固定为PRIMARY 
 ⑦ 建议主键列类型为整数，且永远不要修改某一行的主键值

CREATE TABLE student (
  sid INT PRIMARY KEY,
  age INT,
  NAME VARCHAR (15)
);

CREATE TABLE course (
  cid INT,
  NAME VARCHAR (15),
  CONSTRAINT PRIMARY KEY (cid)
);

CREATE TABLE score (
  score FLOAT,
  sid INT,
  cid INT,
  CONSTRAINT PRIMARY KEY (sid, cid)
);


# 自增列  AUTO_INCREMENT
 ① 一个表最多只能有一个自增长列 
 ② 当需要产生唯一标识符或顺序值时，可设置自增长 
 ③ 自增长约束的列必须是主键列或唯一约束列 
 ④ 自增长约束列的数据类型必须是整数类型 
 ⑤ 其实在真实开发中，就是用于主键列中 
 -- 应当遵守一个规范(原则)，永远不要在插入记录时，为自动增长列显示指定值，让其自动增长。
 CREATE TABLE test_auto_increment (
      id INT PRIMARY KEY AUTO_INCREMENT
 );

SELECT
  *
FROM
  test_auto_increment;

-- 主键默认从1开始增长
 INSERT INTO test_auto_increment
VALUES
  ();

-- MySQL内部有一个累加器，始终保持目前生成的最新的也是最大的值。
-- 累加器只可能单调增长，不可能变小，关闭MySQL服务,累加器的值会被持久化。
 INSERT INTO test_auto_increment
VALUES
  ();

INSERT INTO test_auto_increment
VALUES
  ();

DELETE
FROM
  test_auto_increment
WHERE id = 3
  OR id = 2;

-- 重启MySQL
 INSERT INTO test_auto_increment
VALUES
  ();

# 主键值为4，而不是3
-- 因为此时主键2不存在，所以可以插入主键2
 INSERT INTO test_auto_increment
VALUES
  (2);

-- 再次插入
 INSERT INTO test_auto_increment
VALUES
  ();

# 主键是5
 -- 主键不赋值，或为主键赋值为NULL或0在表中现存的最大主键值的基础上增长。
 INSERT INTO test_auto_increment
VALUES
  ();

INSERT INTO test_auto_increment
VALUES
  (0);

INSERT INTO test_auto_increment
VALUES
  (NULL);

-- 如果显示赋值自增列，显示指定的值若大于累加器中的值，则累加器的值会被刷新成显示指定值
INSERT INTO test_auto_increment
VALUES (2022);

INSERT INTO test_auto_increment VALUES(); # 主键值是2023
 -- 查看自增列
 DESC test_auto_increment; -- 看extra中的信息
 
 
 # 外键约束
       保证从表的引用完整性，保证从表的外键在主表中都能找到。 
  
 添加外键约束后： 
 ① 主表的主键更新，同步更新从表的外键 
 ② 删除主表的主键，先去检查它与从表的外键列是否存在关联，若存在，则不允许删除。 
 ③ 从表插入记录时，必须保证外键值在主表中已经存在，否则，插入失败。 
 ④ 创建 (CREATE) 表时就指定外键约束的话，先创建主表，再创建从表 
 ⑥ 删表时，先删从表（或先删除外键约束），再删除主表 
 
 要求： 
 （1）从表的外键列，必须引用 / 参考主表的主键或唯一约束的列 
 （2）在创建外键约束时，如果不给外键约束命名，默认名不是列名，而是自动产生一个外键名（例如 student_ibfk_1;），也可以指定外键约束名。 
 （3）当创建外键约束时，系统默认会在所在的列上建立对应的普通索引。但是索引名是外键的约束 名。（根据外键查询效率很高） 
 （4）删除外键约束后，必须手动删除对应的索引 
 （5）从表的外键列与主表被参照的列名字可以不相同，但是数据类型必须一样，逻辑意义一致。 

 CREATE TABLE dept (
   id INT PRIMARY KEY,
   dept_name VARCHAR (20),
   city VARCHAR (10)
);

CREATE TABLE emp (
   id INT PRIMARY KEY,
   salary DECIMAL (8, 2),
   dept_id INT,
   CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES dept (id) ON UPDATE CASCADE ON DELETE RESTRICT
);

-- 删除约束
 (1) 第一步先查看约束名和删除外键约束
SELECT * FROM information_schema.table_constraints
WHERE table_name = '表名称';

#查看某个表的约束名 
ALTER TABLE 从表名 DROP FOREIGN KEY 外键约束名;

(2) 第二步查看索引名和删除索引。（注意，只能手动删除）
   SHOW INDEX FROM 表名称;

  ALTER TABLE 从表名 DROP INDEX 索引名;

【强制】不得使用外键与级联，一切外键概念必须在应用层解决。 
说明：（概念解释）学生表中的 student_id 是主键，那么成绩表中的 student_id 则为外键。
如果更新学生表中的 student_id，同时触发成绩表中的 student_id 更新，即为级联更新。
外键与级联更新适用于单机低并发，不适合分布式、高并发集群；
级联更新是强阻塞，存在数据库更新风暴的风险；
外键影响 数据库的插入速度。 表中无约束，心中有约束。