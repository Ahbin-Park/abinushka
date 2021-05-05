--테이블 생성(DDL)--

USE EDU

CREATE TABLE [회원테이블] (
[회원번호] VARCHAR(20) PRIMARY KEY,
[이름] VARCHAR(10),
[성별] VARCHAR(2),
[나이] INT,
[가입금액] MONEY,
[가입일자] DATE NOT NULL,
[수신동의] BIT
)

--데이터 조작(DML:DATA MANIPULATION LANGUAGE)--
--[회원테이블]에 데이터삽입(INSERT)
INSERT INTO [회원테이블] VALUES ('A10001', '모원서', '남', 33,100000, '2021-01-01', 1) ;
INSERT INTO [회원테이블] VALUES ('A10002', '박아빈', '여', 29,200000, '2021-01-02', 0) ;
INSERT INTO [회원테이블] VALUES ('A10003', '임종욱', '남', 29,300000, '2021-01-03', NULL) ;

--[회원테이블]에 모든 컬럼 조회(SELECT)
SELECT * --모든 컬럼
	FROM [회원테이블]
--[회원테이블]에 특정 컬럼명 조회 (임시로 컬럼명 변경하기 00 AS(ALIASES) KK)
SELECT [회원번호]
		,[이름] AS [성명] --AS는 생략 가능[이름][성명]
		,[가입일자]
		,[나이]
	FROM [회원테이블]
--모든 행을 조건 없이 [나이] 30으로 수정
UPDATE [회원테이블]
SET [나이] = 30 -- (변경할 열과 값을 설정)

--[회원테이블] 조회 및 수정되었는지 확인
SELECT * --모든 컬럼
FROM [회원테이블]

--[회원번호]가 'A10001'인 [나이] 34로 변경
UPDATE [회원테이블]
SET [나이] = 34
WHERE [회원번호] = 'A10001' --조건 달기

--[회원테이블] 조회 및 변경 확인
SELECT *
FROM [회원테이블]

--데이터삭제(DELETE)
--[회원테이블] 모든 행 데이터 삭제
DELETE
FROM [회원테이블]

--[회원테이블]에 데이터삽입(INSERT)
INSERT INTO [회원테이블] VALUES ('A10001', '모원서', '남', 33,100000, '2021-01-01', 1) ;
INSERT INTO [회원테이블] VALUES ('A10002', '박아빈', '여', 29,200000, '2021-01-02', 0) ;
INSERT INTO [회원테이블] VALUES ('A10003', '임종욱', '남', 29,300000, '2021-01-03', NULL) ;

--[회원테이블] 특정 데이터만 삭제
DELETE
FROM [회원테이블]
WHERE [회원번호] = 'A10001'

SELECT *
FROM [회원테이블]

--DELETE는 데이터만 삭제
--TRUNCATE는 데이터+테이블 공간만 삭제
--DROP은 테이블 전체 삭제

--데이터 접근 제어(DTL: DATA CONTROL LANGUAGE)--
--MWS라는 유저에게 [회원테이블] 권한 부여
GRANT SELECT, INSERT, UPDATE, DELETE ON [회원테이블] TO MWS WITH GRANT OPTION
--권한회수/제거
REVOKE SELECT, INSERT, UPDATE, DELETE ON [회원테이블] TO MWS CASCADE --MWS가 다른 사용자에게 부여한 권한도 연쇄적으로 취소

--명령어 제거(TCL: TRANSACTION CONTROL LANGUAGE)-- 데이터 조회/삽입/수정/삭제 제어