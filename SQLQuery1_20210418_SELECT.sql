--CH4. [01] SELECT-- 
USE EDU

--FROM : [Member] ���̺� ����
SELECT *
FROM [Member]

--WHERE : GENDER �÷��� 'MAN'���θ� ���͸�
WHERE gender = 'man'

--GROUP BY : addr  �÷����� ȸ��[mem_no] �� ����
SELECT addr
	,COUNT(mem_no) AS [ȸ��������] --COUNT�� ���� ȸ�� ���� ���Ѵ�
FROM [Member]
WHERE gender = 'man'
GROUP BY addr 
HAVING COUNT(mem_no) >= 50 --HAVING �߰�: addr �÷����� ȸ��(mem_no) ���� 50 �̻� ���͸�
ORDER BY COUNT(mem_no) DESC --������������ ���� (���������� ASC)

--CH4. [02] ����(JOIN)--
/* ERM(Entity-Relationship Modelling)�� �����͸� ����ȭ�Ͽ�
�����ͺ��̽��� �����ϱ� ���� ��ü-���� �𵨸� ���*/

