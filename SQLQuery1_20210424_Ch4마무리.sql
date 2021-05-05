Ch4-2. ��������ȸ(SELECT) + ����(JOIN) + ��������(SUB QUERY)

--Order ���̺� �������� Member ���̺��� left �����Ͽ���

USE EDU
SELECT *
FROM [Order] AS A
LEFT JOIN [Member] AS B 
ON A.mem_no = B.mem_no

--gender�� sales_amt �հ踦 ���ض� (tot_amt)
SELECT B.gender
		,SUM(sales_amt) AS tot_amt
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
GROUP BY B.gender

--gender, addr �� sales_amt �հ踦 ���ض�
SELECT B.gender
		,B.addr
		,SUM(sales_amt) AS tot_amt
FROM [Order] A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
GROUP BY B.gender
		,B.addr

--(1)Order ���̺��� mem_no�� sales_amt �հ� ���϶�
SELECT A.mem_no
	,SUM(sales_amt) as tot_amt
FROM [Order] A
GROUP BY mem_no

--(2) (1)�� FROM �������� ����Ͽ�, Member ���̺��� LEFT JOIN�϶�
SELECT *
	FROM(
		SELECT A.mem_no
				,SUM(sales_amt) as tot_amt
		FROM [Order] 
		GROUP BY mem_no
	)A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no

--(3) gender, addr�� tot_amt ���϶�
SELECT *
SELECT B.gender
	,B.addr
	,SUM(tot_amt) AS �հ�
FROM (
	SELECT mem_no
			,SUM(sales_amt) AS tot_amt
	FROM [Order]
	GROUP BY mem_no
	)A
LEFT JOIN [Member] B
ON A.mem_no = B.mem_no
GROUP BY B.gender, B.addr