create table emp_10
as
select * from emp where 1<>1;

select * from emp_10;

insert into emp_10 (empno,job,ename,hiredate,mgr,sal,comm,deptno)
values(1000,'MANAGER','TOM',sysdate,null,2000,null,10);
commit;

desc emp_10;

--���̺� ������ not null�� ������ ���Ѵ�.
alter table emp_10 add constraint emp_10_ename_nn not null(ename);

--�÷��� �����ϸ鼭 not null���� �߰�
alter table emp_10 modify ename varchar2(20) not null;

insert into emp_10 (empno,job,mgr,sal,ename) 
values(1001,'salesmans',1000,3000,'JAMES');

--subquery�� Ȱ���� insert
insert into emp_10;

--insert���� �÷� ������ ���������� �÷������� ������������ 1��1�� �����ؾ��ϸ�
--�ڷ����� ũ�Ⱑ ���ƾ��Ѵ�.

select * from emp_10;

#update��
update ���̺�� set �÷���1=��1,.... where ������;

--EMP���̺��� ī���Ͽ� EMP2���̺��� ����� �����Ϳ� ������ ��� �����ϼ���
create table EMP2
as
select * from emp;
select * from emp2;
--EMP2���� ����� 7788�� ����� �μ���ȣ�� 10�� �μ��� �����ϼ���.
update emp2 set deptno=10 where empno=7788;
--EMP2���� ����� 7369�� ����� �μ��� 30�� �μ��� �޿��� 3500���� �����ϼ���
update emp2 set deptno=30,sal=3500 where empno=7369;

--2] ��ϵ� �� ���� �� ���� ���̸� ���� ���̿��� ��� 5�� ���� ������ 
--	      �����ϼ���.
create table member2
as
select * from member;
select * from member2;
update member2 set age=age+5; 
--	 2_1] �� �� 13/09/01���� ����� ������ ���ϸ����� 350���� �÷��ּ���.
update member2 set mileage = mileage+350
where reg_date>='13/09/01';

--3] ��ϵǾ� �ִ� �� ���� �� �̸��� '��'�ڰ� ����ִ� ��� �̸��� '��' ���
--	     '��'�� �����ϼ���.
update member2 set name=replace(name,'��','��') where name like '��%';

rollback;

#update �Ҷ� ���������������� �Ű�����

create table dept2
as select * from dept;

--DEPT2���̺��� DEPTNO�� ���� PRIMARY KEY ���������� �߰��ϼ���
alter table dept2 add constraint dept2_deptno_pk primary key(deptno);
--EMP2 ���̺��� DEPTNO�� ���� FOREIGN KEY ���������� �߰��ϵ� DEPT2�� DEPTNO�� �ܷ�Ű�� �����ϵ��� �ϼ���
alter table emp2 add constraint emp_deptno_fk foreign key(deptno) references dept2 (deptno);
desc emp2;
desc dept2;
select * from emp2;

#delete ��
delete from ���̺�� where ������;


-- EMP2���̺��� �����ȣ�� 7499�� ����� ������ �����϶�.
delete from emp2 where empno=7499;
select * from dept2;
select * from emp2;
-- EMP2���̺��� �ڷ� �� �μ����� 'SALES'�� ����� ������ �����϶�.
delete from emp2 
where deptno = (select deptno from dept2 where dname='SALES');
rollback;
---- PRODUCTS2 �� ���� �׽�Ʈ�ϱ�
create table products2
as
select * from products;
--1] ��ǰ ���̺� �ִ� ��ǰ �� ��ǰ�� �Ǹ� ������ 10000�� ������ ��ǰ�� ��� 
--	      �����ϼ���.
delete from products2 where output_price <= 10000;
--	2] ��ǰ ���̺� �ִ� ��ǰ �� ��ǰ�� ��з��� ������ ��ǰ�� �����ϼ���.
select * from category;
delete from products2 where category_fk
= (select category_code from category where category_name like '����%');
delete from products2;
commit;

TCL : transaction control, language
- commit
- rollback
- savepoint (ǥ�ؾƴ� ����Ŭ���� ����)

update emp2 set ename='charse' where empno=7788;
select * from emp2;

update emp2 set deptno=30 where empno=7788;

--SAVEPOINT ����Ʈ��;

savepoint point1; --������ ����

update emp2 set job='MANAGER';

rollback to savepoint point1;
-- rollback to savepoint ���̺�����Ʈ������ ����Ʈ��;
commit;