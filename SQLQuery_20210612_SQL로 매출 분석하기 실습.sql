--1-1 DATAMART 구성하기
USE EDU
SELECT A.*
	,B.prod_cd
	,B.quantity
	,D.price
	,B.quantity * D.price AS sales_amt
	,C.store_addr
	,D.brand
	,D.model
	,E.gender
	,E.age
	,E.addr
	,E.join_date
INTO [Car_MART]
FROM [Car_order] A
LEFT JOIN [Car_orderdetail] B ON A.order_no = B.order_no
LEFT JOIN [Car_store] C ON A.store_cd = C.store_cd
LEFT JOIN [Car_product] D ON B.prod_cd = D.prod_cd
LEFT JOIN [Car_member] E ON A.mem_no = E.mem_no


SELECT * FROM [Car_MART]

--1-2. 구매 고객 프로파일 분석
--(고객들의 성별, 연령, 지역 등으로 구매자 특징 및 특성 파악하기

--(1) 연령대 열 추가한 세션 임시 테이블 생성 #PROFILE_BASE
--*임시테이블이란, 영구적으로 테이블을 생성할 필요가 없을 때 임시로 사용하는 테이블
USE EDU
SELECT *
	,CASE WHEN age < 20 THEN '20대 미만'
		  WHEN age BETWEEN 20 AND 29 THEN '20대'
		  WHEN age BETWEEN 30 AND 39 THEN '30대'
		  WHEN age BETWEEN 40 AND 49 THEN '40대'
		  WHEN age BETWEEN 50 AND 59 THEN '50대'
		  ELSE '60대 이상' END AS ageband
INTO #PROFILE_BASE
FROM [Car_MART]

SELECT * FROM #PROFILE_BASE
		 
--(2) #PROFILE_BASE 테이블을 활용한 성별 및 연령대별 구매자 분포

--성별 구매자 분포
SELECT gender
		,COUNT(DISTINCT mem_no) AS tot_mem
FROM #PROFILE_BASE
GROUP BY gender

--연령대별 구매자 분포
SELECT ageband
		,COUNT(DISTINCT mem_no) AS tot_mem
FROM #PROFILE_BASE
GROUP BY ageband

--성별 및 연령대별 구매자 분포
SELECT gender
		, ageband
		, COUNT(DISTINCT mem_no) AS tot_mem
FROM #PROFILE_BASE
GROUP BY gender, ageband
ORDER BY 1

--(3) #PROFILE_BASE 테이블을 활용한 성별 및 연령대별 구매자 분포(+연도별)
SELECT gender, ageband
		, COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2020 THEN mem_no END) AS tot_mem_2020
		, COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2021 THEN mem_no END) AS tot_mem_2021
FROM #PROFILE_BASE
GROUP BY gender, ageband
ORDER BY 1

--1-3. RFM 고객세분화 분석
--RFM: 구매지표 (Recency 최근성, Frequency 구매빈도, Monetary 구매금액) 활용하여 고객 세분화
--(1) [Car_MART] 테이블에서 RFM 세션 임시 테이블 생성

SELECT mem_no
		,SUM(sales_amt) AS tot_amt --M:구매금액
		,COUNT(order_no) AS tot_tr --F: 구매빈도
INTO #RFM_BASE
FROM [Car_MART]
WHERE YEAR(order_date) BETWEEN 2020 AND 2021
GROUP BY mem_no

SELECT * FROM #RFM_BASE

--(2) 고객세분화 그룹 추가(구매금액 및 빈도기준)
SELECT A.*, B.tot_amt, B.tot_tr
		,CASE WHEN tot_amt >= 1000000000 AND tot_tr >= 3 THEN '1_VVIP'
			  WHEN tot_amt >= 500000000 AND tot_tr >= 2 THEN '2_VIP'
			  WHEN tot_amt >= 300000000 THEN '3_GOLD'
		  	  WHEN tot_amt >= 100000000 THEN '4_SILVER'
			  WHEN tot_tr >1 THEN '5_BRONZE'
			  ELSE '6_POTENTIAL' END AS segmentation
INTO #RFM_BASE_SEG
FROM [Car_member] A
LEFT JOIN #RFM_BASE B
ON A.mem_no = B.mem_no

