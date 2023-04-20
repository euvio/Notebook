# 在数学运算中，0不能用作除数，在MySQL中，一个数除以0为NULL。
SELECT 100 / 0;  -- NULL

# 比较运算符的结果是0或1或NULL,有NULL参与的时候会返回NULL，1为真，其他为假
SELECT * FROM employees WHERE 1 + NULL;

# 求集合中的最大值和最小值
SELECT LEAST('B','Z','A') AS 最小值,GREATEST('B','Z','A') AS 最大值;

# BETWEEN ... AND ...是连续的量，可以用<=和>=代替，IN和NOT IN适用于不连续的离散量，可以拆分成多个OR.
SELECT * FROM employees WHERE salary BETWEEN 6000 AND 8000; -- 包括边界
SELECT * FROM employees WHERE department_id IN(20,30,40);

-- LIKE模糊匹配 % 匹配至少0个字符  _ 匹配1个字符  转义字符\_ \% \\
# 查询姓名中含有字母a和字母e的员工
SELECT last_name FROM employees WHERE last_name LIKE '%a%' AND last_name LIKE '%e%';
# 查询姓名第二个字母是a的员工
SELECT last_name FROM employees WHERE last_name LIKE '_a%';
# 查询姓名第二个字母是_的员工
SELECT last_name FROM employees WHERE last_name LIKE '_\_%';

# 正则表达式
# MySQL的字符串匹配支持正则表达式。
regular expression
REGEXP
^a       以a开头
b$       以b结尾
.        匹配任意一个字符
[abc]    匹配1个a 或 b 或 c
[a-z]    匹配1个小写字母
[0-9]    匹配1个阿拉伯字母
X*       匹配任意数量的X
[0-9]*   匹配任意数量的阿拉伯数字
# 查询姓名以字母e结尾的员工
SELECT last_name FROM employees WHERE last_name REGEXP 'e$';
SELECT last_name FROM employees WHERE last_name LIKE '%e';

NOT OR AND XOR # 注意异或运算，很经典的逻辑运算符
SELECT employee_id,salary FROM employees WHERE salary > 6000 XOR employee_id > 60;

# 位运算符
&  按位与
|  按位或
~  按位取反 ~255  11111111  00000000
^  按位异或
<<  左移
>>  右移