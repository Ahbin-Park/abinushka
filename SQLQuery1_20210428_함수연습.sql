--CH.4-1-2 단일행함수
USE EDU

--CASE WHEN: 여러 조건별로 지정 값 변환
--조건 외 값은 NULL 반환
SELECT *
		, CASE WHEN ageband BETWEEN 20 AND 30 THEN '2030세대'
			   WHEN ageband BETWEEN 40 AND 50 THEN '4050세대'
			   END AS ageband_seg
FROM [Member]

--CASE WHEN(+ELSE)
--조건 외 값을 ELSE로 지정
SELECT *
		, CASE WHEN ageband BETWEEN 20 AND 30 THEN '2030세대'
			   WHEN ageband BETWEEN 40 AND 50 THEN '4050세대'
			   ELSE 'OTHER세대' END AS ageband_seg
FROM [Member]

--CH.4-1-3 복수행함수

--집계함수
USE EDU
SELECT COUNT(order_no) AS 주문수
		,SUM(sales_amt) AS 주문금액
		,AVG(sales_amt) AS 평균주문금액
		,MAX(order_date) AS 최근구매일자 
		,MIN(order_date) AS 최초구매일자
		,STDEV(sales_amt) AS 주문금액_표준편차
		,VAR(sales_amt) AS 주문금액_분산
	FROM [Order]

--집계함수+ GROUP BY (mem_no 열을 그룹으로 묶은 여러 행에 대한 집계함수)
SELECT mem_no
		,COUNT(order_no) AS 주문수
		,SUM(sales_amt) AS 주문금액
		,AVG(sales_amt) AS 평균주문금액
		,MAX(order_date) AS 최근구매일자 
		,MIN(order_date) AS 최초구매일자
		,STDEV(sales_amt) AS 주문금액_표준편차
		,VAR(sales_amt) AS 주문금액_분산
	FROM [Order]
GROUP BY mem_no

--그룹함수 (GROUP BY 항목들을 그룹으로 묶는 함수 : WITH ROLLUP, WITH CUBE, GROUPING SETS, GROUPING)

USE EDU
SELECT YEAR(order_date) AS 연도
		,channel_code AS 채널코드
		, SUM(sales_amt) AS 주문금액
FROM [Order]
GROUP BY YEAR(order_date) --YEAR: 날짜 형식의 데이터를 연도로 변환
		, channel_code
WITH ROLLUP ---GROUP BY 항목들을 오른쪽[channel_code]에서 왼쪽[YEAR(order_date)]순으로 그룹으로 묶음 (ROLL UP 안하는 경우, 채널코드의 NULL 값은 조회되지 않음)
ORDER BY 1 DESC, 2 ASC  --조회한 열 순서를 통해 행 정렬 (1열:내림차순, 2열:오름차순)


--WITH CUBE (group by 다음에 작성해야함)
---GROUP BY 항목들의 모든 경우의 수를 그룹으로 묶음
USE EDU
SELECT YEAR(order_date) AS 연도 --YEAR: 날짜 형식의 데이터를 연도로 변환
		,channel_code AS 채널코드
		,SUM(sales_amt) AS 주문금액
FROM [Order]
GROUP BY YEAR(order_date), channel_code
WITH CUBE -- 모든 경우의 수를 묶기 때문에,  WITH ROLL UP보다 상세 집계값이 조회됨
ORDER BY 1 DESC, 2 ASC

--GROUPING SETS
---GROUP BY 항목들을 개별 그룹으로 묶음
USE EDU
SELECT YEAR(order_date) AS 연도 --YEAR: 날짜 형식의 데이터를 연도로 변환
		,channel_code AS 채널코드
		,SUM(sales_amt) AS 주문금액
FROM [Order]
GROUP BY GROUPING SETS( YEAR(order_date), channel_code ) --각 항목에 대한 집계값이 조회됨

--GROUPING
---WITH ROLLUP 및 CUBE에 의해 그룹화되었다면 0, 그렇지 않으면 1을 반환 (1:NULL값이 1로 반환됨)
---WITH ROLLUP 함수에 주로 사용
USE EDU
SELECT YEAR(order_date) AS 연도
		,GROUPING(YEAR(order_date)) AS 연도_GROUPING

		,channel_code AS 채널코드
		,GROUPING(channel_code) AS 채널코드_GROUPING

		,SUM(sales_amt) AS 주문금액
FROM [Order]
GROUP BY YEAR(order_date), channel_code
WITH ROLLUP
ORDER BY 1 DESC, 2 ASC

--GROUPING 및 CASE WHEN을 활용한 총계 및 소계 변환

--(1) YEAR(order_date) 및 channel_code 숫자 -> 문자형 변환
SELECT CAST(YEAR(order_date) AS VARCHAR) AS 연도
		,CAST(channel_code AS VARCHAR) AS 채널코드
		,sales_amt
FROM [Order]

--(2) (1)을 서브쿼리로 하여, CASE WHEN으로 총계 및 소계 변환
SELECT CASE WHEN GROUPING(연도) = 1 THEN '총계'
			ELSE 연도 END AS 연도_총계

	  ,CASE WHEN GROUPING(연도) = 1 THEN '총계'
			WHEN GROUPING(채널코드) = 1 THEN '소계'
			ELSE 채널코드 END AS 채널코드_총소계
	  ,SUM(sales_amt) AS 주문금액
FROM (
	 SELECT CAST(YEAR(order_date) AS VARCHAR) AS 연도
			,CAST(channel_code AS VARCHAR) AS 채널코드
			,sales_amt
	FROM [Order]
	)A
GROUP BY 연도, 채널코드
WITH ROLLUP
ORDER BY 1 DESC, 2 ASC
