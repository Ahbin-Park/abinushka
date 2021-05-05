--CH3.(3) 서브 쿼리(Sub query)--

--SELECT절
SELECT *
	, (SELECT gender
		FROM [Member] B
		WHERE A.mem_no = B.mem_no) AS gender
	FROM [Order] A

--FROM 절
SELECT *
	FROM(
		SELECT mem_no
				,SUM(sales_amt) AS tot_amt --SUM을 통해 주문금액(sales_amt) 합을 구한다.
		FROM [Order]
		GROUP BY mem_no
		) A
--FROM 절 서브쿼리 + LEFT JOIN
SELECT *
	FROM (
		SELECT mem_no
				,SUM(sales_amt) AS tot_amt
		FROM [Order]
		GROUP BY mem_no
		) A
	LEFT JOIN [Member] B
	ON A.mem_no = B.mem_no --서브쿼리(A)와 [Member] 데이터 간의 공통값(mem_no)이 매칭되는 데이터만 조회됨

--WHERE 절 (=일반 서브쿼리) : 단일 or 다중
--단일 행 : 서브쿼리 결과가 단일 행
SELECT *
FROM [Order]
WHERE mem_no = (SELECT mem_no FROM [Member] WHERE mem_no = '1000005')
--단일 행 확인
SELECT mem_no FROM [Member] WHERE mem_no = '1000005'

--다중 행 : 서브쿼리 결과가 다중 행
SELECT *
FROM [Order]
WHERE mem_no IN (SELECT mem_no FROM [Member] WHERE gender = 'man') --IN 연산자: 리스트의 값 중 하나라도 일치하면 되는 특수 연산자
--다중 행 확인
SELECT mem_no FROM [Member] WHERE gender = 'man'


--마치며(연습문제)--
--(1) SELECT, FROM : [Order] 테이블의 모든 컬럼 조회
SELECT *
FROM [Order]

--(2) WHERE : [shop_code]는 30 이상으로만 필터링
SELECT *
FROM [Order]
WHERE shop_code >= 30

--(3) GROUP BY (+SUM함수) : [mem_no]별 [sales_amt] 합계 구하라
SELECT mem_no
	,SUM(sales_amt) AS tot_amt
FROM [Order]
WHERE shop_code >= 30 -- 여기 챙겨넣어줘야함
GROUP BY mem_no

--(4) **HAVING : [sales_amt] 합계 100000 이상만 필터링
SELECT mem_no
	,SUM(sales_amt) AS tot_amt 
FROM [Order]
WHERE shop_code >= 30 --*여기 챙겨넣어줘야함
GROUP BY mem_no
HAVING SUM(sales_amt) >= 100000 --*having 명령어 

--(5) ORDER BY(+DESC) : [sales_amt] 합계가 높은 순으로 정렬
SELECT mem_no
	,SUM(sales_amt) AS tot_amt
FROM [Order]
WHERE shop_code >= 30 --*여기 챙겨넣어줘야함
GROUP BY mem_no
HAVING SUM(sales_amt) >= 100000 --*having 명령어 
ORDER BY SUM(sales_amt) DESC

