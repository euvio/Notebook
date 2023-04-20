# 日期和时间
| 类型         | 含义     | 存储字节 | 格式                | 最小值                              | 最大值                  |
| ------------ | -------- | -------- | ------------------- | ----------------------------------- | ----------------------- |
| YEAR         | 年       | 1        | YYYY                | 1901                                | 2155                    |
| DATE         | 日期     | 3        | YYYY-MM-DD          | 0000-01-01                          | 9999-12-31              |
| TIME(N)      | 时间     | 3        | HH:MM:SS            | -838:59:59.999999                   | 838:59:59.999999        |
| DATETIME(N)  | 日期时间 | 8        | YYYY-MM-DD HH:MM:SS | 1000-01-01 00:00:00                 | 9999-12-31 23:59:59     |
| TIMESTAMP(N) | 时间戳   | 4        | YYYY-MM-DD HH:MM:SS | 1970-01-01 00:00:00 UTC             | 2038-01-19 03:14:07 UTC |

① 为什么时间类型 TIME 的取值范围不是 -23:59:59～23:59:59 呢？原因是MySQL设计的TIME类型，不光表示一天之内的某个时刻，而且可以用来表示一个时间间隔，这个时间间隔可以超过 24 小时，相当于C#中的TimeSpan.
② TIME(N), DATETIME(N), TIMESTAMP(N)的N表示毫秒，示例：TIME(4)  02:26:59.4573,    DATETIME(6)    2021-03-26 17:17:30.123456,   TIMESTAMP(0) 或 TIMESTAMP    2022-08-15 13:12:45,  N是3时表示毫秒，N是6时表示微秒，N的最大值是6. 不需要毫秒时，建表指定类型时不带(N) 如 DATETIME 或 DATETIME(0) 即可。


# YEAR
CREATE TABLE test_year
(
	f1 YEAR
) ENGINE = INNODB CHARACTER SET = utf8mb4;

# 应用程序生成时间
INSERT INTO test_year
VALUES('2021');

INSERT INTO test_year
VALUES('1901');

INSERT INTO test_year
VALUES('2155');

-- Out of range value for column 'f1' at row 1
INSERT INTO test_year
VALUES('2156');

-- MySQL服务器自动生成当前时刻
INSERT INTO test_year
VALUES(CURRENT_DATE());

SELECT * FROM test_year;

-- 插入YEAR时，格式是'YYYY'，必须是长度为4的数字字符串，使用单引号括住，MySQL会将字符串隐式转换成YEAR。另外需要注意存储范围是1901-2155，超出此范围会插入数据失败



# DATE
CREATE TABLE test_date
(
	f1 DATE
) ENGINE = INNODB CHARACTER SET = utf8mb4;

-- 应用程序生成时间插入数据库
INSERT INTO test_date VALUES('2021-05-20');
INSERT INTO test_date VALUES('0000-01-01');
INSERT INTO test_date VALUES('0086-01-01');
INSERT INTO test_date VALUES('9999-12-31');
# Incorrect date value: '10000-01-01' for column 'f1'
INSERT INTO test_date VALUES('10000-01-01');
-- 数据库服务器生成时间插入数据库
INSERT INTO test_date VALUES(CURRENT_DATE());

SELECT * FROM test_date;
-- 插入DATE时，格式是'YYYY-MM-DD'，必须是长度为10的字符串，使用单引号括住，MySQL会将字符串隐式转换成DATE。

# TIME(N)
CREATE TABLE test_time
(
	f1 TIME(4)
) ENGINE = INNODB CHARACTER SET = utf8mb4;

-- 应用程序生成时间插入数据库
INSERT INTO test_time
VALUES('02:47:23.7698');

INSERT INTO test_time
VALUES('20:30:30');

-- 数据库服务器生成时间插入数据库
INSERT INTO test_time
VALUES(CURRENT_TIME());

INSERT INTO test_time
VALUES(CURRENT_TIME(4));

SELECT * FROM test_time;

-- 插入TIME时，格式是HH:MM:SS' 或 'HH:MM:SS.FFF...，使用单引号括住，MySQL会将字符串隐式转换成TIME。如果插入需要带毫秒的系统时间，可以CURRENT_TIME(4)。


# DATETIME(N) N:0,1,2,3,4,5,6 最大只能是6,最常用N值是3，精确到毫秒
DROP TABLE IF EXISTS test_datetime;

CREATE TABLE test_datetime
(
	f1 DATETIME(3)
) ENGINE = INNODB CHARACTER SET = utf8mb4;

-- 应用程序生成时间插入数据库
SET @@session.time_zone = '+10:00';

INSERT INTO test_datetime
VALUES('2022-06-17 02:47:23.123');

SET @@session.time_zone = '+8:00';

INSERT INTO test_datetime
VALUES('2022-06-17 02:47:23.123');

