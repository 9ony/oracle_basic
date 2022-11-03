1.������ �Լ�
2. �׷��Լ�
3. ��Ÿ �Լ�

# ������ �Լ�
[1] ������ �Լ�
[2] ������ �Լ�
[3] ��¥�� �Լ�
[4] ��ȯ �Լ�

# [1] ������ �Լ�
select lower('HAPPY BIRTHDAY'), upper('Happy Birthday') from DUAL;

--select * from dual;
--dual�� 1�� 1���� ���� ���� ���̺�
select 9*7 from dual;

# init


# concat(����1,����2) : 2�� �̻��� ���ڸ� �������ش�.
select concat('abc','1234') from dual;

--    [����] ��� ���̺��� SCOTT�� ���,�̸�,������(�ҹ��ڷ�),�μ���ȣ��
--		����ϼ���.
select empno, ename, lower(job) as job, deptno
from emp where ename = upper('scott');
--	 ��ǰ ���̺��� �ǸŰ��� ȭ�鿡 ������ �� �ݾ��� ������ �Բ� 
--	 �ٿ��� ����ϼ���.
select products_name, concat(output_price,'��') price from products;
--	 �����̺��� �� �̸��� ���̸� �ϳ��� �÷����� ����� ������� ȭ�鿡
--	       �����ּ���.
select concat(name,age) from member;

--# substr(����,i,len) : ���� i �ε����� ������ len ���� ���̸�ŭ�� ������ ��ȯ��
--i�� ����ϰ��: �տ�������
--�����ϰ�� : �ڿ�������
select substr('ABCDEFG',3,4), SUBSTR('ABCDEFG',3,2) FROM DUAL;
select substr('991203-1012369',1,6), substr('991203-1012369',-7,7) from dual;

--length(����) : ���ڿ� ���� ��ȯ
select length('991203-1012369') from dual;

--[����]
--	��� ���̺��� ù���ڰ� 'K'���� ũ�� 'Y'���� ���� �����
--	  ���,�̸�,����,�޿��� ����ϼ���. �� �̸������� �����ϼ���.
select empno,ename,job,sal
from emp
where substr(ename,1,1) between 'K' and 'Y';
where substr(ename,1,1)>'K' and substr(ename,1,1)<'Y';
--	������̺��� �μ��� 20���� ����� ���,�̸�,�̸��ڸ���,
--	�޿�,�޿��� �ڸ����� ����ϼ���.
select empno, ename, length(ename), sal, length(sal)
from emp
where deptno=20;
	
--	������̺��� ����̸� �� 6�ڸ� �̻��� �����ϴ� ������̸��� 
--	�̸��ڸ����� �����ּ���.
select ename, length(ename) from emp
where length(ename) >= 6;

--#LPAD/RPAD
--LPAD(�÷�,����1, ����2): ���ڰ��� ���ʺ��� ä���.
--RAPD(�÷�,����1, ����2): ���ڰ��� �����ʺ��� ä���.
select ename, LPAD(ename,15,' '), sal,LPAD(sal,10,'*') FROM EMP
where deptno=10;

select dname, rpad(dname,15,'#') from dept;

--#LTRIM/RTRIM
--LTRIM(����1, ����2): ����1�� ���� ����2�� ���� �ܾ ������
--                    �׹��ڸ� ������ ���������� ��ȯ��
select ltrim('TTTHELLO TEST','T'), rtrim('TTTHELLO TEST','T') from dual;

--#REPLACE(�÷�,����1,����2): �÷����� ����1�� �ش��ϴ� ���ڸ� ����2�� ��ü�Ѵ�.

SELECT REPLACE('ORACLE TEST','TEST','HI') FROM DUAL;

--������̺��� ������ �� ������ 'A'�� �����ϰ�
--�޿��� ������ 1�� �����Ͽ� ����ϼ���.
SELECT JOB, LTRIM(JOB,'A'), SAL ,LTRIM(SAL,1)
FROM EMP;
--������̺��� 10�� �μ��� ����� ���� ������ �� ������'T'��
--	�����ϰ� �޿��� ������ 0�� �����Ͽ� ����ϼ���.
SELECT JOB,RTRIM(JOB,'T'),SAL,RTRIM(SAL,0) FROM EMP;
--������̺� JOB���� 'A'�� '$'�� �ٲپ� ����ϼ���.
SELECT JOB,REPLACE(JOB,'A','$') FROM EMP;

