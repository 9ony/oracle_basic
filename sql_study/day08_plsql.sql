# 패키지
여러개의 프로시저, 함수, 커서 등을 하나의 패키지로 묶어 관리할 수 있다.
-선언부
-본문 (package body)

----선언부
create or replace package empInfo as
procedure allEmp;
procedure allSal;
end empInfo;
----본문
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
    dbms_output.put_line(SQLERRM||'에러가 발생함');
end allEmp;

-- allSal은 전체 급여 합계, 사원수, 급여평균, 최대급여, 최소급여를 가져와 출력하는 프로시저

procedure allSal
is
begin
    dbms_output.put_line('급여총합'||lpad('사원수',10,' ')||lpad('평균급여',10,' ')||
        lpad('최대급여',10,' ')||lpad('최소급여',10,' '));
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
--INSERT, UPDATE DELETE 문이 실행될때 묵시적으로 수행되는 일종의 프로시저

create or replace trigger trg_dept
before
update on dept
for each row
begin
    dbms_output.put_line('변경전 컬럼갑:' || :OLD.DNAME);   
    dbms_output.put_line('변경후 컬럼갑:' || :NEW.DNAME);
end;
/
select * from dept;
update dept set Dname='운영부' where deptno=40;
rollback;

--트리거 비활성화
alter trigger trg_dept disable;
--트리거 활성화
alter trigger trg_dept enable;
--트리거 삭제
drop trigger trg_dept;

--데이터사전에서 트리거 조회
select * from user_triggers;

--EMP 테이블에 데이터가 INSERT되거나 UPDATE될 경우 (BEFORE)
--전체 사원들의 평균급여를 출력하는 트리거를 작성하세요.

create or replace trigger trg_emp_avg
before insert or update on emp
--for each row -->행마다실행 생략하면 전체이벤트에 1번수행
--when :new.empno>0
declare
avg_sal number(10);
begin
    select round(avg(sal),2) into avg_sal
    from emp;
    dbms_output.put_line('평균급여: '||avg_sal);
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
--[트리거 실습 1] 행 트리거
--입고 테이블에 상품이 입고될 경우
--상품 테이블에 상품 보유수량이 자동으로 변경되는 
--트리거를 작성해봅시다.

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
values('A00'||myproduct_seq.nextval,'노트북','a사',800000,10);

insert into myproduct
values('A00'||myproduct_seq.nextval,'자전거','b사',100000,20);

insert into myproduct
values('A00'||myproduct_seq.nextval,'킥보드','c사',70000,30);

select * from myproduct;
--입고 테이블
create table myinput(
    incode number primary key, --입고번호
    pcode_fk char(6) references myproduct (pcode), --입고상품코드
    indate date default sysdate, --입고일
    inqty number(6), --입고수량
    inprice number(8) --입고가격
);
create sequence myinput_seq nocache; --start with생략시 기본으로 1부터시작
--drop  sequence myinput_seq;
--입고 테이블에 상품이 들어오면
--상품 테이블의 보유수량을 변경하는 트리거를 작성하세요

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

--입고 테이블에 a001상품을 10개 500000원에 insert하기

select * from myproduct;
select * from myinput;
insert into myinput
values(myinput_seq.nextval,'A002',sysdate,8,50000);
--delete myinput where incode=8;
update myproduct set pqty=pqty-8 where pcode='A002';
rollback;
commit;
--입고 테이블의 수량이 변경될 경우-UPDATE문이 실행될 때
--상품 테이블의 수량을 수정하는 트리거를 작성하세요
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

--[트리거 실습2] - 문장 트리거
--EMP 테이블에 신입사원이 들어오면(INSERT) 로그 기록을 남기자
--어떤 DML문장을 실행했는지, DML이 수행된 시점의 시간, USER 데이터를
--EMP_LOG테이블에 기록하자.
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
        RAISE_APPLICATION_ERROR(-20001,'금,토,일에는 입력작업을 할수 없습니다');
    else
        insert into emp_log values(emp_log_seq.nextval,user,sysdate,'insert');
    end if;
end;
/

--emp에 사번,사원명, 급여, 부서번호를 새로 insert하세요
insert into emp(empno,ename,sal,deptno)
values(9010,'thomas',3300,20);
select * from emp;
select * from emp_log;
select * from memo;
delete memo where idx=23;
commit;
--실습계정생성
--CREATE USER MULTI
--IDENTIFIED BY tiger;
--
--grant connect, resource to multi;