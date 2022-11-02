--day03_join.sql
--select * from emp;

�μ� ���̺�� ������̺��� �����غ���.
select dept.deptno, dept.dname, emp.ename
from dept, emp
-- from dept d, emp e  <<��Ī�ټ����� ��Ī�ָ� d.deptno ����
where dept.deptno = emp.deptno order by 1;

����� �������� �̿��� ���� => ǥ��

select d.* , e.*
from dept d join emp e
on d.deptno = e.deptno order by 1;

SALESMAN�� �����ȣ,�̸�,�޿�,�μ���,�ٹ����� ����Ͽ���.
select e.deptno,ename,job,sal,dname,loc
from dept d join emp e
on d.deptno = e.deptno 
where job='SALESMAN';


--���� ������ �ִ� ī�װ� ���̺�� ��ǰ ���̺��� �̿��Ͽ� �� ��ǰ���� ī�װ�
--�̸��� ��ǰ �̸��� �Բ� �����ּ���.
select * from category;
select * from products;
select c.*,p.*
from category c join products p
on c.category_code = p.category_fk;

--ī�װ� ���̺�� ��ǰ ���̺��� �����Ͽ� ȭ�鿡 ����ϵ� ��ǰ�� ���� ��
--������ü�� �Ｚ�� ��ǰ�� ������ �����Ͽ� ī�װ� �̸��� ��ǰ�̸�, ��ǰ����
--������ ���� ������ ȭ�鿡 �����ּ���.

select category_name,products_name,output_price,company
from category c join products p
on c.category_code = p.category_fk
where p.company='�Ｚ';

�� ��ǰ���� ī�װ� �� ��ǰ��, ������ ����ϼ���. �� ī�װ��� 'TV'�� ���� 
�����ϰ� ������ ������ ��ǰ�� ������ ������ ������ �����ϼ���
select category_name,products_name,output_price,company
from category c join products p
on c.category_code = p.category_fk
where category_name<>'TV' order by 3;

-----------------------------------------------------------
##NON-EQUIJOIN

WHERE�� ���� ���������� �� �� �̻��� ���̺��� ������ �� 
������ EQUAL(=) �� �ƴ� �ٸ� ���� ��ȣ�� ��������� ��쿡 ���.
	
EMP�� SALGRADE ���̺� ���� ���ü��� ���캸��, EMP���̺��� 
��� �÷��� ���������� SALGRADE���̺��� �� �÷��� �������� �ʴ´�.
���� �� ���̺��� ���ü��� EMP���̺��� SAL�÷���
SALGRADE�� LOSAL�� HISAL�÷� ���̿� �ִ�.
�� ��� NON-EQUIJOIN�̴�.
	   
���� ������ = ������ �̿��� BETWEEN~AND �����ڸ� �̿��Ѵ�.
-------------------------------------------------------------------------		
SELECT EMPNO,ENAME,SAL FROM EMP;
SELECT GRADE,LOSAL,HISAL FROM SALGRADE;

�� �� ���̺� ������ NON-EQUIJOIN�ϸ�

SELECT EMPNO,ENAME,SAL,GRADE,LOSAL,HISAL FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;

--97] ���޾�ü ���̺�� ��ǰ ���̺��� �����Ͽ� ���޾�ü �̸�, ��ǰ��,
--		���ް��� ǥ���ϵ� ��ǰ�� ���ް��� 100000�� �̻��� ��ǰ ����
--		�� ǥ���ϼ���. ��, ���⼭�� ���޾�üA�� ���޾�üB�� ��� ǥ��
--		�ǵ��� �ؾ� �մϴ�.
select p.ep_code_fk, s.ep_code,p.products_name,s.ep_name, p.input_price
from products p, supply_comp s
where (s.ep_name='���޾�üB' or s.ep_name='���޾�üA')
and p.input_price>=100000;

����� �������� ���
[1] left outer join : ���� ���̺� ���� ���
[2] right outer join : ������ ���̺� �������� ���
[3] full outer join : ���� �� �ƿ��� ������ �Ŵ� ���

[1] left outer join
SELECT DISTINCT(e.deptno), d.deptno 
FROM dept d LEFT OUTER JOIN emp e 
ON d.deptno = e.deptno order by 1;

[2] right outer join
SELECT DISTINCT(e.deptno), d.deptno 
FROM dept d right OUTER JOIN emp e 
ON d.deptno = e.deptno order by 1;  

[3] full outer join
SELECT DISTINCT(e.deptno), d.deptno 
FROM dept d full OUTER JOIN emp e 
ON d.deptno = e.deptno order by 1; 

--����98] ��ǰ���̺��� ��� ��ǰ�� ���޾�ü, ���޾�ü�ڵ�, ��ǰ�̸�, 
--        ��ǰ���ް�, ��ǰ �ǸŰ� ������ ����ϵ� ���޾�ü�� ����
--         ��ǰ�� ����ϼ���(��ǰ�� ��������).
select ep_name,ep_code,products_name,input_price,output_price
from products p right outer join supply_comp s
on p.ep_code_fk = s.ep_code
order by 3;

--����99] ��ǰ���̺��� ��� ��ǰ�� ���޾�ü, ī�װ���, ��ǰ��, ��ǰ�ǸŰ�
--	������ ����ϼ���. ��, ���޾�ü�� ��ǰ ī�װ��� ���� ��ǰ��
--	����մϴ�.
select s.ep_name,c.category_name,products_name,output_price
from products p join category c join supply_comp s
on p.category_fk = c.category_code on p.ep_code_fk = s.ep_code;

����99 Ǯ��]
select ep_name,category_name,products_name,output_price
from products p left outer join supply_comp s
on p.ep_code_fk = s.ep_code
left outer join category c
on p.category_fk = c.category_code;

# self join
�ڱ����̺�� �����ϴ� ���
�� ����� ������ ����ϵ� ������� ������ �̸��� �Բ� �����ּ���.

select e.empno,e.ename, e.mgr, m.empno, m.ename "MANAGER"
from emp e join emp m
on e.mgr = m.empno;

[����] emp���̺��� "������ �����ڴ� �����̴�"�� ������ ����ϼ���.
select e.ename||'�ǰ����ڴ� ' || m.ename || '�Դϴ�'
from emp e join emp m
on e.mgr = m.empno;

#union 
select deptno from dept union
select deptno from emp;

#union all
select deptno from dept union all
select deptno from emp;

#intersect : ������
select deptno from dept intersect
select deptno from emp;

--1. emp���̺��� ��� ����� ���� �̸�,�μ���ȣ,�μ����� ����ϴ� 
--   ������ �ۼ��ϼ���.

--2. emp���̺��� NEW YORK���� �ٹ��ϰ� �ִ� ����� ���Ͽ� �̸�,����,�޿�,
--    �μ����� ����ϴ� SELECT���� �ۼ��ϼ���.
select ename,job,sal,dname,loc
from emp e join dept d
on e.deptno = d.deptno and d.loc='NEW YORK';
--3. EMP���̺��� ���ʽ��� �޴� ����� ���Ͽ� �̸�,�μ���,��ġ�� ����ϴ�
--    SELECT���� �ۼ��ϼ���.
select ename,job,sal,dname,loc,comm
from emp e join dept d
on e.deptno = d.deptno and e.comm is not null;
--on e.deptno = d.deptno and e.comm>0;

5. �Ʒ��� ����� ����ϴ� ������ �ۼ��Ͽ���(�����ڰ� ���� King�� �����Ͽ�
	��� ����� ���)

	---------------------------------------------
	Emplyee		Emp#		Manager	Mgr#
	---------------------------------------------
	KING		7839
	BLAKE		7698		KING		7839
	CKARK		7782		KING		7839
	.....
	---------------------------------------------

select e.ename "Emplyee",e.empno "Emp#",m.ename "Manager", m.empno "Mgr#"
from emp e left outer join emp m
on e.mgr = m.empno order by 3 desc;
--where m.ename='KING';