--�� ���̺��� ������ �ش��ϴ� �÷����� ���� ������ �л��� ������ ���
--	 ���л����� ������ ��µǰ� �ϼ���.
SELECT JOB, REPLACE(JOB,'�л�','���л�') FROM MEMBER;

-- �� ���̺� �ּҿ��� ����ø� ����Ư���÷� �����ϼ���.
-- ����Ư���÷� �����ϼ���.
SELECT NAME,ADDR FROM MEMBER;
UPDATE MEMBER SET ADDR= REPLACE(ADDR,'�����','����Ư����');
ROLLBACK;

# [2] ������ �Լ�
# ROUND(��), ROUND(��,�ڸ���): �ݿø� �Լ�
�ڸ����� ����� �Ҽ��ڸ���,
�ڸ����� ������ �����ڸ��� �ݿø��Ѵ�.
SELECT ROUND(4567.567),ROUND(4567.567,0),ROUND(4567.567,2),ROUND(4567.567,-1) FROM DUAL;

#TRUC() : ������
SELECT TRUNC(4567.567),TRUNC(4567.567,0),TRUNC(4567.567,2),TRUNC(4567.567,-2) FROM DUAL;

#MOD(��1,��2): ���������� ��ȯ

--�� ���̺��� ȸ���̸�, ���ϸ���,����, ���ϸ����� ���̷� �������� �ݿø��Ͽ� ����ϼ���
SELECT NAME , MILEAGE, AGE ,ROUND(MILEAGE/AGE,0)FROM MEMBER;
--��ǰ ���̺��� ��ǰ ������� ��� �������� ���� ��ۺ� ���Ͽ� ����ϼ���.
SELECT PRODUCTS_NAME, TRANS_COST, TRUNC(TRANS_COST,-3) FROM PRODUCTS;
--������̺��� �μ���ȣ�� 10�� ����� �޿��� 	30���� ���� �������� ����ϼ���.
SELECT DEPTNO,ENAME,SAL,MOD(SAL,30) FROM EMP
WHERE DEPTNO=10;

# CHR(����),ASCII('����')
SELECT CHR(65), ASCII('A') FROM DUAL;

# ABS(��): ���밪�� ���ϴ� �Լ�
SELECT NAME, AGE ,AGE-40, ABS(AGE-40) FROM MEMBER;

#CEIL(��): �ø���
#FLOOR(��): ������

SELECT CEIL(123.001), FLOOR(123.001) FROM DUAL;

#POWER() : �ŵ�����
#SQRT() : ��Ʈ
#SIGN() : ���,����,0���� ����
SELECT POWER(2,7), SQRT(64), SQRT(133) FROM DUAL;
SELECT AGE-40, SIGN(AGE-40) FROM MEMBER;

[3] ��¥�� �Լ�
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

SELECT SYSDATE+3 "3�ϵ�", SYSDATE-2 "��Ʋ��" FROM DUAL;

--����Ǭ��
SELECT SYSTIMESTAMP, REPLACE(SYSTIMESTAMP,substr(SYSTIMESTAMP,10,2),substr(SYSTIMESTAMP,10,2)+2) FROM DUAL;
--����Բ�
SELECT SYSTIMESTAMP, TO_CHAR(SYSTIMESTAMP + 2/24,'YY/MM/DD HH24:MI:SS') "�� �ð� ��" FROM DUAL;
--������̺��� ��������� �ٹ� �ϼ��� �� �� �����ΰ��� ����ϼ���
--    �� �ٹ��ϼ��� ���� ��������� ����ϼ���.

select concat(round((sysdate-hiredate)/7),'��'),concat(floor(mod(sysdate-hiredate,7)),'��') from emp;
SELECT HIREDATE,SYSDATE, TRUNC(SYSDATE-HIREDATE),TRUNC((SYSDATE-HIREDATE)/7) WEEKS, TRUNC(MOD((SYSDATE-HIREDATE),7)) DAYS FROM EMP;

# MONTHS_NETWEEN(DATE1,DATE2) ��¥1�� ��¥2 ������ ������ �����

SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('22-07-26','YY-MM-DD')) FROM DUAL;

