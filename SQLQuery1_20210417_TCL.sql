--명령어 제어(TCL: TRANSACTION CONTROL LANGUAGE)
/* 실행(COMMIT), 취소(ROLLBACK), 임시저장(SAVEPOINT)*/

--ROLLBACK
USE EDU
BEGIN TRAN -- TCL 시작
SELECT * FROM [회원테이블]
DELETE FROM [회원테이블]
SELECT * FROM [회원테이블]
ROLLBACK
SELECT * FROM [회원테이블]

--SAVEPOINT
USE EDU
BEGIN TRAN
/* SAVEPOINT(1) [회원테이블]에 'A10001' 회원 데이터 삽입(INSERT)*/
SAVE TRAN S1;
INSERT INTO [회원테이블] VALUES ('A10001', '모원서', '남', 33, 10000, '2021-04-17', 1);

/* SAVEPOINT(2) 'A10001' 나이 34로 수정(UPDATE)*/
SAVE TRAN S2;
UPDATE [회원테이블] SET [나이] = 33 WHERE [회원번호] = 'A10001'

/* SAVEPOINT(3) [회원테이블]에 'A10003' 회원 데이터 삭제(DELETE) */
SAVE TRAN S3;
DELETE FROM [회원테이블] WHERE [회원번호] = 'A10003'

SELECT * FROM [회원테이블]

/*S3 지정 취소*/
ROLLBACK TRAN S3;
SELECT * FROM [회원테이블]
/*S2 지정 취소*/
ROLLBACK TRAN S2;
SELECT * FROM [회원테이블]
/*S1 지정 취소*/
ROLLBACK TRAN S1;
SELECT * FROM [회원테이블]