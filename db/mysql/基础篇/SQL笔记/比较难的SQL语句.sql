CREATE TABLE IF NOT EXISTS books(
id INT ,
`name` VARCHAR(50) COMMENT '书名',
`authors` VARCHAR(100) COMMENT '作者',
price FLOAT,
pubdate YEAR COMMENT '出版日期',
note VARCHAR(100) COMMENT '类别' ,
num INT COMMENT '库存'
);

# 17、查询书名、库存，其中num值超过30本的，显示滞销，大于0并低于10的，
#显示畅销，为0的显示需要无货
SELECT NAME AS "书名",num AS "库存", CASE WHEN num > 30 THEN '滞销'
					  WHEN num > 0 AND num < 10 THEN '畅销'
					  WHEN num = 0 THEN '无货'
					  ELSE '正常'
					  END "显示状态"
FROM books;

# 18、统计每一种note的库存量，并合计总量
SELECT IFNULL(note,'合计库存总量') AS note,SUM(num)
FROM books
GROUP BY note WITH ROLLUP;