--(3) 고객세분화별 고객 수 및 매출비중 파악
SELECT segmentation AS '회원등급',COUNT(mem_no) AS '멤버수', SUM(tot_amt) AS '구매금액' FROM #RFM_BASE_SEG
GROUP BY segmentation
ORDER BY 1

--1-4. 구매전환율 및 구매주기 분석
--(1) [Car_MART] 구매전환율 세션 임시테이블(#RETENTION_BASE) 생성


SELECT A.mem_no AS pur_mem_2020
		,B.mem_no AS pur_mem_2021
		,CASE WHEN B.mem_no IS NOT NULL THEN 'Y' ELSE 'N' END AS retention_yn
INTO #RETENTION_BASE
FROM (SELECT DISTINCT mem_no FROM [Car_MART] WHERE YEAR(order_date) = 2020) A
LEFT JOIN (SELECT DISTINCT mem_no FROM [Car_MART] WHERE YEAR(order_date) = 2021) B
ON A.mem_no = B.mem_no

--결과조회
SELECT * FROM #RETENTION_BASE
WHERE retention_yn = 'Y'

--(2) #RETENTION_BASE 구매전환율 파악 
SELECT COUNT(pur_mem_2020) AS tot_mem
		,COUNT(CASE WHEN retention_yn = 'Y' THEN pur_mem_2020 END) AS retention_mem
FROM #RETENTION_BASE

--(+) 매장코드별(store_cd) 구매주기
--(1) 구매주기 계산 = (최근 구매일-최초 구매일)/(구매횟수-1)을 위한 임시테이블 형성(CYCLE_BASE)

SELECT store_cd
		,MIN(order_date) AS min_order_date
		,MAX(order_date) AS max_order_date
		,COUNT(DISTINCT order_no) -1 AS tot_tr_1
INTO #CYCLE_BASE
FROM [Car_MART]
GROUP BY store_cd
HAVING COUNT(DISTINCT order_no) >= 2 --구매횟수 2회 이상 필터링 (구매횟수가 1회면 분모가 0이되기 때문 -> sql실행 오류)

SELECT * FROM #CYCLE_BASE

--(2) #CYCLE_BASE 활용한 구매주기 팡악
--매장코드 별 구매주기 구하기
SELECT *
		,DATEDIFF(DAY, min_order_date, max_order_date) AS diff_day
		,DATEDIFF(DAY, min_order_date, max_order_date)*1.00 / tot_tr_1 AS cycle -- *1.00 소수점자리까지 나타내기
FROM #CYCLE_BASE
ORDER BY 6 DESC

SELECT store_cd, DATEDIFF(DAY, min_order_date, max_order_date)*1.00 / tot_tr_1 AS cycle
FROM #CYCLE_BASE

--1-5. 제품 및 성장률 분석
--(1) BRAND, MODEL 별 2020~2021 구매금액 임시테이블 생성
SELECT brand, model
	   ,SUM(CASE WHEN YEAR(order_date)=2020 THEN sales_amt END) AS tot_amt_2020
	   ,SUM(CASE WHEN YEAR(order_date)=2021 THEN sales_amt END) AS tot_amt_2021
INTO #PRODUCT_GROWTH_BASE
FROM [Car_MART]
GROUP BY brand, model

SELECT *
FROM #PRODUCT_GROWTH_BASE

--(2) 브랜드별 성장률 파악
SELECT brand
		,SUM(tot_amt_2021) / SUM(tot_amt_2020) -1 AS growth
FROM #PRODUCT_GROWTH_BASE
GROUP BY brand
ORDER BY 2 DESC

--(3) 브랜드 및 모델별 성장률 파악(각 브랜드별 성장률  TOP2 모델만 파악)
SELECT *
FROM (	
	  SELECT * 
			 ,ROW_NUMBER() OVER(PARTITION BY brand ORDER BY growth DESC) AS rnk --브랜드별 rank 윈도우함수 활용
	  FROM (
			SELECT brand
					, model
		 			,SUM(tot_amt_2021) / SUM(tot_amt_2020) -1 AS growth
			FROM #PRODUCT_GROWTH_BASE
			GROUP BY brand, model
			) A
)B
WHERE rnk <=2