SET @@session.time_zone = '+9:00';

SELECT * FROM test_datetime;
+-------------------------+
| f1                      |
+-------------------------+
| 2022-06-17 02:47:23.123 |
| 2022-06-17 02:47:23.123 |
+-------------------------+
2 rows in set (0.00 sec)

-- 时间字符串的格式是yyyy-MM-dd HH:mm:ss.fff,严格遵守，缺位补0. MySQL将字符串隐式转换成DATETIME类型插入字段。
-- 应用程序提供什么时刻字符串，MySQL便存储什么时刻字符串,MySQL把外界传入的时刻字符串当作普通字符串，不受任何因素【连接字符串的时区，MySQL服务器的操作系统的时区】的影响，原封不动的存储到数据表。
-- 应用程序提供什么时刻,只是一个普通的字符串，没有时区信息，MySQL不会考虑转换成连接字符串的时区，因为它不知道应用程序提供的普通时间字符串的时区，没法转换。
-- MySQL读取DATETIME时，由于DATETIME没有时区信息，所以MySQL也不会考虑转换成连接字符串的时区，存储的是什么时间字符串就取出什么时间字符串
-- 简而言之，插入什么，存储什么。存储什么，取出什么。

-- 毫秒位数多于定义，自动四舍五入
INSERT INTO test_datetime
VALUES('2022-06-17 02:47:23.1236');
SELECT * FROM test_datetime;

-- 毫秒如果是0，有以下两种插入方式
INSERT INTO test_datetime
VALUES('2022-06-17 20:30:30');

INSERT INTO test_datetime
VALUES('2022-06-17 20:30:30.000');
+-------------------------+
| f1                      |
+-------------------------+
| 2022-06-17 02:47:23.123 |
| 2022-06-17 02:47:23.123 |
| 2022-06-17 02:47:23.124 |
| 2022-06-17 20:30:30.000 |
| 2022-06-17 20:30:30.000 |
+-------------------------+
5 rows in set (0.00 sec)

-- 数据库服务器生成时间插入数据库

SET @@session.time_zone = '+10:00';

INSERT INTO test_datetime
VALUES(NOW());

SET @@session.time_zone = '+8:00';

INSERT INTO test_datetime
VALUES(NOW());

SELECT * FROM test_datetime;
+-------------------------+
| f1                      |
+-------------------------+
| 2022-07-02 18:13:01.000 |
| 2022-07-02 16:13:28.000 |
+-------------------------+
-- 如果时间由MySQL服务器提供请使用NOW()。NOW()先获取MySQL服务器的操作系统的时区的时间，再转换成当前连接字符串的时区的时间，得到最终的时间字符串存储到数据库。如果没有在连接字符串中设置时区，默认使用数据库配置文件中的time_zone配置的时区，默认情况下time_zone=SYSTEM,与操作系统时区保持一致。

SET @@session.time_zone = '+5:00';

SELECT * FROM test_datetime;
+-------------------------+
| f1                      |
+-------------------------+
| 2022-07-02 18:13:01.000 |
| 2022-07-02 16:13:28.000 |
+-------------------------+
-- DATETIME字段存储的时间字符串，无时区信息，所以读取时，存储什么便拿到什么，不存在时区转换，不受连接字符串的时区影响。

INSERT INTO test_datetime
VALUES(NOW(3));

SELECT * FROM test_datetime;
+-------------------------+
| f1                      |
+-------------------------+
| 2022-07-02 16:21:19.127 |
+-------------------------+
8 rows in set (0.00 sec)
-- 插入毫秒使用NOW(3)


















# TIMESTAMP(N) N:0,1,2,3,4,5,6 最大只能是6,最常用N值是3，精确到毫秒

DROP TABLE IF EXISTS test_timestamp;

CREATE TABLE test_timestamp
(
	f1 DATETIME(3),
	f2 TIMESTAMP(3)
) ENGINE = INNODB CHARACTER SET = utf8mb4;

-- 应用程序生成时间插入数据库
SET @@session.time_zone = '+5:00';
INSERT INTO test_timestamp VALUES('2022-02-21 21:21:21','2022-02-21 21:21:21');
SET @@session.time_zone = '+8:00';
+-------------------------+-------------------------+
| f1                      | f2                      |
+-------------------------+-------------------------+
| 2022-02-21 21:21:21.000 | 2022-02-22 00:21:21.000 |
+-------------------------+-------------------------+
1 row in set (0.00 sec)

SELECT * FROM test_timestamp;
SET @@session.time_zone = '-8:00';
SELECT * FROM test_timestamp;
+-------------------------+-------------------------+
| f1                      | f2                      |
+-------------------------+-------------------------+
| 2022-02-21 21:21:21.000 | 2022-02-21 08:21:21.000 |
+-------------------------+-------------------------+
1 row in set (0.00 sec)

