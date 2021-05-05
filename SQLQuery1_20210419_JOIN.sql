--CH3.(2) JOIN 기능 사용하기--

USE EDU

--INNER JOIN : 공통된 요소들을 통해 결합하는 조인 방식
--[MEMBER] 및 [ORDER] 테이블 공통 값(mem_no) 결합

SELECT *
FROM [Member] AS A --[Member] 테이블 별칭 A로 생성
INNER
JOIN [ORDER] AS B --[Order] 테이블 별칭 B로 생성
ON A.mem_no = B.mem_no --ON 연결조건 : 공통 값(mem_no) 결합

--OUTER JOIN : 매칭 안되는 데이터도 조회하는 명령어 (기준점에 따라 Left, Right, Full JOIN)
--(1) LEFT JOIN : 왼쪽 기준 데이터 조회
--[Member] 및 [Order] 테이블 공통 값(mem_no) 결합 + 매칭 안되는 [Member]데이터 조회
SELECT *
FROM [Member] A
LEFT JOIN [Order] B
ON A.mem_no = B.mem_no
/*가입 후 주문 이력이 없는 데이터들이 조회됨*/

--(2) RIGHT JOIN : 오른쪽 기준 데이터 조회
SELECT *
FROM [Member] A
RIGHT JOIN [Order] B 
ON A.mem_no = B.mem_no

--(3) FULL JOIN : 양쪽 테이블 기준 데이터 조회
SELECT *
FROM [Member] A
FULL JOIN [Order] B
ON A.mem_no = B.mem_no

--OTEHR(CROS, SELF) JOIN
/* CROSS JOIN 두 테이블(A,B)의 행을 결합
SELF JOIN 한 테이블(A)의 행과 다른 행들을 결합*/
--(1) CROSS JOIN
--[Member]행 x [Order]행

SELECT *
FROM [Member] A
CROSS JOIN [Order] B
WHERE A.mem_no = '1000001'

--(2) SELF JOIN
--[Member]행 x [Member]행
SELECT *
FROM [Member] A, [Member] B
WHERE A.mem_no = '1000001'