--CH3.(2) JOIN ��� ����ϱ�--

USE EDU

--INNER JOIN : ����� ��ҵ��� ���� �����ϴ� ���� ���
--[MEMBER] �� [ORDER] ���̺� ���� ��(mem_no) ����

SELECT *
FROM [Member] AS A --[Member] ���̺� ��Ī A�� ����
INNER
JOIN [ORDER] AS B --[Order] ���̺� ��Ī B�� ����
ON A.mem_no = B.mem_no --ON �������� : ���� ��(mem_no) ����

--OUTER JOIN : ��Ī �ȵǴ� �����͵� ��ȸ�ϴ� ��ɾ� (�������� ���� Left, Right, Full JOIN)
--(1) LEFT JOIN : ���� ���� ������ ��ȸ
--[Member] �� [Order] ���̺� ���� ��(mem_no) ���� + ��Ī �ȵǴ� [Member]������ ��ȸ
SELECT *
FROM [Member] A
LEFT JOIN [Order] B
ON A.mem_no = B.mem_no
/*���� �� �ֹ� �̷��� ���� �����͵��� ��ȸ��*/

--(2) RIGHT JOIN : ������ ���� ������ ��ȸ
SELECT *
FROM [Member] A
RIGHT JOIN [Order] B 
ON A.mem_no = B.mem_no

--(3) FULL JOIN : ���� ���̺� ���� ������ ��ȸ
SELECT *
FROM [Member] A
FULL JOIN [Order] B
ON A.mem_no = B.mem_no

--OTEHR(CROS, SELF) JOIN
/* CROSS JOIN �� ���̺�(A,B)�� ���� ����
SELF JOIN �� ���̺�(A)�� ��� �ٸ� ����� ����*/
--(1) CROSS JOIN
--[Member]�� x [Order]��

SELECT *
FROM [Member] A
CROSS JOIN [Order] B
WHERE A.mem_no = '1000001'

--(2) SELF JOIN
--[Member]�� x [Member]��
SELECT *
FROM [Member] A, [Member] B
WHERE A.mem_no = '1000001'