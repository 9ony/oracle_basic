--day05_object.sql
/*
# ������
����
CREATE SEQUENCE ��������
[INCREMENT BY n] --����ġ
[START WITH n] -- ���۰�
[{MAXVALUE n | NOMAXVALUE}] -- �ִ밪
[{MINVALUE n | NOMINVALUE}] -- �ּҰ�
[{CYCLE | NOCYCLE}] -- �ִ�, �ּҿ� ������ �� ��� ���� �������� ���θ� ���� nocycle 0 �� �⺻
[{CACHE | NOCACHE}] -- �޸� ĳ�� ����Ʈ ������ 20
*/
create sequence dept2_seq
increment by 5
start with 50
maxvalue 95
nocache
nocycle;

�����ͻ������� ������ ��ȸ
select * from user_sequences;

������ ���
-nextval : ������ ������
-currval : ������ ���簪
[����] nextval�� ȣ����� ���� �󤼾ֿ��� currval�� ���Ǹ� ������ ����.

select dept2_seq.currval from dual; ==> ���� �߻���

select dept2_seq.nextval from dual;

select dept2_seq.currval from dual; 

insert into dept2(deptno,dname,loc)
values(dept2_seq.nextval,'sales','seoul');

select * from dept2;

select dept2_seq.currval from dual;

��������: TEMP_SEQ
���۰�: 100���� ����
����ġ: 5��ŭ�� ����
�ּҰ��� 0����
CYCLE �ɼ� �ֱ�
ĳ�û�� ���� �ʵ���

create sequence temp_seq
increment by -5
start with 100
minvalue 0
maxvalue 100
nocache
cycle;

select * from user_sequences where sequence_name='temp_seq';

select temp_seq.nextval from dual;

#�ñǽ� ����
[���ǻ���] ���۰��� ������ �� ����. ���۰��� �����Ϸ��� drop�ϰ� �ٽ� create �Ѵ�.
alter SEQUENCE ��������
[INCREMENT BY n] --����ġ
--[START WITH n] -- �����Ұ�!!
[{MAXVALUE n | NOMAXVALUE}] -- �ִ밪
[{MINVALUE n | NOMINVALUE}] -- �ּҰ�
[{CYCLE | NOCYCLE}] -- �ִ�, �ּҿ� ������ �� ��� ���� �������� ���θ� ���� nocycle 0 �� �⺻
[{CACHE | NOCACHE}] -- �޸� ĳ�� ����Ʈ ������ 20

dept2_seq�� �����ϵ� maxvalue�� 1000����
����ġ 1�� �����ϵ��� �����ϼ���.
alter SEQUENCE dept2_seq
maxvalue 1000
increment by 1;

select * from user_sequences where sequence_name = 'dept2_seq';

#������ ����
drio sequence  ��������;

creat view ���̸�
as
select �÷���1,�÷���2...
from �信 ����� ���̺��
where ����

--emp ���̺��� 20�� �μ��� ��� �÷��� �����ϴ� emp20_view�� �����϶�
create view emp20_view
as select * from emp where deptno=10;

select * from emp20_view;

select * from user_view;

desc emp20_view;

# view ����
drop view ���̸�;

drop view emp20_view;

# view ����
--���� ���̺��� �����ϸ� �䰡 �����ǰ� �並 �����ص� �������̺� �����ȴ�.
create or replace ���̸�
as select��;

--[����] 
--	�����̺��� �� ���� �� ���̰� 19�� �̻���
--	���� ������
--	Ȯ���ϴ� �並 ��������.
--	�� ���� �̸��� MEMBER_19�� �ϼ���.
create or replace view member_19
as select * from member where age>=19;

select * from member_19;

create or replace view member_19
as select * from member where age >= 40;

--emp���̺��� 30�� �μ��� empno�� emp_no�� ename�� name����
--sal�� salary�� �ٲپ� emp30_view�� �����϶�

create or replace view emp30_view
as select empno emp_no,ename name, sal salary from emp
where deptno=30;

select * from emp30_view;

