--CH.4-2-1 효울화 & 자동화에 필요한 SQL 문법
--2-1. VIEW

USE EDU

--(1) VIEW 생성
--VIEW: 가상 테이블 OR 저장된 SQL 명령어
--자주 사용하는 SQL명령어를 저장함으로써 효율적인 SQL 명령어 실행

 CREATE VIEW [Order_Member]
 AS
 SELECT A.*
		,B.GENDER
		,B.ageband
		,B.Join_date
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no

--(2) VIEW 조회
USE EDU
SELECT *
FROM [Order_Member]

--(3) VIEW 수정
ALTER VIEW [Order_Member]
AS
SELECT A.*
		,B.gender
		,B.ageband
		,B.join_date
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
WHERE A.channel_code = 1

USE EDU
SELECT *
FROM [Order_Member]

--(4) VIEW 삭제

DROP VIEW [Order_Member]

--2-2. PROCEDURE : 매개변수의 활용
--(1)PROCEDURE 생성

USE EDU

CREATE PROCEDURE [Order_Member]
(
@channel_code AS INT --@매개변수 : 데이터형식 지정
)
AS
SELECT *
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
WHERE A.channel_code = @channel_code

--(2) PROCEDURE 실행
EXEC [Order_Member] 3 --channel_code가 3인 값으로 조회 실행해줌

--(3) PROCEDURE 수정
ALTER PROCEDURE [Order_Member]
(
@channel_code AS INT
,@YEAR_order_date AS INT
) 
AS
SELECT *
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
WHERE A.channel_code = @channel_code
AND YEAR(order_date) = @YEAR_order_date

EXEC [Order_Member] 3, 2021

--(4) PROCEDURE 삭제
DROP PROCEDURE [Order_Member]


--3-1. 데이터마트(DM) 생성하기
--데이터 마트(Data Mart)란? 분석 목적에 맞게 가공한 분석용 데이터 세트

USE EDU
--[분석 목적: 2020년도 주문금액 및 건수를 회원 프로파일 별로 확인]
--1. [Order] 테이블의 mem_no 별 sales_amt 합계 및 order_no 의 개수
--*조건: [order_date]는 2020년
--*열 이름 : [sales_amt] 합계는 tot_amt / [order_no] 개수는 tot_tr

SELECT mem_no
		,SUM(sales_amt) AS tot_amt
		,COUNT(order_no) AS tot_tr
FROM [Order]
WHERE YEAR(order_date) = 2020
GROUP BY mem_no

--2.[Member] 테이블을 왼쪽으로 하여 (1)테이블 LEFT JOIN
SELECT A.* ,B.tot_amt, B.tot_tr
FROM [Member] A
LEFT JOIN (
			SELECT mem_no
			,SUM(sales_amt) AS tot_amt
			,COUNT(order_no) AS tot_tr
			FROM [Order]
			WHERE YEAR(order_date) = 2020
			GROUP BY mem_no
			) B
		ON A.mem_no = B.mem_no

--3.(2)을 활용하여 구매여부 열 추가
SELECT A.*
		,B.tot_amt
		,B.tot_tr
		,CASE WHEN B.mem_no IS NOT NULL THEN '구매자'
			  ELSE '미구매자' END AS pur_yn
FROM [Member] A
LEFT JOIN (
			SELECT mem_no
			,SUM(sales_amt) AS tot_amt
			,COUNT(order_no) AS tot_tr
			FROM [Order]
			WHERE YEAR(order_date) = 2020
			GROUP BY mem_no
			) B
		ON A.mem_no = B.mem_no
		 
--4.  (3) 테이블 결과 생성
SELECT A.*
		,B.tot_amt
		,B.tot_tr
		,CASE WHEN B.mem_no IS NOT NULL THEN '구매자'
			  ELSE '미구매자' END AS pur_yn
INTO [MART_2020] --데이터마트 생성
FROM [Member] A
LEFT JOIN (
			SELECT mem_no
			,SUM(sales_amt) AS tot_amt
			,COUNT(order_no) AS tot_tr
			FROM [Order]
			WHERE YEAR(order_date) = 2020
			GROUP BY mem_no
			) B
		ON A.mem_no = B.mem_no

--3-2. 데이터 정합성

USE EDU

--[MART_2020] 데이터마트 정합성 체크
--1.데이터 마트 회원수 중복은 없는가? 
--*DISTINCT 는 중복된 값을 제거하고 고유한 값만 반환함 
SELECT COUNT(mem_no) AS 회원수
		,COUNT(DISTINCT mem_no) AS 회원수_중복제거
FROM [MART_2020]

--2.[member]테이블과 [MART_2020] 데이터 마트 회원수 차이는 없는가?
SELECT COUNT(mem_no) AS 회원수
		,COUNT(DISTINCT mem_no) AS 회원수_중복제거
FROM [Member]

--3. [member]테이블과 [MART_2020] 데이터 마트 주문수 차이는 없는가?
SELECT COUNT(order_no) AS 주문수
		,COUNT(DISTINCT order_no) AS 주문수_중복제거
FROM [Order]
WHERE YEAR(order_date) = 2020

--4. [MART_2020] 데이터마트 미구매자는 [Order] 테이블에서 2020년에 구매가 없는가?
SELECT *
FROM [Order]
WHERE mem_no IN (SELECT mem_no FROM [MART_2020] WHERE pur_yn = '미구매자')
AND YEAR(order_date) = 2020