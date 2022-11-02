--- 사원테이블에서 scott의 급여보다 많은 사원의 사원번호,이름,업무
--	급여를 출력하세요.
    
select sal from emp where ename=upper('scott');
select empno,ename,job
from emp
where sal > 3000;

--subquery를 이용하여 위 2개의 구문을 합치면
--아래와 같다

select empno,ename,job
from emp
where sal > (select sal from emp where ename='SCOTT');
----------------------------------------
--#단일행 서브쿼리
--서브쿼리는 한상 오른쪽에 있어야한다
--서브쿼리는 order by 절을 포함할수 없음
--서브쿼리를 사용할 수 있는 절
--	- WHERE, HAVING, UPDATE
--	- INSERT 구문의 INTO
--	- UPDATE 구문의 SET
--	- SELECT의 FROM절
--------------------------------------------------------
문제2]사원테이블에서 급여의 평균보다 적은 사원의 사번,이름
	업무,급여,부서번호를 출력하세요.
select empno,ename,job,sal,deptno
from emp
where sal<
(select avg(sal) from emp);
사원테이블에서 사원의 급여가 20번 부서의 최소급여
		보다 많은 부서를 출력하세요.
select distinct(deptno) from emp
where sal>
(select min(sal) from emp where deptno=20);

-------------------------------------------------------
# 다중행 서브쿼르
: 서브쿼리가 1개 이상의 행을 반환하는경우
-> 다중행서브쿼리 연산자를 사용해야한다.
    in 연산자
    any
    all
    exists
-----------------------------------------------
#in 연산자문제
- 업무별로 최대 급여를 받는 사원의 
	 사원번호와 이름을 출력하세요.
select job,empno, ename, sal from emp
where(job,sal) in(
select job , max(sal)
from emp
group by job
);

#any 연산자
select deptno,ename,sal from emp
where deptno <>20 and sal> any(select sal from emp where job='SALESMAN');
any =>세일즈맨의 급여의 모든값비교해서 하나라도만족하면 출력

#all 연산자
select deptno,ename,sal from emp
where deptno <>20 and sal> all(select sal from emp where job='SALESMAN');
all => 세일즈맨의 급여의 모든값비교해서 전부다 만족하면 출력

#exists : 서브쿼리의 데이터가 존재여부에 따라 존재하는 값들만을 결과로 반환해 준다. 
-- 관리자 정보를 가져와 보여주세요
SELECT empno, ename, sal FROM emp e
WHERE EXISTS (SELECT empno FROM emp WHERE e.empno = mgr);

#다중열 서브쿼리

부서별로 최소급여를 받는 사원의 사번,이름,급여,부서번호를 출력하세요
SELECT empno,ename,job,sal,deptno FROM emp 
WHERE (deptno, sal) in
(SELECT deptno, MIN(sal) FROM EMP GROUP BY deptno)
ORDER BY deptno;
-----------------------------------------------------------------
	[문제]
	*SELECT문에서 서브쿼리 사용.
	
	84] 고객 테이블에 있는 고객 정보 중 마일리지가 
	가장 높은 금액의 고객 정보를 보여주세요.
	select * from member
    where mileage >= (select max(mileage) from member); 
	85] 상품 테이블에 있는 전체 상품 정보 중 상품의 판매가격이 
	    판매가격의 평균보다 큰  상품의 목록을 보여주세요. 
	    단, 평균을 구할 때와 결과를 보여줄 때의 판매 가격이
	    50만원을 넘어가는 상품은 제외시키세요.
    select *
    from products
    where output_price> (select avg(output_price) from products where output_price<500000)
    and output_price<500000;
	
	86] 상품 테이블에 있는 판매가격에서 평균가격 이상의 상품 목록을 구하되 평균을
	    구할 때 판매가격이 최대인 상품을 제외하고 평균을 구하세요.
    select * from products
     where output_price > (select avg(output_price) from products
        where output_price != (select max(output_price) from products)
        );
	87] 상품 카테고리 테이블에서 카테고리 이름에 컴퓨터라는 단어가 포함된 카테고리에
	    속하는 상품 목록을 보여주세요.
	select * from products
    where category_fk in (select category_code from category where category_name '%컴퓨터%');
    
	88] 고객 테이블에 있는 고객정보 중 직업의 종류별로 가장 나이가 많은 사람의 정보를
	    화면에 보여주세요.
        select * from member
        where (job,age) in(
            select job,max(age) from member
            group by job
        );

	* UPDATE에서의 사용

	89] 고객 테이블에 있는 고객 정보 중 마일리지가 가장 높은 금액을
	     가지는 고객에게 보너스 마일리지 5000점을 더 주는 SQL을 작성하세요.
	update member set mileage = mileage+5000 where mileage =(select max(mileage) from member); 
    rollback;
    select * from member;
	90] 고객 테이블에서 마일리지가 없는 고객의 등록일자를 고객 테이블의 
	      등록일자 중 가장 뒤에 등록한 날짜에 속하는 값으로 수정하세요.
    update member set reg_date = (select max(reg_date) from member)
    where mileage = 0;

	* DELETE에서의 사용
	91] 상품 테이블에 있는 상품 정보 중 공급가가 가장 큰 상품은 삭제 시키는 
	      SQL문을 작성하세요.
    delete from products where input_price=(select max(input_price) from products);
    rollback;
    select * from products;
	92] 상품 테이블에서 상품 목록을 공급 업체별로 정리한 뒤,
	     각 공급업체별로 최소 판매 가격을 가진 상품을 삭제하세요.
    delete from products where (ep_code_fk,output_price) in(
    select ep_code_fk,min(output_price) from products
    group by ep_code_fk);
# insert에서 subquery 사용
category 테이블을 카피해서 category_copy로 만들되 데이터는 없이 구조만 복사하세요
그런뒤 category 테이블에서 전자제품군만 가져와서 category_copy에 insert하세요

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


EMP에서 EMP_COPY 테이블로 구조만 복사하기         
급여등급이 3등급에 속하는 사원정보들만 EMP_COPY에 INSERT하세요

create table emp_copy
as
select * from emp where 1=2;
select * from emp_copy;

insert into emp_copy
select e.* from emp e join salgrade s
on E.SAL BETWEEN S.LOSAL AND S.HISAL and s.grade =3;

select * from emp_copy;
drop table EMP_COPY;

# from 절에서의 서브쿼리 ======> inline view
emp와 dept 테이블에서 업무가 manage인 사원의 이름, 업무 ,부서명,
근무지를 출력하세요
select ename,job,dname,loc
from emp e join dept d
using(DEPTNO)
where job='MANAGER';

서브쿼리로 동일한 문제 해결
select ename,job,dname,loc from
(select * from emp where job='MANAGER') A join dept d
on a.deptno = d.deptno;

-----------------------------------------------------

rank() over() 함수 : 분석절을 이용하여 랭킹을 매김

select ename, sal from emp
order by sal desc;

select rank() over(order by sal desc) rnk, emp.* from emp
where rnk <=5;
>> 오류가난다 rnk 인식을 못함 그래서 from으로 다시감싸줘서 인식할수있음
select * from(
select rank() over(order by sal desc) rnk, emp.* from emp
)where rnk <=5;

--------------------------------------------------
rownum() over() 함수 : 분석절을 이용하여 랭킹을 매김

select * from memo;
DELETE FROM memo
WHERE idx=1;
commit;
CREATE SEQUENCE MEMO_SEQ
START WITH 1
INCREMENT BY 1
NOCACHE;