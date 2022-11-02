--day03_join.sql
--select * from emp;

부서 테이블과 사원테이블을 조인해보자.
select dept.deptno, dept.dname, emp.ename
from dept, emp
-- from dept d, emp e  <<별칭줄수잇음 별칭주면 d.deptno 가능
where dept.deptno = emp.deptno order by 1;

명시적 조인절을 이용한 조인 => 표준

select d.* , e.*
from dept d join emp e
on d.deptno = e.deptno order by 1;

SALESMAN의 사원번호,이름,급여,부서명,근무지를 출력하여라.
select e.deptno,ename,job,sal,dname,loc
from dept d join emp e
on d.deptno = e.deptno 
where job='SALESMAN';


--서로 연관이 있는 카테고리 테이블과 상품 테이블을 이용하여 각 상품별로 카테고리
--이름과 상품 이름을 함께 보여주세요.
select * from category;
select * from products;
select c.*,p.*
from category c join products p
on c.category_code = p.category_fk;

--카테고리 테이블과 상품 테이블을 조인하여 화면에 출력하되 상품의 정보 중
--제조업체가 삼성인 상품의 정보만 추출하여 카테고리 이름과 상품이름, 상품가격
--제조사 등의 정보를 화면에 보여주세요.

select category_name,products_name,output_price,company
from category c join products p
on c.category_code = p.category_fk
where p.company='삼성';

각 상품별로 카테고리 및 상품명, 가격을 출력하세요. 단 카테고리가 'TV'인 것은 
제외하고 나머지 정보는 상품의 가격이 저렴한 순으로 정렬하세요
select category_name,products_name,output_price,company
from category c join products p
on c.category_code = p.category_fk
where category_name<>'TV' order by 3;

-----------------------------------------------------------
##NON-EQUIJOIN

WHERE절 뒤의 조건절에서 두 개 이상의 테이블을 연결할 때 
조건이 EQUAL(=) 이 아닌 다른 연산 기호로 만들어지는 경우에 사용.
	
EMP와 SALGRADE 테이블 사이 관련성을 살펴보면, EMP테이블의 
어떠한 컬럼도 직접적으로 SALGRADE테이블의 한 컬럼에 상응하지 않는다.
따라서 두 테이블의 관련성은 EMP테이블의 SAL컬럼이
SALGRADE의 LOSAL과 HISAL컬럼 사이에 있다.
이 경우 NON-EQUIJOIN이다.
	   
조인 조건은 = 연산자 이외의 BETWEEN~AND 연산자를 이용한다.
-------------------------------------------------------------------------		
SELECT EMPNO,ENAME,SAL FROM EMP;
SELECT GRADE,LOSAL,HISAL FROM SALGRADE;

위 두 테이블 정보를 NON-EQUIJOIN하면

SELECT EMPNO,ENAME,SAL,GRADE,LOSAL,HISAL FROM EMP E, SALGRADE S
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;

--97] 공급업체 테이블과 상품 테이블을 조인하여 공급업체 이름, 상품명,
--		공급가를 표시하되 상품의 공급가가 100000원 이상의 상품 정보
--		만 표시하세요. 단, 여기서는 공급업체A와 공급업체B가 모두 표시
--		되도록 해야 합니다.
select p.ep_code_fk, s.ep_code,p.products_name,s.ep_name, p.input_price
from products p, supply_comp s
where (s.ep_name='공급업체B' or s.ep_name='공급업체A')
and p.input_price>=100000;

명시적 조인절일 경우
[1] left outer join : 왼쪽 테이블 기준 출력
[2] right outer join : 오른쪽 테이블 기준으로 출력
[3] full outer join : 양쪽 다 아우터 조인을 거는 경우

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

--문제98] 상품테이블의 모든 상품을 공급업체, 공급업체코드, 상품이름, 
--        상품공급가, 상품 판매가 순서로 출력하되 공급업체가 없는
--         상품도 출력하세요(상품을 기준으로).
select ep_name,ep_code,products_name,input_price,output_price
from products p right outer join supply_comp s
on p.ep_code_fk = s.ep_code
order by 3;

--문제99] 상품테이블의 모든 상품을 공급업체, 카테고리명, 상품명, 상품판매가
--	순서로 출력하세요. 단, 공급업체나 상품 카테고리가 없는 상품도
--	출력합니다.
select s.ep_name,c.category_name,products_name,output_price
from products p join category c join supply_comp s
on p.category_fk = c.category_code on p.ep_code_fk = s.ep_code;

문제99 풀이]
select ep_name,category_name,products_name,output_price
from products p left outer join supply_comp s
on p.ep_code_fk = s.ep_code
left outer join category c
on p.category_fk = c.category_code;

# self join
자기테이블과 조인하는 경우
각 사원의 정보를 출력하되 사원들의 관리자 이름도 함께 보여주세요.

select e.empno,e.ename, e.mgr, m.empno, m.ename "MANAGER"
from emp e join emp m
on e.mgr = m.empno;

[문제] emp테이블에서 "누구의 관리자는 누구이다"는 내용을 출력하세요.
select e.ename||'의관리자는 ' || m.ename || '입니다'
from emp e join emp m
on e.mgr = m.empno;

#union 
select deptno from dept union
select deptno from emp;

#union all
select deptno from dept union all
select deptno from emp;

#intersect : 교집합
select deptno from dept intersect
select deptno from emp;

--1. emp테이블에서 모든 사원에 대한 이름,부서번호,부서명을 출력하는 
--   문장을 작성하세요.

--2. emp테이블에서 NEW YORK에서 근무하고 있는 사원에 대하여 이름,업무,급여,
--    부서명을 출력하는 SELECT문을 작성하세요.
select ename,job,sal,dname,loc
from emp e join dept d
on e.deptno = d.deptno and d.loc='NEW YORK';
--3. EMP테이블에서 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력하는
--    SELECT문을 작성하세요.
select ename,job,sal,dname,loc,comm
from emp e join dept d
on e.deptno = d.deptno and e.comm is not null;
--on e.deptno = d.deptno and e.comm>0;

5. 아래의 결과를 출력하는 문장을 작성하에요(관리자가 없는 King을 포함하여
	모든 사원을 출력)

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