# ADD_MONTHS(DATE,N) : ��¥�� N������ ����
SELECT ADD_MONTHS(SYSDATE,2),ADD_MONTHS(SYSDATE,-2) FROM DUAL;

# LAST_DAY(D) : ���� ������ ��¥�� ��ȯ�� (���/���� �ڵ� �����)
SELECT LAST_DAY('22-02-01'), LAST_DAY('20-02-01'), LAST_DAY(SYSDATE) FROM DUAL;

--�� ���̺��� �� ���� �Ⱓ�� ���� ���� ȸ���̶�� �����Ͽ� ������� ��������
--���� ȸ���� ���� ������ �����ּ���.

SELECT NAME,REG_DATE,ADD_MONTHS(REG_DATE,2) AS "���� ������" FROM MEMBER;

SELECT SYSDATE FROM DUAL;

SELECT TO_CHAR(SYSDATE,'YY-MM-DD HH:MI:SS') FROM DUAL;

[4] ��ȯ�Լ�
TO_CHAR()
TO_DATE()
TO_NUMBER()

# TO_CHAR(��¥) : ��¥������ ���ڿ��� ��ȯ�Ѵ�
  TO_CHAR(����) : ���������� ���ڿ��� ��ȯ�Ѵ�
  
  
  TO_CHAR(D,�������)
  SELECT TO_CHAR(SYSDATE), TO_CHAR(SYSDATE, 'YY-MM-DD HH12:MI:SS') FROM DUAL;
  
--    �����̺��� ������ڸ� 0000-00-00 �� ���·� ����ϼ���.
SELECT REG_DATE,TO_CHAR(REG_DATE,'YYYY-MM-DD') FROM MEMBER;
	 
--    �����̺� �ִ� �� ���� �� ��Ͽ����� 2013���� 
--    ���� ������ �����ּ���.
SELECT * FROM MEMBER
WHERE TO_CHAR(REG_DATE,'YYYY')='2013';
--    �����̺� �ִ� �� ���� �� ������ڰ� 2013�� 5��1�Ϻ��� 
--    ���� ������ ����ϼ���. 
--    ��, ����� ������ ��, ���� ���̵��� �մϴ�.
SELECT NUM,USERID,AGE,MILEAGE,ADDR,NAME,TO_CHAR(REG_DATE,'YY-MM') AS REG_DATE FROM MEMBER
WHERE TO_CHAR(REG_DATE,'YY-MM-DD')<'13-05-01';

TO_CHAR(N,�������) : �������� ���ڿ��� ��ȯ

SELECT TO_CHAR(100000,'999,999'), TO_CHAR(100000,'$999G999') FROM DUAL;

--  ��ǰ ���̺��� ��ǰ�� ���� �ݾ��� ���� ǥ�� ������� ǥ���ϼ���.
--	  õ�ڸ� ���� , �� ǥ���մϴ�.
SELECT PRODUCTS_NAME,INPUT_PRICE,TO_CHAR(INPUT_PRICE,'999,999,999') "���ް���" FROM PRODUCTS;
--  ��ǰ ���̺��� ��ǰ�� �ǸŰ��� ����ϵ� ��ȭ�� ǥ���� �� ����ϴ� �����
--	  ����Ͽ� ����ϼ���.[��: \10,000]
SELECT PRODUCTS_NAME,OUTPUT_PRICE,TO_CHAR(OUTPUT_PRICE,'L999,999,999') FROM PRODUCTS;

# TO_DATE(STR, �������): ���ڿ��� ��¥ �������� ��ȯ�Ѵ�
SELECT TO_DATE('20221128','YYYYMMDD') +2 FROM DUAL;

SELECT * FROM MEMBER
WHERE REG_DATE > TO_DATE('20130601','YYYYMMDD');

# TO_NUMBER(STR,�������): ���ڿ��� ������������ ��ȯ�Ѵ�
SELECT TO_NUMBER('10,000','99,999')*2 FROM DUAL;

--'$8,590' ===> ���ڷ� ��ȯ�غ�����
select to_number('$8,590','$999g999')from dual;

select to_char(-23,'999$'),to_char(-23,'99D99') from dual;

select to_char(-23,'99.9'),to_char(-23,'99.99EEEE') from dual;

