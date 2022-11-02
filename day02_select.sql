-- day02_select.sql
select * from tab;
select * from emp;
select * from dept;
select * from salgrade;

SELECT EMPNO, ENAME, SAL, SAL+500 AS SAL_UP,
COMM , SAL*12+COMM,SAL*12 + NVL(COMM,0) AS"1 YEAR SAL"
FROM EMP;
--NVL()
--NVL2(EXPR, ��1, ��2) : EXPR�� NULL�� �ƴҰ�� ��1�� ��ȯ, NULL�ϰ��� ��2�� ��ȯ
SELECT empno,ename,mgr, nvl2(mgr,'����������','������ ����') from emp;

--���ڿ� ����: ||

SELECT ename || ' is a ' || JOB AS "EMPLOYEE INFO" from emp;

--����] EMP���̺��� �̸��� ������ "KING: 1 YEAR SALARY = 60000"
--	�������� ����϶�.

SELECT ename || ': 1 YEAR SALARY =' || TO_CHAR(sal*12+NVL(COMM,0)) from emp;
--nvl����� ���ڿ� �����Ҷ� ���������ͼ� TO_CHAR�Լ� ���

--DISTINCT : �ߺ����� ������
select job from emp;
select distinct job from emp;

�μ����� ��� �ϴ� ������ �ѹ��� ����ϼ���
select deptno, job from emp order by deptno asc;
select distinct deptno,job from emp
order by deptno asc;

select distinct name , job from member;
select unique name, job from member;

--[����]
--	 1] EMP���̺��� �ߺ����� �ʴ� �μ���ȣ�� ����ϼ���.
select distinct deptno from emp;
--	 2] MEMBER���̺��� ȸ���� �̸��� ���� ������ �����ּ���.
select name,age,job from member;
--	 3] CATEGORY ���̺� ����� ��� ������ �����ּ���.
select * from category;
--	 4] MEMBER���̺��� ȸ���� �̸��� ������ ���ϸ����� �����ֵ�,
--	      ���ϸ����� 13�� ���� ����� "MILE_UP"�̶�� ��Ī����
--	      �Բ� �����ּ���.
select name,mileage,mileage*13 as mile_up from member;

--# Ư�� �� �˻� - where�� ����ؼ� ������ �ο��� �� �ִ�.

--emp���� �޿��� 300�̻��� ����� ���,�̸�,����, �޿��� ����ϼ���.
select empno,ename,job,sal
from emp
where sal >= 3000;

--EMP���̺��� �������� MANAGER�� �����
--������ �����ȣ,�̸�,����,�޿�,�μ���ȣ�� ����ϼ���.
select empno,ename,job,sal,deptno from emp where job='MANAGER';
--EMP���̺��� 1982�� 1��1�� ���Ŀ� �Ի��� ����� 
--�����ȣ,����,����,�޿�,�Ի����ڸ� ����ϼ���
select * from emp;
select empno,ename,job,sal,hiredate from emp
where hiredate>'82/01/01';

--emp���̺��� �޿��� 1300���� 1500������ ����� �̸�,����,�޿�,
--	�μ���ȣ�� ����ϼ���.
select ename,job,sal,deptno
from emp
where sal between 1300 and 1500;

--emp���̺��� �����ȣ�� 7902,7788,7566�� ����� �����ȣ,
--	�̸�,����,�޿�,�Ի����ڸ� ����ϼ���.
select empno,ename,job
from emp
where empno in (7902,7788,7566);

--10�� �μ��� �ƴ� ����� �̸�,����,�μ���ȣ�� ����ϼ���
select ename,job,deptno
from emp where deptno <> 10;

--emp���̺��� ������ SALESMAN �̰ų� PRESIDENT��
--	����� �����ȣ,�̸�,����,�޿��� ����ϼ���.
select empno,ename,job,sal
from emp
where job ='SALESMAN' OR job= 'PRESIDENT';
--	Ŀ�̼�(COMM)�� 300�̰ų� 500�̰ų� 1400�� ��������� ����ϼ���
select *
from emp
where comm =300 OR comm= 500 or comm=1400;	
--	Ŀ�̼��� 300,500,1400�� �ƴ� ����� ������ ����ϼ���
select *
from emp
where comm !=300 and comm != 500 and comm !=1400;
-- Ŀ�̼��� null�� ����� ������ ����ϼ���
-- select * from emp where comm=null;[x] �̷��� ����ȵ�
-- ���̸� is null  ���� �ƴϸ� is not null
select *
from emp
where comm is null;

--emp���� �̸��� S�ڷ� �����ϴ� ��� ������ �����ּ���
select * from emp where ename like 'S%';
--s�ڷ� �����»��
select * from emp where ename like '%S';
--	-�̸� �� S�ڰ� ���� ����� ������ �����ּ���.
select * from emp where ename like '%S%';
--    - �̸��� �ι� °�� O�ڰ� ���� ����� ������ �����ּ���.
select * from emp where ename like '_O%';

-- EMP���̺��� �Ի����ڰ� 82�⵵�� �Ի��� ����� ���,�̸�,����
--	   �Ի����ڸ� ����ϼ���.
select empno,ename,job,hiredate
from emp where hiredate like '82%';

ALTER SESSION SET NLS_DATE_FORMAT='YYYY-MM-DD'; -- <=�ý��۳�¥ ���� ����
ALTER SESSION SET NLS_DATE_FORMAT='DD-MON-YYYY';
ALTER SESSION SET NLS_DATE_FORMAT='YY/MM/DD'; -- <=�ý��۳�¥ �⺻��! 
-- �� ���̺� ��� ���� �达�� ����� ������ �����ּ���.
select * from member where name like '��%';
-- �� ���̺� ��� '������'�� ���Ե� ������ �����ּ���.
select * from member where all like '%������%';
-- ī�װ� ���̺� ��� category_code�� 0000�� ���� ��ǰ������ �����ּ���.
select * from category where category_code like '%0000';

