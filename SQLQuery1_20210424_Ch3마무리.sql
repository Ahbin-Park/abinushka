Ch4-2. 데이터조회(SELECT) + 결합(JOIN) + 서브쿼리(SUB QUERY)

--Order 테이블 기준으로 Member 테이블을 left 조인하여라

USE EDU
SELECT *
FROM [Order] AS A
LEFT JOIN [Member] AS B 
ON A.mem_no = B.mem_no

--gender별 sales_amt 합계를 구해라 (tot_amt)
SELECT B.gender
		,SUM(sales_amt) AS tot_amt
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
GROUP BY B.gender

--gender, addr 별 sales_amt 합계를 구해라
SELECT B.gender
		,B.addr
		,SUM(sales_amt) AS tot_amt
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
GROUP BY B.gender
		,B.addr

--(1)Order 테이블의 mem_no별 sales_amt 합계 구하라
SELECT A.mem_no
	,SUM(sales_amt) as tot_amt
FROM [Order] A
GROUP BY mem_no

--(2) (1)을 FROM 서브쿼리 사용하여, Member 테이블을 LEFT JOIN하라
SELECT *
	FROM(
		SELECT A.mem_no
				,SUM(sales_amt) as tot_amt
		FROM [Order] 
		GROUP BY mem_no
	)A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no

--(3) gender, addr별 tot_amt 구하라
SELECT *
SELECT B.gender
	,B.addr
	,SUM(tot_amt) AS 합계
FROM (
	SELECT mem_no
			,SUM(sales_amt) AS tot_amt
	FROM [Order]
	GROUP BY mem_no
	)A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
GROUP BY B.gender, B.addr