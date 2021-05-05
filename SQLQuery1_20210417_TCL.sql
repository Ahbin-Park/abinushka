--��ɾ� ����(TCL: TRANSACTION CONTROL LANGUAGE)
/* ����(COMMIT), ���(ROLLBACK), �ӽ�����(SAVEPOINT)*/

--ROLLBACK
USE EDU
BEGIN TRAN -- TCL ����
SELECT * FROM [ȸ�����̺�]
DELETE FROM [ȸ�����̺�]
SELECT * FROM [ȸ�����̺�]
ROLLBACK
SELECT * FROM [ȸ�����̺�]

--SAVEPOINT
USE EDU
BEGIN TRAN
/* SAVEPOINT(1) [ȸ�����̺�]�� 'A10001' ȸ�� ������ ����(INSERT)*/
SAVE TRAN S1;
INSERT INTO [ȸ�����̺�] VALUES ('A10001', '�����', '��', 33, 10000, '2021-04-17', 1);

/* SAVEPOINT(2) 'A10001' ���� 34�� ����(UPDATE)*/
SAVE TRAN S2;
UPDATE [ȸ�����̺�] SET [����] = 33 WHERE [ȸ����ȣ] = 'A10001'

/* SAVEPOINT(3) [ȸ�����̺�]�� 'A10003' ȸ�� ������ ����(DELETE) */
SAVE TRAN S3;
DELETE FROM [ȸ�����̺�] WHERE [ȸ����ȣ] = 'A10003'

SELECT * FROM [ȸ�����̺�]

/*S3 ���� ���*/
ROLLBACK TRAN S3;
SELECT * FROM [ȸ�����̺�]
/*S2 ���� ���*/
ROLLBACK TRAN S2;
SELECT * FROM [ȸ�����̺�]
/*S1 ���� ���*/
ROLLBACK TRAN S1;
SELECT * FROM [ȸ�����̺�]