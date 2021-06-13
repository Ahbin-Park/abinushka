--1-1 DATAMART �����ϱ�
USE EDU
SELECT A.*
	,B.prod_cd
	,B.quantity
	,D.price
	,B.quantity * D.price AS sales_amt
	,C.store_addr
	,D.brand
	,D.model
	,E.gender
	,E.age
	,E.addr
	,E.join_date
INTO [Car_MART]
FROM [Car_order] A
LEFT JOIN [Car_orderdetail] B ON A.order_no = B.order_no
LEFT JOIN [Car_store] C ON A.store_cd = C.store_cd
LEFT JOIN [Car_product] D ON B.prod_cd = D.prod_cd
LEFT JOIN [Car_member] E ON A.mem_no = E.mem_no


SELECT * FROM [Car_MART]

--1-2. ���� �� �������� �м�
--(������ ����, ����, ���� ������ ������ Ư¡ �� Ư�� �ľ��ϱ�

--(1) ���ɴ� �� �߰��� ���� �ӽ� ���̺� ���� #PROFILE_BASE
--*�ӽ����̺��̶�, ���������� ���̺��� ������ �ʿ䰡 ���� �� �ӽ÷� ����ϴ� ���̺�
USE EDU
SELECT *
	,CASE WHEN age < 20 THEN '20�� �̸�'
		  WHEN age BETWEEN 20 AND 29 THEN '20��'
		  WHEN age BETWEEN 30 AND 39 THEN '30��'
		  WHEN age BETWEEN 40 AND 49 THEN '40��'
		  WHEN age BETWEEN 50 AND 59 THEN '50��'
		  ELSE '60�� �̻�' END AS ageband
INTO #PROFILE_BASE
FROM [Car_MART]

SELECT * FROM #PROFILE_BASE
		 
--(2) #PROFILE_BASE ���̺��� Ȱ���� ���� �� ���ɴ뺰 ������ ����

--���� ������ ����
SELECT gender
		,COUNT(DISTINCT mem_no) AS tot_mem
FROM #PROFILE_BASE
GROUP BY gender

--���ɴ뺰 ������ ����
SELECT ageband
		,COUNT(DISTINCT mem_no) AS tot_mem
FROM #PROFILE_BASE
GROUP BY ageband

--���� �� ���ɴ뺰 ������ ����
SELECT gender
		, ageband
		, COUNT(DISTINCT mem_no) AS tot_mem
FROM #PROFILE_BASE
GROUP BY gender, ageband
ORDER BY 1

--(3) #PROFILE_BASE ���̺��� Ȱ���� ���� �� ���ɴ뺰 ������ ����(+������)
SELECT gender, ageband
		, COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2020 THEN mem_no END) AS tot_mem_2020
		, COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2021 THEN mem_no END) AS tot_mem_2021
FROM #PROFILE_BASE
GROUP BY gender, ageband
ORDER BY 1

--1-3. RFM ������ȭ �м�
--RFM: ������ǥ (Recency �ֱټ�, Frequency ���ź�, Monetary ���űݾ�) Ȱ���Ͽ� �� ����ȭ
--(1) [Car_MART] ���̺��� RFM ���� �ӽ� ���̺� ����

SELECT mem_no
		,SUM(sales_amt) AS tot_amt --M:���űݾ�
		,COUNT(order_no) AS tot_tr --F: ���ź�
INTO #RFM_BASE
FROM [Car_MART]
WHERE YEAR(order_date) BETWEEN 2020 AND 2021
GROUP BY mem_no

SELECT * FROM #RFM_BASE

--(2) ������ȭ �׷� �߰�(���űݾ� �� �󵵱���)
SELECT A.*, B.tot_amt, B.tot_tr
		,CASE WHEN tot_amt >= 1000000000 AND tot_tr >= 3 THEN '1_VVIP'
			  WHEN tot_amt >= 500000000 AND tot_tr >= 2 THEN '2_VIP'
			  WHEN tot_amt >= 300000000 THEN '3_GOLD'
		  	  WHEN tot_amt >= 100000000 THEN '4_SILVER'
			  WHEN tot_tr >1 THEN '5_BRONZE'
			  ELSE '6_POTENTIAL' END AS segmentation
INTO #RFM_BASE_SEG
FROM [Car_member] A
LEFT JOIN #RFM_BASE B
ON A.mem_no = B.mem_no

