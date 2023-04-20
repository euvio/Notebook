# CHAR(M)
① M是可以存放的最大字符个数（注意:不是字节个数），不管是什么字符集，中文字符和英文字符都算一个字符。如果插入的字符串的长度大于M，会报错。
② CHAR(5)表示最多存储5个字符。0≤M≤255,所以CHAR(M)最多定义255个字符。

CREATE TABLE test_char1
(
    f1 CHAR(255)
) CHARACTER SET = 'gbk';

-- 255个汉字，插入成功，如果再添加一个英文字符，则会因为超出范围而插入失败。
INSERT INTO test_char1 VALUES('好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节好雨知时节');
-- 输出字符个数
SELECT CHAR_LENGTH(f1) FROM test_char1;
-- 输出字节个数
SELECT LENGTH(f1) FROM test_char1;

③ CHAR(5)始终占5个字符的空间。存储空间固定，长度为M，就像高级语言中的数组。如果插入的字符串长度小于M，会右填充空格凑够M个字符。当读取字段时，MySQL会自动去除字符串尾部的空格。
CREATE TABLE test_char2
(
    f1 CHAR(5)
);
INSERT INTO test_char2 VALUES('袁腾飞  ');
SELECT CHAR_LENGTH(f1) FROM test_char2; -- 3 ,因为MySQL会把尾部的空格去除，无论是插入时字符串本身的，还是MySQL自动填充的。



# VARCHAR(M)
① M是存放的最大字符个数（注意:不是字节个数），不管是什么字符集，中文字符和英文字符都算一个字符。如果插入的字符串的长度大于M，会报错。
② CHAR(5)表示最多存储5个字符。M的最大值是什么？
mysql定义varchar类型虽然最大字节长度是65535，但并不是能存这么多数据，最大可以到65533，其中需要1到2个字节来存储数据的字节长度（如果列声明的长度超过255，则使用两个字节来存储长度，否则1个字节).
行中可以用的字节数如下计算：
varchar(65535) - 2 bytes (存储长度，按2个算) =65533 字节可以用.
根据这个最大字节数，以及编码方式，可以计算出M的最大值。
① 字段字符集若为gbk，每个字符最多占2个字节，M最大值不能超过65533 / 2 = 32766.5 ≈ 32766
② 字段字符集若为utf8mb3，每个字符最多占3个字节，M最大值不能超过65533 / 3 = 21844.5 ≈ 21844
③ 字段字符集若为utf8mb4，每个字符最多占4个字节，M最大值不能超过65533 / 4 = 16383.5 ≈ 16383
# 测试
CREATE TABLE test_varchar1
(
  -- f1 VARCHAR(32767)
	f1 VARCHAR(32766)
) CHARACTER SET = 'gbk' ;

CREATE TABLE test_varchar2
(
   -- f1 VARCHAR(21845)
	 f1 VARCHAR(21844)
) CHARACTER SET = 'utf8mb3' ;

CREATE TABLE test_varchar3
(
    -- f1 VARCHAR(16384)
	  f1 VARCHAR(16383)
) CHARACTER SET = 'utf8mb4' ;

还应当考虑一点，
MySQL要求一个行的所有字段定义长度不能超过65535个字节（64KB）[不包括TEXT、BLOB]。
-- Row size too large. The maximum row size for the used table type, not counting BLOBs, is 65535. This includes storage overhead, check the manual. You have to change some columns to TEXT or BLOBs
CREATE TABLE test_varchar1 -- (16383 × 2 + 2) + (16383 × 2 + 2) + 1 = 65537
(
    f1 VARCHAR(16383),
		f2 VARCHAR(16383),
		f3 TINYINT
) CHARACTER SET = 'gbk' ;

-- Row size too large. The maximum row size for the used table type, not counting BLOBs, is 65535. This includes storage overhead, check the manual. You have to change some columns to TEXT or BLOBs
CREATE TABLE test_varchar2 -- (16383 × 2 + 2) + (16383 × 2 + 2) = 65536
(
    f1 VARCHAR(16383),
		f2 VARCHAR(16383)
) CHARACTER SET = 'gbk' ;

-- Row size too large. The maximum row size for the used table type, not counting BLOBs, is 65535. This includes storage overhead, check the manual. You have to change some columns to TEXT or BLOBs
CREATE TABLE test_varchar4 -- (16382 × 2 + 2) + (16382 × 2 + 2 ) + 4 = 65536
(
    f1 VARCHAR(16382),
		f2 VARCHAR(16382),
		f3 INT     
) CHARACTER SET = 'gbk' ;