create or replace view emp30_view(eno, name, salary,dno)
as select empno, ename, sal, deptno from emp
where deptno=30;

7499����� emp���� 20�� �μ��� �̵���Ű����.
update emp set deptno=20 where empno=7499;
select * from emp;

create view emp_dept_view
as select * from emp e join dept d using(deptno);

select * from emp_dept_view;

# with read only �ɼ�
with read only �ɼ��� �ָ� �信 dml������ ������ �� ����.

create or replace view emp10_view
as select empno,ename,job, deptno
from emp where deptno=10
with read only;

select * from emp10_view;

update emp10_view set job='salesman' where empno=7782;
--===>cannot perform a DML operation on a read-only view ���� �б⸸����

# with check option �ɼ�

emp���� job�� salesman�� ����鸸 ��Ƽ� emp_sales_view �����
with check option�� �ּ���

create or replace view emp_sales_view
as select * from emp where job='SALESMAN'
with check option;
==> where������
select * from emp_sales_view;

update emp_sales_view set deptno=10 where empno=7499;
==>����������

update emp_sales_view set job='MANAGER' where ename='WARD';
==> view with check option where-clause violation

# inline view
from ������ ���� ���������� �ζ��κ��� �Ѵ�
--EMP���� ���ټ��� 3�� �̾Ƽ� �ؿܿ����� �������� �Ѵ�
--3���� �����ϼ���
create or replace view EMP_OLD_VIEW
as select * from emp order by hiredate ASC;


select * from emp_old_view;

select rownum, empno,ename,hiredate from emp_old_view where rownum<4;
select * from(
select rownum rn, A.* from
(select * from emp order by hiredate asc) A
)where rn >2 and rn <=4;

#index
- �ڵ� ����: 
	  PK�� UNIQUE ���� ������ �����ϸ� UNIQUE �ε�����
	  �ڵ������� �����ȴ�.
	- ����ڰ� ����: 
	  COLUMN�� UNIQUE�ε��� �Ǵ� NON-UNIQUE �ε�����
	  �����Ѵ�.
	* unique index : ������ ���� ���� �������� ����
	* non-unique index: ������ ���� ���� �ߺ��� ���
    
CREATE INDEX �ε����� ON ���̺��(�÷���[,�÷���]...)
	**����: �ε����� NOT NULL�� �÷����� 
	  ����� �� �ִ�.
	  NULL�� ��쿡�� �ε����� ������ �� ���� 
	  ������ ��� �Ұ�.
      
emp���� ����� �ε����� �����ϼ���
emp_ename_indx

create index emp_ename_indx on emp(ename);
select * from emp where ename='SCOTT';

�ε����� �����ϸ� ���������� �ش� �÷��� �ϰϼ� �������� ������ �Ѵ�.
rowid�� ename�� �����ϱ� ���� ��������� �Ҵ��� �� ���� �����Ѵ�.

select * from user_objects where object_type='INDEX';

select * from user_objects where object_type='VIEW';

��ǰ ���̺��� �ε����� �ɾ�θ� ���� �÷��� ã�� �ε����� ���弼��.
create index products_category_fk_indx on products (CATEGORY_FK);
create index products_ep_code_fk_indx on products (EP_CODE_FK);
--select * from
--(select * from PRODUCTS P join
--(select * from CATEGORY C join SUPPLY_COMP S) A);

#index ����
EMP_ENAME_INDX �ε����� �����ϼ���


#index ����
index������ ������ۿ�����!

create [public] synonym �ó�Ը� for ��ü
public�� dba�� �ټ��ִ�.
���Ǿ� ���� ���ѵ� �ο� �޾ƾ� �� �� �ִ�.
system�������� �����ؼ�
grant create synonym to ���Ѻο��Ұ�����;

�����ͻ������� ��ȸ
select * from user_objects
where object_type='synonym';

���Ǿ� ����
drop synonym ���Ǿ��;

drop synonym note;

select * from note;

select * from mystar.mystarstablenote;

select * from emp;
rollback;