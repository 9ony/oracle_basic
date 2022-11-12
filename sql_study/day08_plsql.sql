# ��Ű��
�������� ���ν���, �Լ�, Ŀ�� ���� �ϳ��� ��Ű���� ���� ������ �� �ִ�.
-�����
-���� (package body)

----�����
create or replace package empInfo as
procedure allEmp;
procedure allSal;
end empInfo;
----����
create or replace package body empInfo as
procedure allEmp
is
cursor empCr is
select empno, ename, hiredate from emp
order by 3;
begin
for k in empCr loop
    dbms_output.put_line(k.empno||lpad(k.ename,16,' ')||lpad(k.hiredate,16,' '));
end loop;
exception
    when others then
    dbms_output.put_line(SQLERRM||'������ �߻���');
end allEmp;

-- allSal�� ��ü �޿� �հ�, �����, �޿����, �ִ�޿�, �ּұ޿��� ������ ����ϴ� ���ν���

procedure allSal
is
begin
    dbms_output.put_line('�޿�����'||lpad('�����',10,' ')||lpad('��ձ޿�',10,' ')||
        lpad('�ִ�޿�',10,' ')||lpad('�ּұ޿�',10,' '));
    for k in (select sum(sal) sm, count(empno) cnt, round(avg(sal)) av,
    max(sal) mx, min(sal) mn from emp) loop
        dbms_output.put_line(k.sm||lpad(k.cnt,10,' ')||lpad(k.av,10,' ')||
        lpad(k.mx,10,' ')||lpad(k.mn,10,' '));
    end loop;
end allSal;    
end empInfo;
/


set serveroutput on
exec empInfo.allEmp;
exec empInfo.allSal;

--#TRIGGER
--INSERT, UPDATE DELETE ���� ����ɶ� ���������� ����Ǵ� ������ ���ν���

create or replace trigger trg_dept
before
update on dept
for each row
begin
    dbms_output.put_line('������ �÷���:' || :OLD.DNAME);   
    dbms_output.put_line('������ �÷���:' || :NEW.DNAME);
end;
/
select * from dept;
update dept set Dname='���' where deptno=40;
rollback;

--Ʈ���� ��Ȱ��ȭ
alter trigger trg_dept disable;
--Ʈ���� Ȱ��ȭ
alter trigger trg_dept enable;
--Ʈ���� ����
drop trigger trg_dept;

--�����ͻ������� Ʈ���� ��ȸ
select * from user_triggers;

--EMP ���̺� �����Ͱ� INSERT�ǰų� UPDATE�� ��� (BEFORE)
--��ü ������� ��ձ޿��� ����ϴ� Ʈ���Ÿ� �ۼ��ϼ���.

create or replace trigger trg_emp_avg
before insert or update on emp
--for each row -->�ึ�ٽ��� �����ϸ� ��ü�̺�Ʈ�� 1������
--when :new.empno>0
declare
avg_sal number(10);
begin
    select round(avg(sal),2) into avg_sal
    from emp;
    dbms_output.put_line('��ձ޿�: '||avg_sal);
end;
/
insert into emp(empno,ename,deptno,sal)
values(9002,'peter2',20,3000);
rollback;
select * from emp;
commit;

update emp set sal=sal*1,1 where empno=7788;
rollback;
commit;
--[Ʈ���� �ǽ� 1] �� Ʈ����
--�԰� ���̺� ��ǰ�� �԰�� ���
--��ǰ ���̺� ��ǰ ���������� �ڵ����� ����Ǵ� 
--Ʈ���Ÿ� �ۼ��غ��ô�.

create table myproduct(
pcode char(6) primary key,
pname varchar2(20) not null,
pcompany varchar2(20),
price number(8),
pqty number default 0
);

desc myproduct;

create sequence myproduct_seq
start with 1
increment by 1
nocache;

insert into myproduct
values('A00'||myproduct_seq.nextval,'��Ʈ��','a��',800000,10);

insert into myproduct
values('A00'||myproduct_seq.nextval,'������','b��',100000,20);

insert into myproduct
values('A00'||myproduct_seq.nextval,'ű����','c��',70000,30);

select * from myproduct;
--�԰� ���̺�
create table myinput(
    incode number primary key, --�԰��ȣ
    pcode_fk char(6) references myproduct (pcode), --�԰��ǰ�ڵ�
    indate date default sysdate, --�԰���
    inqty number(6), --�԰����
    inprice number(8) --�԰���
);
create sequence myinput_seq nocache; --start with������ �⺻���� 1���ͽ���
--drop  sequence myinput_seq;
--�԰� ���̺� ��ǰ�� ������
--��ǰ ���̺��� ���������� �����ϴ� Ʈ���Ÿ� �ۼ��ϼ���

create or replace trigger trg_input_product
after
insert on myinput
for each row
declare 
    cnt number := :new.inqty;
    code char(6) := :new.pcode_fk;
begin
    update myproduct set pqty = pqty+cnt where pcode = code;
end;
/

--�԰� ���̺� a001��ǰ�� 10�� 500000���� insert�ϱ�

select * from myproduct;
select * from myinput;
insert into myinput
values(myinput_seq.nextval,'A002',sysdate,8,50000);
--delete myinput where incode=8;
update myproduct set pqty=pqty-8 where pcode='A002';
rollback;
commit;
--�԰� ���̺��� ������ ����� ���-UPDATE���� ����� ��
--��ǰ ���̺��� ������ �����ϴ� Ʈ���Ÿ� �ۼ��ϼ���
create or replace trigger trg_input_product2
after update on myinput
for each row
declare 
    GAP number;
begin
    gap:= :new.inqty - :old.inqty;
    update myproduct set pqty = pqty+gap where pcode =:new.pcode_fk;
    dbms_output.put_line('new: '||:new.inqty||', old: '||:old.inqty||', gap: '||gap);
end;
/

select * from myproduct;
select * from myinput;
update myinput set inqty=10 where incode=1;
update myinput set inqty=18 where incode=2;

select * from user_triggers;
select * from user_objects where object_type='TRIGGER';

--[Ʈ���� �ǽ�2] - ���� Ʈ����
--EMP ���̺� ���Ի���� ������(INSERT) �α� ����� ������
--� DML������ �����ߴ���, DML�� ����� ������ �ð�, USER �����͸�
--EMP_LOG���̺� �������.
create table emp_log(
    log_code number primary key,
    user_id varchar2(30),
    log_date date default sysdate,
    behavior varchar2(20)
);
create sequence emp_log_seq nocache;

create or replace trigger trg_emp_log
before insert on emp
begin
    if(to_char(sysdate,'dy') in ('fri','sat','sun')) then
        RAISE_APPLICATION_ERROR(-20001,'��,��,�Ͽ��� �Է��۾��� �Ҽ� �����ϴ�');
    else
        insert into emp_log values(emp_log_seq.nextval,user,sysdate,'insert');
    end if;
end;
/

--emp�� ���,�����, �޿�, �μ���ȣ�� ���� insert�ϼ���
insert into emp(empno,ename,sal,deptno)
values(9010,'thomas',3300,20);
select * from emp;
select * from emp_log;
select * from memo;
delete memo where idx=23;
commit;
--�ǽ���������
--CREATE USER MULTI
--IDENTIFIED BY tiger;
--
--grant connect, resource to multi;