-- OK
CREATE TABLE test_varchar3 -- (16382 × 2 + 2) + (16382 × 2 + 2 ) + 3 = 65535
(
    f1 VARCHAR(16382),
		f2 VARCHAR(16382),
		f3 SMALLINT     
) CHARACTER SET = 'gbk' ;

DESC test_varchar3;


-- OK
CREATE TABLE test_varchar4 -- 16383 × 4 + 2 = 65534
(
    f1 VARCHAR(16383)
) CHARACTER SET = 'utf8mb4' ;

SELECT CHAR_LENGTH(f1),LENGTH(f1) FROM test_varchar4;






CHAR(M)和VARCHAR(M)选型建议:

阿里巴巴开发规范：
①CHAR(M)的性能比较高，但是如果存储的字符串的长度相差很大，会浪费很多存储空间。
所以，如果可能存储的字符串长度相同或几乎都相同（电话号码，身份证），或比较短(1-3个字符，VARCHAR不适合短字符串，因为它存储长度都需要一个字节，而CHAR不需要存储长度)（门牌号）建议使用CHAR。其他情况建议使用VARCHAR(M)。

②VARCHAR 是可变长字符串，不预先分配存储空间，长度不要超过 5000，因为某个字段太大，一是容易产生文件碎片，二是影响加载单条记录的时长。如果存储长度大于此值，定义字段类型为TEXT或BLOB，独立出来一张表，用主键来对应。

③VARCHAR(M)的M无论是多大，存储其内的字符串占用的空间是其实际的大小，所以，即使M的值远远大于实际可能存储的字符串的最大长度，也不会浪费磁盘的存储空间。但是我们并不能随意定义M的大小，推荐M的长度是最大长度的100%-110%。假设VARCHAR(100)与VARCHAR(200)类型，实际存90个字符，它不会对存储端产生影响（就是实际占用硬盘是一样的）。但是，它却会对查询产生影响，因为当MySql创建临时表（SORT，ORDER等）时，VARCHAR会转换为CHAR，转换后的CHAR的长度就是varchar的长度M，在内存中会为每行记录的此字段分配M长度【并不是实际长度】的内存，在排序、统计时候需要扫描的就越多，时间就越久。














# ENUM
字段的值只可能是ENUM定义的字符串之一。（如果未加非空约束，可以为NULL）
CREATE TABLE test_enum(
	f1 ENUM('春','夏','秋','冬') NOT NULL
);

--  Data truncated for column 'f1' at row 1
INSERT INTO test_enum VALUES('寒');

INSERT INTO test_enum VALUES('春');

应用场景：性别字段只允许存储男或女，其他字符都是不合理的。

# SET
字段的值只可能是SET定义的字符串中的一个或多个。（如果未加非空约束，可以为NULL）
CREATE TABLE test_set(
	f1 SET('春','夏','秋','冬') NOT NULL
);
-- Data truncated for column 'f1' at row 1
INSERT INTO test_set VALUES('寒,春');

INSERT INTO test_set VALUES('春,夏');
INSERT INTO test_set VALUES('春,夏,冬');
INSERT INTO test_set VALUES('冬');

SELECT * FROM test_set;


# JSON
【1】JSON 类型是 MySQL 5.7版本新增的数据类型，使用 JSON 数据类型，推荐用 MySQL 8.0.17 以上的版本，性能更好。
【2】JSON 数据类型的好处是无须预先定义列，可以多个类别的信息存储到一个字段。
【3】JSON类型非常适合，项目需求不确定，有些信息在未来可能需要显示，可以把不确定的，扩展的，不常被查询的多个字段作为JSON类型存储到一个字段中。
【4】不要将有明显必须存储的数据用JSON存储，如用户余额、用户姓名、用户身份证等，这些都是每个用户必须包含的数据；说到底，JSON类型再好，也没单个字段功能强。

CREATE TABLE test_json(
	js JSON
);

INSERT INTO test_json (js)
VALUES ('{"name":"雄霸", "age":18, "address":{"province":"beijing","city":"beijing"}}');

SELECT * FROM test_json;

SELECT js -> '$.name' AS NAME,js -> '$.age' AS age ,js -> '$.address.province'
AS province, js -> '$.address.city' AS city
FROM test_json;

-- JSON类型支持更新局部和灵活的查询，可以在项目中需要的时候查看相关资料。


