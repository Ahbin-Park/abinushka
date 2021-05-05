--CH3.(3) ���� ����(Sub query)--

--SELECT��
SELECT *
	, (SELECT gender
		FROM [Member] B
		WHERE A.mem_no = B.mem_no) AS gender
	FROM [Order] A

--FROM ��
SELECT *
	FROM(
		SELECT mem_no
				,SUM(sales_amt) AS tot_amt --SUM�� ���� �ֹ��ݾ�(sales_amt) ���� ���Ѵ�.
		FROM [Order]
		GROUP BY mem_no
		) A
--FROM �� �������� + LEFT JOIN
SELECT *
	FROM (
		SELECT mem_no
				,SUM(sales_amt) AS tot_amt
		FROM [Order]
		GROUP BY mem_no
		) A
	LEFT JOIN [Member] B
	ON A.mem_no = B.mem_no --��������(A)�� [Member] ������ ���� ���밪(mem_no)�� ��Ī�Ǵ� �����͸� ��ȸ��

--WHERE �� (=�Ϲ� ��������) : ���� or ����
--���� �� : �������� ����� ���� ��
SELECT *
FROM [Order]
WHERE mem_no = (SELECT mem_no FROM [Member] WHERE mem_no = '1000005')
--���� �� Ȯ��
SELECT mem_no FROM [Member] WHERE mem_no = '1000005'

--���� �� : �������� ����� ���� ��
SELECT *
FROM [Order]
WHERE mem_no IN (SELECT mem_no FROM [Member] WHERE gender = 'man') --IN ������: ����Ʈ�� �� �� �ϳ��� ��ġ�ϸ� �Ǵ� Ư�� ������
--���� �� Ȯ��
SELECT mem_no FROM [Member] WHERE gender = 'man'


--��ġ��(��������)--
--(1) SELECT, FROM : [Order] ���̺��� ��� �÷� ��ȸ
SELECT *
FROM [Order]

--(2) WHERE : [shop_code]�� 30 �̻����θ� ���͸�
SELECT *
FROM [Order]
WHERE shop_code >= 30

--(3) GROUP BY (+SUM�Լ�) : [mem_no]�� [sales_amt] �հ� ���϶�
SELECT mem_no
	,SUM(sales_amt) AS tot_amt
FROM [Order]
WHERE shop_code >= 30 -- ���� ì�ܳ־������
GROUP BY mem_no

--(4) **HAVING : [sales_amt] �հ� 100000 �̻� ���͸�
SELECT mem_no
	,SUM(sales_amt) AS tot_amt 
FROM [Order]
WHERE shop_code >= 30 --*���� ì�ܳ־������
GROUP BY mem_no
HAVING SUM(sales_amt) >= 100000 --*having ��ɾ� 

--(5) ORDER BY(+DESC) : [sales_amt] �հ谡 ���� ������ ����
SELECT mem_no
	,SUM(sales_amt) AS tot_amt
FROM [Order]
WHERE shop_code >= 30 --*���� ì�ܳ־������
GROUP BY mem_no
HAVING SUM(sales_amt) >= 100000 --*having ��ɾ� 
ORDER BY SUM(sales_amt) DESC