#�׷��Լ�
- �������� �� �Ǵ� ���̺� ��ü�� �����Ͽ� �ϳ��� ����� ��ȯ�ϴ� �Լ�
--count ���� ����
select count(empno) from emp;

select count(comm) from emp;
-- null ���� �����ϰ� ��

--�����ڼ� ������ (distinct �ߺ��� ������ ��)
select count(distinct mgr) from emp;
select * from emp;

--null���� �����Ͽ� ī���� (*)<<
select count(*) from emp;

create table test(a number, b number, c number);
desc test;
insert into test values(null,null,null);
--commit;
select * from test;
select count(a) from test;
select count(*) from test;

--count�� primaryŰ�� ���°� ��õ! �������Ƕ����� null���̾���

avg()
max()
min()
sum()

--emp���̺��� ��� SALESMAN�� ���Ͽ� �޿��� ���,
--	 �ְ��,������,�հ踦 ���Ͽ� ����ϼ���.
select avg(sal) "���",max(sal) "�ִ밪",min(sal) "�ּҰ�",sum(sal) "�հ�"
from emp
where job='SALESMAN';
select * from emp where job='SALESMAN';

--EMP���̺� ��ϵǾ� �ִ� �ο���, ���ʽ��� NULL�� �ƴ� �ο���,
--   ���ʽ��� ���,��ϵǾ� �ִ� �μ��� ���� ���Ͽ� ����ϼ���.
select count(empno), count(comm) , avg(comm) ,count(distinct deptno) from emp;

#group by��
group by���� �̿��Ҷ��� group by ������ ����� �÷��� �׷��Լ��� select �Ҽ� �ִ�.

--17] �� ���̺��� ������ ����, �� ������ ���� �ִ� ���ϸ��� ������ �����ּ���.
select job, max(mileage) from member group by job;

--	18] ��ǰ ���̺��� �� ��ǰī�װ����� �� �� ���� ��ǰ�� �ִ��� �����ּ���.

select category_fk, count(pnum) from products group by category_fk 
		order by category_fk asc;
--		���� �ִ� �ǸŰ��� �ּ� �ǸŰ��� �Բ� �����ּ���.

select category_fk, count(*), max(output_price),min(output_price) 
		from products group by category_fk order by category_fk asc;

--	19] ��ǰ ���̺��� �� ���޾�ü �ڵ庰�� ������ ��ǰ�� ����԰��� �����ּ���.
select ep_code_fk, avg(input_price) from products group by ep_code_fk;
--����1] ��� ���̺��� �Ի��� �⵵���� ��� ���� �����ּ���.

select to_char(hiredate,'YY'),count(empno) 
from emp group by to_char(hiredate,'YY') order by 1;

--	����2] ��� ���̺��� �ش�⵵ �� ������ �Ի��� ������� �����ּ���.
select to_char(hiredate,'YY-MM'),count(empno)from emp group by to_char(hiredate,'YY-MM'); 
--	����3] ��� ���̺��� ������ �ִ� ����, �ּ� ������ ����ϼ���.
select job,max(sal),min(sal) from emp group by job;

#having ��
- group by �� ����� ������ �־� ������ �� ����Ѵ�.
#w>g>h>o �켱����
20] �� ���̺��� ������ ������ �� ������ ���� ����� ���� 
	     2�� �̻��� �������� ������ �����ֽÿ�.
select job, count(num) from member group by job 
having count(num) >1;

21] �� ���̺��� ������ ������ �� ������ ���� �ִ� ���ϸ��� ������ �����ּ���.
	      ��, �������� �ִ� ���ϸ����� 0�� ���� ���ܽ�ŵ�ô�.
select job, max(mileage) from member 
group by job having max(mileage)<>0;

	����1] ��ǰ ���̺��� �� ī�װ����� ��ǰ�� ���� ���, �ش� ī�װ��� ��ǰ�� 2���� 
	      ��ǰ���� ������ �����ּ���.
select category_fk from products 
group by category_fk
having count(pnum)=2;
select * from products;
	����2] ��ǰ ���̺��� �� ���޾�ü �ڵ庰�� ��ǰ �ǸŰ��� ��հ� �� ������ 100������ ����
	      ���� �׸��� ������ �����ּ���.
select ep_code_fk ,avg(output_price)
from products
group by ep_code_fk having mod(avg(output_price),100)=0;