-- EMP���̺��� �޿��� 1100�̻��̰� JOB�� MANAGER�� �����
--	���,�̸�,����,�޿��� ����ϼ���.
select empno,ename,job,sal from emp where sal>=1100 AND job='MANAGER'; 
--	- EMP���̺��� �޿��� 1100�̻��̰ų� JOB�� MANAGER�� �����
--	���,�̸�,����,�޿��� ����ϼ���.
select empno,ename,job,sal from emp where sal>=1100 OR job='MANAGER'; 
--	- EMP���̺��� JOB�� MANAGER,CLERK,ANALYST�� �ƴ�
--	  ����� ���,�̸�,����,�޿��� ����ϼ���.
select empno,ename,job,sal from emp where job not in('MANAGER','CLERK','ANALYST');
select empno,ename,job,sal from emp where job <> 'MANAGER' AND job != 'CLERK' AND job not in ('ANALYST');

--- EMP���̺��� �޿��� 1000�̻� 1500���ϰ� �ƴ� ����� ������ �����ּ���
select * from emp where sal>=1000 AND sal<=1500;
--   - EMP���̺��� �̸��� 'S'�ڰ� ���� ���� ����� �̸��� ���
--	  ����ϼ���.
select * from emp where ename not like '%S%';
--	- ������̺��� ������ PRESIDENT�̰� �޿��� 1500�̻��̰ų�
--	   ������ SALESMAN�� ����� ���,�̸�,����,�޿��� ����ϼ���.
select * from emp where job='PRESIDENT' AND sal >=1500 OR JOB='SALESMAN';
-- >>�켱������ and�� ������!

������ �켱����
�񱳿����� > not > and > or

order by ��
- �������� : asc
- �������� : desc
- null ���� ���������� �� ���� ���߿�, ������������ ���� �����´�

wgho ����
- where
- group by
- having
-order by

--������̺��� �Ի����� ������ �����Ͽ� ���,�̸�,����,�޿�,
--	�Ի����ڸ� ����ϼ���
select empno, ename,job,sal,hiredate
from emp order by hiredate;

select empno, ename,job,sal,hiredate
from emp order by hiredate desc;

select empno,ename,sal, sal*12 from emp order by sal*12 desc;

select empno,ename,sal, sal*12 as y from emp order by y desc; --��Ī���ְ� ��Ī�� �������������ص���
select empno,ename,sal,sal*12 from emp
order by 4 asc; --�ε����ε� order by���� sql�� �ε����� 1���� ����

--��� ���̺��� �μ���ȣ�� ������ �� �μ���ȣ�� ���� ���
--	�޿��� ���� ������ �����Ͽ� ���,�̸�,����,�μ���ȣ,�޿���
--	����ϼ���.
select empno,ename,job,deptno,sal from emp
order by deptno asc, sal desc;

--	��� ���̺��� ù��° ������ �μ���ȣ��, �ι�° ������
--	������, ����° ������ �޿��� ���� ������ �����Ͽ�
--	���,�̸�,�Ի�����,�μ���ȣ,����,�޿��� ����ϼ���.
select empno,ename,hiredate,deptno from emp;

--1] ��ǰ ���̺��� �Ǹ� ������ ������ ������� ��ǰ�� �����ؼ� 
--    �����ּ���.
select * from products order by output_price asc;

--2] �� ���̺��� ������ �̸��� ������ ������ �����ؼ� �����ּ���.
--      ��, �̸��� ���� ��쿡�� ���̰� ���� ������� �����ּ���.
select * from member order by name asc,age desc;

--3] ��ǰ ���̺��� ��ۺ��� ������������ �����ϵ�, 
--	    ���� ��ۺ� �ִ� ��쿡��
--		���ϸ����� ������������ �����Ͽ� �����ּ���.
select * from products order by trans_cost desc,mileage desc;

--4]������̺��̼� �Ի����� 1981 2��20�� ~ 1981 5��1�� ���̿�
--	    �Ի��� ����� �̸�,���� �Ի����� ����ϵ�, �Ի��� ������ ����ϼ���.
select ename,job,hiredate from emp
where to_char(hiredate) between '81/02/20'and '81/05/01' 
order by hiredate asc;
--        >> hiredate�� ���ڷ� �ٲ㼭 ���ؾ���
--5] ������̺��� �μ���ȣ�� 10,20�� ����� �̸�,�μ���ȣ,������ ����ϵ�
--	    �̸� ������ �����Ͻÿ�.
select ename,deptno,job from emp where deptno in(10,20) order by ename asc;

--6] ������̺��� ���ʽ��� �޿����� 10%�� ���� ����� �̸�,�޿�,���ʽ�
--    �� ����ϼ���.
select ename,sal,comm from emp where comm>sal*1.1;

--7] ������̺��� ������ CLERK�̰ų� ANALYST�̰�
--     �޿��� 1000,3000,5000�� �ƴ� ��� ����� ������ 

select * from emp where job in('CLERK','ANALYST') AND sal not in (1000,3000,5000);

--8] ������̺��� �̸��� L�� ���ڰ� �ְ� �μ��� 30�̰ų�
--    �Ǵ� �����ڰ� 7782���� ����� ������ ����ϼ���.
select * from emp where ename like '%L%L%' and deptno = 30 or mgr = 7782;