--(3) ������ȭ�� �� �� �� ������� �ľ�
SELECT segmentation AS 'ȸ�����',COUNT(mem_no) AS '�����', SUM(tot_amt) AS '���űݾ�' FROM #RFM_BASE_SEG
GROUP BY segmentation
ORDER BY 1

--1-4. ������ȯ�� �� �����ֱ� �м�
--(1) [Car_MART] ������ȯ�� ���� �ӽ����̺�(#RETENTION_BASE) ����


SELECT A.mem_no AS pur_mem_2020
		,B.mem_no AS pur_mem_2021
		,CASE WHEN B.mem_no IS NOT NULL THEN 'Y' ELSE 'N' END AS retention_yn
INTO #RETENTION_BASE
FROM (SELECT DISTINCT mem_no FROM [Car_MART] WHERE YEAR(order_date) = 2020) A
LEFT JOIN (SELECT DISTINCT mem_no FROM [Car_MART] WHERE YEAR(order_date) = 2021) B
ON A.mem_no = B.mem_no

--�����ȸ
SELECT * FROM #RETENTION_BASE
WHERE retention_yn = 'Y'

--(2) #RETENTION_BASE ������ȯ�� �ľ� 
SELECT COUNT(pur_mem_2020) AS tot_mem
		,COUNT(CASE WHEN retention_yn = 'Y' THEN pur_mem_2020 END) AS retention_mem
FROM #RETENTION_BASE

--(+) �����ڵ庰(store_cd) �����ֱ�
--(1) �����ֱ� ��� = (�ֱ� ������-���� ������)/(����Ƚ��-1)�� ���� �ӽ����̺� ����(CYCLE_BASE)

SELECT store_cd
		,MIN(order_date) AS min_order_date
		,MAX(order_date) AS max_order_date
		,COUNT(DISTINCT order_no) -1 AS tot_tr_1
INTO #CYCLE_BASE
FROM [Car_MART]
GROUP BY store_cd
HAVING COUNT(DISTINCT order_no) >= 2 --����Ƚ�� 2ȸ �̻� ���͸� (����Ƚ���� 1ȸ�� �и� 0�̵Ǳ� ���� -> sql���� ����)

SELECT * FROM #CYCLE_BASE

--(2) #CYCLE_BASE Ȱ���� �����ֱ� �ξ�
--�����ڵ� �� �����ֱ� ���ϱ�
SELECT *
		,DATEDIFF(DAY, min_order_date, max_order_date) AS diff_day
		,DATEDIFF(DAY, min_order_date, max_order_date)*1.00 / tot_tr_1 AS cycle -- *1.00 �Ҽ����ڸ����� ��Ÿ����
FROM #CYCLE_BASE
ORDER BY 6 DESC

SELECT store_cd, DATEDIFF(DAY, min_order_date, max_order_date)*1.00 / tot_tr_1 AS cycle
FROM #CYCLE_BASE

--1-5. ��ǰ �� ����� �м�
--(1) BRAND, MODEL �� 2020~2021 ���űݾ� �ӽ����̺� ����
SELECT brand, model
	   ,SUM(CASE WHEN YEAR(order_date)=2020 THEN sales_amt END) AS tot_amt_2020
	   ,SUM(CASE WHEN YEAR(order_date)=2021 THEN sales_amt END) AS tot_amt_2021
INTO #PRODUCT_GROWTH_BASE
FROM [Car_MART]
GROUP BY brand, model

SELECT *
FROM #PRODUCT_GROWTH_BASE

--(2) �귣�庰 ����� �ľ�
SELECT brand
		,SUM(tot_amt_2021) / SUM(tot_amt_2020) -1 AS growth
FROM #PRODUCT_GROWTH_BASE
GROUP BY brand
ORDER BY 2 DESC

--(3) �귣�� �� �𵨺� ����� �ľ�(�� �귣�庰 �����  TOP2 �𵨸� �ľ�)
SELECT *
FROM (	
	  SELECT * 
			 ,ROW_NUMBER() OVER(PARTITION BY brand ORDER BY growth DESC) AS rnk --�귣�庰 rank �������Լ� Ȱ��
	  FROM (
			SELECT brand
					, model
		 			,SUM(tot_amt_2021) / SUM(tot_amt_2020) -1 AS growth
			FROM #PRODUCT_GROWTH_BASE
			GROUP BY brand, model
			) A
)B
WHERE rnk <=2