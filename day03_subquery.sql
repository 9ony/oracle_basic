--- ������̺��� scott�� �޿����� ���� ����� �����ȣ,�̸�,����
--	�޿��� ����ϼ���.
    
select sal from emp where ename=upper('scott');
select empno,ename,job
from emp
where sal > 3000;

--subquery�� �̿��Ͽ� �� 2���� ������ ��ġ��
--�Ʒ��� ����

select empno,ename,job
from emp
where sal > (select sal from emp where ename='SCOTT');
----------------------------------------
--#������ ��������
--���������� �ѻ� �����ʿ� �־���Ѵ�
--���������� order by ���� �����Ҽ� ����
--���������� ����� �� �ִ� ��
--	- WHERE, HAVING, UPDATE
--	- INSERT ������ INTO
--	- UPDATE ������ SET
--	- SELECT�� FROM��
--------------------------------------------------------
����2]������̺��� �޿��� ��պ��� ���� ����� ���,�̸�
	����,�޿�,�μ���ȣ�� ����ϼ���.
select empno,ename,job,sal,deptno
from emp
where sal<
(select avg(sal) from emp);
������̺��� ����� �޿��� 20�� �μ��� �ּұ޿�
		���� ���� �μ��� ����ϼ���.
select distinct(deptno) from emp
where sal>
(select min(sal) from emp where deptno=20);

-------------------------------------------------------
# ������ ��������
: ���������� 1�� �̻��� ���� ��ȯ�ϴ°��
-> �����༭������ �����ڸ� ����ؾ��Ѵ�.
    in ������
    any
    all
    exists
-----------------------------------------------
#in �����ڹ���
- �������� �ִ� �޿��� �޴� ����� 
	 �����ȣ�� �̸��� ����ϼ���.
select job,empno, ename, sal from emp
where(job,sal) in(
select job , max(sal)
from emp
group by job
);

#any ������
select deptno,ename,sal from emp
where deptno <>20 and sal> any(select sal from emp where job='SALESMAN');
any =>��������� �޿��� ��簪���ؼ� �ϳ��󵵸����ϸ� ���

#all ������
select deptno,ename,sal from emp
where deptno <>20 and sal> all(select sal from emp where job='SALESMAN');
all => ��������� �޿��� ��簪���ؼ� ���δ� �����ϸ� ���

#exists : ���������� �����Ͱ� ���翩�ο� ���� �����ϴ� ���鸸�� ����� ��ȯ�� �ش�. 
-- ������ ������ ������ �����ּ���
SELECT empno, ename, sal FROM emp e
WHERE EXISTS (SELECT empno FROM emp WHERE e.empno = mgr);

#���߿� ��������

�μ����� �ּұ޿��� �޴� ����� ���,�̸�,�޿�,�μ���ȣ�� ����ϼ���
SELECT empno,ename,job,sal,deptno FROM emp 
WHERE (deptno, sal) in
(SELECT deptno, MIN(sal) FROM EMP GROUP BY deptno)
ORDER BY deptno;
-----------------------------------------------------------------
	[����]
	*SELECT������ �������� ���.
	
	84] �� ���̺� �ִ� �� ���� �� ���ϸ����� 
	���� ���� �ݾ��� �� ������ �����ּ���.
	select * from member
    where mileage >= (select max(mileage) from member); 
	85] ��ǰ ���̺� �ִ� ��ü ��ǰ ���� �� ��ǰ�� �ǸŰ����� 
	    �ǸŰ����� ��պ��� ū  ��ǰ�� ����� �����ּ���. 
	    ��, ����� ���� ���� ����� ������ ���� �Ǹ� ������
	    50������ �Ѿ�� ��ǰ�� ���ܽ�Ű����.
    select *
    from products
    where output_price> (select avg(output_price) from products where output_price<500000)
    and output_price<500000;
	
	86] ��ǰ ���̺� �ִ� �ǸŰ��ݿ��� ��հ��� �̻��� ��ǰ ����� ���ϵ� �����
	    ���� �� �ǸŰ����� �ִ��� ��ǰ�� �����ϰ� ����� ���ϼ���.
    select * from products
     where output_price > (select avg(output_price) from products
        where output_price != (select max(output_price) from products)
        );
	87] ��ǰ ī�װ� ���̺��� ī�װ� �̸��� ��ǻ�Ͷ�� �ܾ ���Ե� ī�װ���
	    ���ϴ� ��ǰ ����� �����ּ���.
	select * from products
    where category_fk in (select category_code from category where category_name '%��ǻ��%');
    
	88] �� ���̺� �ִ� ������ �� ������ �������� ���� ���̰� ���� ����� ������
	    ȭ�鿡 �����ּ���.
        select * from member
        where (job,age) in(
            select job,max(age) from member
            group by job
        );

	* UPDATE������ ���

	89] �� ���̺� �ִ� �� ���� �� ���ϸ����� ���� ���� �ݾ���
	     ������ ������ ���ʽ� ���ϸ��� 5000���� �� �ִ� SQL�� �ۼ��ϼ���.
	update member set mileage = mileage+5000 where mileage =(select max(mileage) from member); 
    rollback;
    select * from member;
	90] �� ���̺��� ���ϸ����� ���� ���� ������ڸ� �� ���̺��� 
	      ������� �� ���� �ڿ� ����� ��¥�� ���ϴ� ������ �����ϼ���.
    update member set reg_date = (select max(reg_date) from member)
    where mileage = 0;

	* DELETE������ ���
	91] ��ǰ ���̺� �ִ� ��ǰ ���� �� ���ް��� ���� ū ��ǰ�� ���� ��Ű�� 
	      SQL���� �ۼ��ϼ���.
    delete from products where input_price=(select max(input_price) from products);
    rollback;
    select * from products;
	92] ��ǰ ���̺��� ��ǰ ����� ���� ��ü���� ������ ��,
	     �� ���޾�ü���� �ּ� �Ǹ� ������ ���� ��ǰ�� �����ϼ���.
    delete from products where (ep_code_fk,output_price) in(
    select ep_code_fk,min(output_price) from products
    group by ep_code_fk);
# insert���� subquery ���
category ���̺��� ī���ؼ� category_copy�� ����� �����ʹ� ���� ������ �����ϼ���
�׷��� category ���̺��� ������ǰ���� �����ͼ� category_copy�� insert�ϼ���

create table category_copy
as
select * from CATEGORY;

select * from category_copy;
DROP TABLE CATEGORY_COPY;

create table category_copy
as
select * from CATEGORY where 1=2;

insert into category_copy
select * from category
where category_code like '0001%';

select * from category_copy;
DROP TABLE CATEGORY_COPY;


EMP���� EMP_COPY ���̺�� ������ �����ϱ�         
�޿������ 3��޿� ���ϴ� ��������鸸 EMP_COPY�� INSERT�ϼ���

create table emp_copy
as
select * from emp where 1=2;
select * from emp_copy;

insert into emp_copy
select e.* from emp e join salgrade s
on E.SAL BETWEEN S.LOSAL AND S.HISAL and s.grade =3;

select * from emp_copy;
drop table EMP_COPY;

# from �������� �������� ======> inline view
emp�� dept ���̺��� ������ manage�� ����� �̸�, ���� ,�μ���,
�ٹ����� ����ϼ���
select ename,job,dname,loc
from emp e join dept d
using(DEPTNO)
where job='MANAGER';

���������� ������ ���� �ذ�
select ename,job,dname,loc from
(select * from emp where job='MANAGER') A join dept d
on a.deptno = d.deptno;

-----------------------------------------------------

rank() over() �Լ� : �м����� �̿��Ͽ� ��ŷ�� �ű�

select ename, sal from emp
order by sal desc;

select rank() over(order by sal desc) rnk, emp.* from emp
where rnk <=5;
>> ���������� rnk �ν��� ���� �׷��� from���� �ٽð����༭ �ν��Ҽ�����
select * from(
select rank() over(order by sal desc) rnk, emp.* from emp
)where rnk <=5;

--------------------------------------------------
rownum() over() �Լ� : �м����� �̿��Ͽ� ��ŷ�� �ű�

select * from memo;
DELETE FROM memo
WHERE idx=1;
commit;
CREATE SEQUENCE MEMO_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE;