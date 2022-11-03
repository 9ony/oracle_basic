create table emp_10
as
select * from emp where 1<>1;

select * from emp_10;

insert into emp_10 (empno,job,ename,hiredate,mgr,sal,comm,deptno)
values(1000,'MANAGER','TOM',sysdate,null,2000,null,10);
commit;

desc emp_10;

--테이블 단위로 not null을 설정을 못한다.
alter table emp_10 add constraint emp_10_ename_nn not null(ename);

--컬럼을 수정하면서 not null조건 추가
alter table emp_10 modify ename varchar2(20) not null;

insert into emp_10 (empno,job,mgr,sal,ename) 
values(1001,'salesmans',1000,3000,'JAMES');

--subquery를 활용한 insert
insert into emp_10;

--insert절의 컬럼 개수와 서브쿼리의 컬럼개수가 좌측에서부터 1대1로 대응해야하며
--자료형과 크기가 같아야한다.

select * from emp_10;

#update문
update 테이블명 set 컬럼명1=값1,.... where 조건절;

--EMP테이블을 카피하여 EMP2테이블을 만들되 데이터와 구조를 모두 복사하세요
create table EMP2
as
select * from emp;
select * from emp2;
--EMP2에서 사번이 7788인 사원의 부서번호를 10번 부서로 수정하세요.
update emp2 set deptno=10 where empno=7788;
--EMP2에서 사번이 7369인 사원의 부서를 30번 부서로 급여를 3500으로 수정하세요
update emp2 set deptno=30,sal=3500 where empno=7369;

--2] 등록된 고객 정보 중 고객의 나이를 현재 나이에서 모두 5를 더한 값으로 
--	      수정하세요.
create table member2
as
select * from member;
select * from member2;
update member2 set age=age+5; 
--	 2_1] 고객 중 13/09/01이후 등록한 고객들의 마일리지를 350점씩 올려주세요.
update member2 set mileage = mileage+350
where reg_date>='13/09/01';

--3] 등록되어 있는 고객 정보 중 이름에 '김'자가 들어있는 모든 이름을 '김' 대신
--	     '최'로 변경하세요.
update member2 set name=replace(name,'김','최') where name like '김%';

rollback;

#update 할때 무결정제약조건을 신경써야함

create table dept2
as select * from dept;

--DEPT2테이블의 DEPTNO에 대해 PRIMARY KEY 제약조건을 추가하세요
alter table dept2 add constraint dept2_deptno_pk primary key(deptno);
--EMP2 테이블의 DEPTNO에 대해 FOREIGN KEY 제약조건을 추가하되 DEPT2의 DEPTNO를 외래키로 참조하도록 하세요
alter table emp2 add constraint emp_deptno_fk foreign key(deptno) references dept2 (deptno);
desc emp2;
desc dept2;
select * from emp2;

#delete 문
delete from 테이블명 where 조건절;


-- EMP2테이블에서 사원번호가 7499인 사원의 정보를 삭제하라.
delete from emp2 where empno=7499;
select * from dept2;
select * from emp2;
-- EMP2테이블의 자료 중 부서명이 'SALES'인 사원의 정보를 삭제하라.
delete from emp2 
where deptno = (select deptno from dept2 where dname='SALES');
rollback;
---- PRODUCTS2 를 만들어서 테스트하기
create table products2
as
select * from products;
--1] 상품 테이블에 있는 상품 중 상품의 판매 가격이 10000원 이하인 상품을 모두 
--	      삭제하세요.
delete from products2 where output_price <= 10000;
--	2] 상품 테이블에 있는 상품 중 상품의 대분류가 도서인 상품을 삭제하세요.
select * from category;
delete from products2 where category_fk
= (select category_code from category where category_name like '도서%');
delete from products2;
commit;

TCL : transaction control, language
- commit
- rollback
- savepoint (표준아님 오라클에만 있음)

update emp2 set ename='charse' where empno=7788;
select * from emp2;

update emp2 set deptno=30 where empno=7788;

--SAVEPOINT 포인트명;

savepoint point1; --저장점 설정

update emp2 set job='MANAGER';

rollback to savepoint point1;
-- rollback to savepoint 세이브포인트설정한 포인트명;
commit;