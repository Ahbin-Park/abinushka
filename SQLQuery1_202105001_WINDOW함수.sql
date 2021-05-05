--CH.4-1-4 윈도우 함수
--기본 형태 : 윈도우함수 + OVER(ORDER BY열 ASC / DESC) PARTITION BY는 옵션

--(1) 순위함수
--ORDER BY
--*ROW_NUMBER(): 고유한 순위 반환(1,2,3,4...)
--*RANK(): 동일한 순위 반환 (1,1,1,4...)
-- DENSE_RANK(): 동일한 순위 반환 (1,1,1,3 하나의 등수로 간주)

USE EDU
SELECT order_date
		, ROW_NUMBER() OVER (ORDER BY order_date ASC) AS ROW_NUMBER

		, RANK() OVER (ORDER BY order_date ASC) AS RANK -- 동일날짜에 대해 동일한 순위를 반환, 개별 건으로 하나씩 카운트 함.

		, DENSE_RANK() OVER (ORDER BY order_date ASC) AS DENSE_RANK -- 동일 날짜 동일 순위 반환하되, 같은 날짜는 하나의 건(등수)로 간주
FROM [Order]

--ORDER BY + PARTITION BY : PARTITION 별로 따로 카운팅 됨
SELECT mem_no
		,order_date
		,ROW_NUMBER() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS ROW_NUMBER

		,RANK() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS RANK

		,DENSE_RANK() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS DENSE_RANK
FROM [Order]

--(2) 집계함수(누적)
--ORDER BY(+PARTITION BY) 열 기준으로 행과 행간의 누적집계 반환

SELECT order_date
		,sales_amt
		,COUNT(sales_amt) OVER (ORDER BY order_date ASC) AS 구매횟수
		,SUM(sales_amt) OVER (ORDER BY order_date ASC) AS 구매금액
		,AVG(sales_amt) OVER (ORDER BY order_date ASC) AS 평균구매금액
		,MAX(sales_amt) OVER (ORDER BY order_date ASC) AS 가장높은구매금액
		,MIN(sales_amt) OVER (ORDER BY order_date ASC) AS 가장낮은구매금액
FROM [Order]

--ORDER BY + PARTITION BY: mem_no열 별로 구분되어 누적 집계 조회됨(PARTITION BY mem_no)
SELECT mem_no
		,order_date
		,sales_amt
		,COUNT(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 구매횟수
		,SUM(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 구매금액
		,AVG(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 평균구매금액
		,MAX(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 가장높은구매금액
		,MIN(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 가장낮은구매금액
FROM [Order]


--CH.4-1-5 집합 연산자
--합집합 UNION, 합집합 UNION ALL(중복 2), 교집합 INTERSECT, 차집합 EXCEPT
 USE EDU
 
--UNION: 두 테이블을 합집합 형태로 결과 반환
SELECT *
FROM [Member_1]
UNION
SELECT *
FROM [Member_2]

--UNION ALL: 두 테이블을 합집합 형태로 반환, 중복된 행 그대로 반환
SELECT *
FROM [Member_1]
UNION ALL
SELECT *
FROM [Member_2]

--INTERSECT: 교집합. 중복된 행 하나의 행으로 반환.
SELECT *
FROM [Member_1]
INTERSECT
SELECT *
FROM [Member_2]

--EXCEPT: 차집합. 중복된 행 하나의 행으로 반환. (MEMBER_1 - MEMBER_2)
SELECT *
FROM [Member_1]
EXCEPT
SELECT *
FROM [Member_2]
 