-- 插入TIMESTAMP格式是'YYYY-MM-DD HH:MM:SS' 或 'YYYY-MM-DD HH:MM:SS.FFF...'，使用单引号括住，MySQL会将字符串隐式转换成TIMESTAMP。
-- 应用程序提供时间字符串时，MySQL会认为你提供的时间属于当前连接字符串的时区，先将时间转换成0时区的时间再存储到表中。
-- 读取TIMESTAMP时，将存储的时间(认为是0时区的时间)转换成当前连接字符串的时区的时间再返回。
-- TIMESTAMP存储的时间一律认为是0时区的时间。

-- 数据库服务器生成时间插入数据库
DELETE FROM test_timestamp;
SET @@session.time_zone = '+11:00';
INSERT INTO test_timestamp VALUES(NOW(3),CURRENT_TIMESTAMP(3));
INSERT INTO test_timestamp VALUES(NOW(),CURRENT_TIMESTAMP());

SET @@session.time_zone = '+0:00';
SELECT * FROM test_timestamp;
+-------------------------+-------------------------+
| f1                      | f2                      |
+-------------------------+-------------------------+
| 2022-07-02 20:11:44.915 | 2022-07-02 09:11:44.915 |
| 2022-07-02 20:11:51.000 | 2022-07-02 09:11:51.000 |
+-------------------------+-------------------------+
2 rows in set (0.00 sec)

SET @@session.time_zone = '+1:00';
SELECT * FROM test_timestamp;
+-------------------------+-------------------------+
| f1                      | f2                      |
+-------------------------+-------------------------+
| 2022-07-02 20:11:44.915 | 2022-07-02 10:11:44.915 |
| 2022-07-02 20:11:51.000 | 2022-07-02 10:11:51.000 |
+-------------------------+-------------------------+
2 rows in set (0.00 sec)

-- 如果插入需要带毫秒的系统时间，可以CURRENT_TIMESTAMP(3)，如果插入不需要毫秒的系统时间可以用CURRENT_TIMESTAMP()。
-- 如果时间由MySQL服务器提供，CURRENT_TIMESTAMP()先获取服务器的操作系统的时区的时间，再转换成世界协调时0时区的时间[并不会考虑连接字符串的时区]，再转换成距离世界协调时0时区的1970-01-01的毫秒整数，最后将此整数存储到数据库。
-- 读取时，将整数先转换成世界协调时0时区的时间，再转换成数据库连接字符串的使用的时区的时间。



比较DATETIME和TIMESTAMP
① 存储空间
   DATETIME始终占用8个字节，TIMESTAMP不存储毫秒占用4个字节，存储毫秒占用7个字节
② 表示范围
  DATETIME 0000-01-01 ~ 9999-12-31   TIMESTAMP 1970-01-01 ~ 2038-01-19 03:14:07
③ 存储形式
  DATETIME 字符串形式
  TIMESTAMP 时间戳类型，其实际存储的内容为0时区‘1970-01-01 00:00:00’到现在的毫秒数,整数形式
④ 性能
  读取TIMESTAMP时会调用系统内核获取时区，这个过程存在一个锁，导致性能比DATETIME略低。

选型建议：
建议选择DATETIME。因为MySQL只是用4个字节存储TIMESTAMP，导致时间只能存储到2038年。
DATETIME虽说无时区信息，但是规范应用层开发，就可以克服。
① 开发人员约定DATETIME存储的时区必须是某个时区的时间，假设采用东8区.
② 设置MySQL服务器操作系统的时区是东8区，设置MySQL的配置文件的time_zone=+8:00.
③ MySQL服务器启动后，不要设置全局变量@@time_zone，使其保持为东8区
④ 如果是应用层提供时间存储到表中，开发者保证：应用层获取的时间(应用运行的主机的时区)转换成东8区的时间再发送到MySQL存储。
⑤ 应用层从MySQL获取时间时，将获取的时间认为是东八区的时间，转换成用户所在的时区的时间显示即可。


# 记录被更新时，自动记录记录最后一次被更新的时间
# 默认插入当前时间

CREATE TABLE test_datetime_timestamp(
    f1 INT NOT NULL,
		register_date1 TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		last_modify_date1 TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		register_date2 DATETIME DEFAULT NOW(),
		last_modify_date2 DATETIME DEFAULT NOW() ON UPDATE NOW()
);

INSERT INTO test_datetime_timestamp(f1)VALUES(100);
SELECT * FROM test_datetime_timestamp;

UPDATE test_datetime_timestamp SET f1=200 WHERE f1 = 100;
SELECT * FROM test_datetime_timestamp;

-- 表结构设计时，每个核心业务表，推荐设计一个 last_modify_date 的字段，用以记录每条记录的最后修改时间。






























