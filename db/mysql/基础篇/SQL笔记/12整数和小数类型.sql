# 整数类型
整数类型     存储空间   有符号表示范围   无符号表示范围
TINYINT      1个字节    -128-127           0-255
SMALLINT     2个字节    -32768~32767       0~65535
MEDIUMINT    3个字节
INT          4个字节
BIGINT       8个字节

① 如果字段确认不可能为负，强烈推荐加UNSIGNED
② 在保证存储空间在当下和未来都绝对够用的前提下，选择字节最少的类型。节省空间，减少磁盘IO

CREATE TABLE IF NOT EXISTS test_int(
  age TINYINT UNSIGNED,
	order_number BIGINT UNSIGNED,
	customer_increment MEDIUMINT
) ENGINE = INNODB, DEFAULT CHARACTER SET = 'utf8mb4';


# 小数类型
# 浮点数
FLOAT    4个字节
DOUBLE   8个字节
-- 和高级语言一样，MySQL的float和double也不能精确的表示一个小数。
CREATE TABLE IF NOT EXISTS test_float
( field FLOAT);
INSERT INTO test_float VALUES(1.1);
INSERT INTO test_float VALUES(1.5);

SELECT field = 1.1 FROM test_float; -- 返回0 0
SELECT field = 1.5 FROM test_float; -- 返回0 1
# 因为浮点数是不准确的，所以我们要避免使用“=”来判断两个小数是否相等。ABS(a-b) < 精度

# 定点数
DECIMAL(M,D)  存储空间：M + 2 个字节
-- 使用DECIMAL(M,D) 的方式表示高精度小数。其中，M（小数的位数+整数的位数），D（小数的位数）。
-- 0<=M<=65，0<=D<=30，D<M。例如，定义DECIMAL（5,2）的类型，表示该列取值范围是-999.99~999.99。
-- 定点数在MySQL内部是以字符串的形式进行存储，这就决定了它一定是精准的。
-- 涉及金融使用decimal，普通的仍旧使用FLOAT和DOUBLE，计算快，省空间。

CREATE TABLE IF NOT EXISTS test_decimal
( field DECIMAL(7,3));
-- OK
INSERT INTO test_decimal VALUES(1234.123); 
-- OK 小数部分超出范围，自动四舍五入
INSERT INTO test_decimal VALUES(1234.1235); 
-- 整数部分超出范围，报错
-- Out of range value for column 'field' at row 1
INSERT INTO test_decimal VALUES(12345.123); 

SELECT * FROM test_decimal;
-- DECIMAl 无精度损失，比较小数可以直接使用=
INSERT INTO test_decimal VALUES(1.1);
SELECT field = 1.1 FROM test_decimal;

# 如果DECIMAL的存储范围不够用怎么办？
-- 用两个字段表示小数，整数一个字段，小数一个字段。