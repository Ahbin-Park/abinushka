--CH.4-1-2 �������Լ�
USE EDU

--CASE WHEN: ���� ���Ǻ��� ���� �� ��ȯ
--���� �� ���� NULL ��ȯ
SELECT *
		, CASE WHEN ageband BETWEEN 20 AND 30 THEN '2030����'
			   WHEN ageband BETWEEN 40 AND 50 THEN '4050����'
			   END AS ageband_seg
FROM [Member]

--CASE WHEN(+ELSE)
--���� �� ���� ELSE�� ����
SELECT *
		, CASE WHEN ageband BETWEEN 20 AND 30 THEN '2030����'
			   WHEN ageband BETWEEN 40 AND 50 THEN '4050����'
			   ELSE 'OTHER����' END AS ageband_seg
FROM [Member]

--CH.4-1-3 �������Լ�

--�����Լ�
USE EDU
SELECT COUNT(order_no) AS �ֹ���
		,SUM(sales_amt) AS �ֹ��ݾ�
		,AVG(sales_amt) AS ����ֹ��ݾ�
		,MAX(order_date) AS �ֱٱ������� 
		,MIN(order_date) AS ���ʱ�������
		,STDEV(sales_amt) AS �ֹ��ݾ�_ǥ������
		,VAR(sales_amt) AS �ֹ��ݾ�_�л�
	FROM [Order]

--�����Լ�+ GROUP BY (mem_no ���� �׷����� ���� ���� �࿡ ���� �����Լ�)
SELECT mem_no
		,COUNT(order_no) AS �ֹ���
		,SUM(sales_amt) AS �ֹ��ݾ�
		,AVG(sales_amt) AS ����ֹ��ݾ�
		,MAX(order_date) AS �ֱٱ������� 
		,MIN(order_date) AS ���ʱ�������
		,STDEV(sales_amt) AS �ֹ��ݾ�_ǥ������
		,VAR(sales_amt) AS �ֹ��ݾ�_�л�
	FROM [Order]
GROUP BY mem_no

--�׷��Լ� (GROUP BY �׸���� �׷����� ���� �Լ� : WITH ROLLUP, WITH CUBE, GROUPING SETS, GROUPING)

USE EDU
SELECT YEAR(order_date) AS ����
		,channel_code AS ä���ڵ�
		, SUM(sales_amt) AS �ֹ��ݾ�
FROM [Order]
GROUP BY YEAR(order_date) --YEAR: ��¥ ������ �����͸� ������ ��ȯ
		, channel_code
WITH ROLLUP ---GROUP BY �׸���� ������[channel_code]���� ����[YEAR(order_date)]������ �׷����� ���� (ROLL UP ���ϴ� ���, ä���ڵ��� NULL ���� ��ȸ���� ����)
ORDER BY 1 DESC, 2 ASC  --��ȸ�� �� ������ ���� �� ���� (1��:��������, 2��:��������)


--WITH CUBE (group by ������ �ۼ��ؾ���)
---GROUP BY �׸���� ��� ����� ���� �׷����� ����
USE EDU
SELECT YEAR(order_date) AS ���� --YEAR: ��¥ ������ �����͸� ������ ��ȯ
		,channel_code AS ä���ڵ�
		,SUM(sales_amt) AS �ֹ��ݾ�
FROM [Order]
GROUP BY YEAR(order_date), channel_code
WITH CUBE -- ��� ����� ���� ���� ������,  WITH ROLL UP���� �� ���谪�� ��ȸ��
ORDER BY 1 DESC, 2 ASC

--GROUPING SETS
---GROUP BY �׸���� ���� �׷����� ����
USE EDU
SELECT YEAR(order_date) AS ���� --YEAR: ��¥ ������ �����͸� ������ ��ȯ
		,channel_code AS ä���ڵ�
		,SUM(sales_amt) AS �ֹ��ݾ�
FROM [Order]
GROUP BY GROUPING SETS( YEAR(order_date), channel_code ) --�� �׸� ���� ���谪�� ��ȸ��

--GROUPING
---WITH ROLLUP �� CUBE�� ���� �׷�ȭ�Ǿ��ٸ� 0, �׷��� ������ 1�� ��ȯ (1:NULL���� 1�� ��ȯ��)
---WITH ROLLUP �Լ��� �ַ� ���
USE EDU
SELECT YEAR(order_date) AS ����
		,GROUPING(YEAR(order_date)) AS ����_GROUPING

		,channel_code AS ä���ڵ�
		,GROUPING(channel_code) AS ä���ڵ�_GROUPING

		,SUM(sales_amt) AS �ֹ��ݾ�
FROM [Order]
GROUP BY YEAR(order_date), channel_code
WITH ROLLUP
ORDER BY 1 DESC, 2 ASC

--GROUPING �� CASE WHEN�� Ȱ���� �Ѱ� �� �Ұ� ��ȯ

--(1) YEAR(order_date) �� channel_code ���� -> ������ ��ȯ
SELECT CAST(YEAR(order_date) AS VARCHAR) AS ����
		,CAST(channel_code AS VARCHAR) AS ä���ڵ�
		,sales_amt
FROM [Order]

--(2) (1)�� ���������� �Ͽ�, CASE WHEN���� �Ѱ� �� �Ұ� ��ȯ
SELECT CASE WHEN GROUPING(����) = 1 THEN '�Ѱ�'
			ELSE ���� END AS ����_�Ѱ�

	  ,CASE WHEN GROUPING(����) = 1 THEN '�Ѱ�'
			WHEN GROUPING(ä���ڵ�) = 1 THEN '�Ұ�'
			ELSE ä���ڵ� END AS ä���ڵ�_�ѼҰ�
	  ,SUM(sales_amt) AS �ֹ��ݾ�
FROM (
	 SELECT CAST(YEAR(order_date) AS VARCHAR) AS ����
			,CAST(channel_code AS VARCHAR) AS ä���ڵ�
			,sales_amt
	FROM [Order]
	)A
GROUP BY ����, ä���ڵ�
WITH ROLLUP
ORDER BY 1 DESC, 2 ASC
