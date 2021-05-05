--CH4. [01] SELECT-- 
USE EDU

--FROM : [Member] 테이블 선택
SELECT *
FROM [Member]

--WHERE : GENDER 컬럼이 'MAN'으로만 필터링
WHERE gender = 'man'

--GROUP BY : addr  컬럼별로 회원[mem_no] 수 집계
SELECT addr
	,COUNT(mem_no) AS [회원수집계] --COUNT를 통해 회원 수를 구한다
FROM [Member]
WHERE gender = 'man'
GROUP BY addr 
HAVING COUNT(mem_no) >= 50 --HAVING 추가: addr 컬럼별로 회원(mem_no) 수가 50 이상만 필터링
ORDER BY COUNT(mem_no) DESC --내림차순으로 정렬 (오름차순은 ASC)

--CH4. [02] 결합(JOIN)--
/* ERM(Entity-Relationship Modelling)은 데이터를 구조화하여
데이터베이스에 저장하기 위한 개체-관계 모델링 기법*/

