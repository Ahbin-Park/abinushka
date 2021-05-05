--CH.4-1-4 ������ �Լ�
--�⺻ ���� : �������Լ� + OVER(ORDER BY�� ASC / DESC) PARTITION BY�� �ɼ�

--(1) �����Լ�
--ORDER BY
--*ROW_NUMBER(): ������ ���� ��ȯ(1,2,3,4...)
--*RANK(): ������ ���� ��ȯ (1,1,1,4...)
-- DENSE_RANK(): ������ ���� ��ȯ (1,1,1,3 �ϳ��� ����� ����)

USE EDU
SELECT order_date
		, ROW_NUMBER() OVER (ORDER BY order_date ASC) AS ROW_NUMBER

		, RANK() OVER (ORDER BY order_date ASC) AS RANK -- ���ϳ�¥�� ���� ������ ������ ��ȯ, ���� ������ �ϳ��� ī��Ʈ ��.

		, DENSE_RANK() OVER (ORDER BY order_date ASC) AS DENSE_RANK -- ���� ��¥ ���� ���� ��ȯ�ϵ�, ���� ��¥�� �ϳ��� ��(���)�� ����
FROM [Order]

--ORDER BY + PARTITION BY : PARTITION ���� ���� ī���� ��
SELECT mem_no
		,order_date
		,ROW_NUMBER() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS ROW_NUMBER

		,RANK() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS RANK

		,DENSE_RANK() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS DENSE_RANK
FROM [Order]

--(2) �����Լ�(����)
--ORDER BY(+PARTITION BY) �� �������� ��� �ణ�� �������� ��ȯ

SELECT order_date
		,sales_amt
		,COUNT(sales_amt) OVER (ORDER BY order_date ASC) AS ����Ƚ��
		,SUM(sales_amt) OVER (ORDER BY order_date ASC) AS ���űݾ�
		,AVG(sales_amt) OVER (ORDER BY order_date ASC) AS ��ձ��űݾ�
		,MAX(sales_amt) OVER (ORDER BY order_date ASC) AS ����������űݾ�
		,MIN(sales_amt) OVER (ORDER BY order_date ASC) AS ���峷�����űݾ�
FROM [Order]

--ORDER BY + PARTITION BY: mem_no�� ���� ���еǾ� ���� ���� ��ȸ��(PARTITION BY mem_no)
SELECT mem_no
		,order_date
		,sales_amt
		,COUNT(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS ����Ƚ��
		,SUM(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS ���űݾ�
		,AVG(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS ��ձ��űݾ�
		,MAX(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS ����������űݾ�
		,MIN(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS ���峷�����űݾ�
FROM [Order]


--CH.4-1-5 ���� ������
--������ UNION, ������ UNION ALL(�ߺ� 2), ������ INTERSECT, ������ EXCEPT
 USE EDU
 
--UNION: �� ���̺��� ������ ���·� ��� ��ȯ
SELECT *
FROM [Member_1]
UNION
SELECT *
FROM [Member_2]

--UNION ALL: �� ���̺��� ������ ���·� ��ȯ, �ߺ��� �� �״�� ��ȯ
SELECT *
FROM [Member_1]
UNION ALL
SELECT *
FROM [Member_2]

--INTERSECT: ������. �ߺ��� �� �ϳ��� ������ ��ȯ.
SELECT *
FROM [Member_1]
INTERSECT
SELECT *
FROM [Member_2]

--EXCEPT: ������. �ߺ��� �� �ϳ��� ������ ��ȯ. (MEMBER_1 - MEMBER_2)
SELECT *
FROM [Member_1]
EXCEPT
SELECT *
FROM [Member_2]
 
