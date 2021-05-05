--CH.4-2-1 ȿ��ȭ & �ڵ�ȭ�� �ʿ��� SQL ����
--2-1. VIEW

USE EDU

--(1) VIEW ����
--VIEW: ���� ���̺� OR ����� SQL ��ɾ�
--���� ����ϴ� SQL��ɾ ���������ν� ȿ������ SQL ��ɾ� ����

 CREATE VIEW [Order_Member]
 AS
 SELECT A.*
		,B.GENDER
		,B.ageband
		,B.Join_date
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no

--(2) VIEW ��ȸ
USE EDU
SELECT *
FROM [Order_Member]

--(3) VIEW ����
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

--(4) VIEW ����

DROP VIEW [Order_Member]

--2-2. PROCEDURE : �Ű������� Ȱ��
--(1)PROCEDURE ����

USE EDU

CREATE PROCEDURE [Order_Member]
(
@channel_code AS INT --@�Ű����� : ���������� ����
)
AS
SELECT *
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
WHERE A.channel_code = @channel_code

--(2) PROCEDURE ����
EXEC [Order_Member] 3 --channel_code�� 3�� ������ ��ȸ ��������

--(3) PROCEDURE ����
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

--(4) PROCEDURE ����
DROP PROCEDURE [Order_Member]


--3-1. �����͸�Ʈ(DM) �����ϱ�
--������ ��Ʈ(Data Mart)��? �м� ������ �°� ������ �м��� ������ ��Ʈ

USE EDU
--[�м� ����: 2020�⵵ �ֹ��ݾ� �� �Ǽ��� ȸ�� �������� ���� Ȯ��]
--1. [Order] ���̺��� mem_no �� sales_amt �հ� �� order_no �� ����
--*����: [order_date]�� 2020��
--*�� �̸� : [sales_amt] �հ�� tot_amt / [order_no] ������ tot_tr

SELECT mem_no
		,SUM(sales_amt) AS tot_amt
		,COUNT(order_no) AS tot_tr
FROM [Order]
WHERE YEAR(order_date) = 2020
GROUP BY mem_no

--2.[Member] ���̺��� �������� �Ͽ� (1)���̺� LEFT JOIN
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

--3.(2)�� Ȱ���Ͽ� ���ſ��� �� �߰�
SELECT A.*
		,B.tot_amt
		,B.tot_tr
		,CASE WHEN B.mem_no IS NOT NULL THEN '������'
			  ELSE '�̱�����' END AS pur_yn
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
		 
--4.  (3) ���̺� ��� ����
SELECT A.*
		,B.tot_amt
		,B.tot_tr
		,CASE WHEN B.mem_no IS NOT NULL THEN '������'
			  ELSE '�̱�����' END AS pur_yn
INTO [MART_2020] --�����͸�Ʈ ����
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

--3-2. ������ ���ռ�

USE EDU

--[MART_2020] �����͸�Ʈ ���ռ� üũ
--1.������ ��Ʈ ȸ���� �ߺ��� ���°�? 
--*DISTINCT �� �ߺ��� ���� �����ϰ� ������ ���� ��ȯ�� 
SELECT COUNT(mem_no) AS ȸ����
		,COUNT(DISTINCT mem_no) AS ȸ����_�ߺ�����
FROM [MART_2020]

--2.[member]���̺�� [MART_2020] ������ ��Ʈ ȸ���� ���̴� ���°�?
SELECT COUNT(mem_no) AS ȸ����
		,COUNT(DISTINCT mem_no) AS ȸ����_�ߺ�����
FROM [Member]

--3. [member]���̺�� [MART_2020] ������ ��Ʈ �ֹ��� ���̴� ���°�?
SELECT COUNT(order_no) AS �ֹ���
		,COUNT(DISTINCT order_no) AS �ֹ���_�ߺ�����
FROM [Order]
WHERE YEAR(order_date) = 2020

--4. [MART_2020] �����͸�Ʈ �̱����ڴ� [Order] ���̺��� 2020�⿡ ���Ű� ���°�?
SELECT *
FROM [Order]
WHERE mem_no IN (SELECT mem_no FROM [MART_2020] WHERE pur_yn = '�̱�����')
AND YEAR(order_date) = 2020