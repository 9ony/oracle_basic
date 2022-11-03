--day05_object.sql
/*
# 시퀀스
구문
CREATE SEQUENCE 시퀀스명
[INCREMENT BY n] --증가치
[START WITH n] -- 시작값
[{MAXVALUE n | NOMAXVALUE}] -- 최대값
[{MINVALUE n | NOMINVALUE}] -- 최소값
[{CYCLE | NOCYCLE}] -- 최대, 최소에 도달한 후 계속 값을 생성할지 여부를 지정 nocycle 0 이 기본
[{CACHE | NOCACHE}] -- 메모리 캐시 디폴트 사이즈 20
*/
create sequence dept2_seq
increment by 5
start with 50
maxvalue 95
nocache
nocycle;

데이터사전에서 시퀀스 조회
select * from user_sequences;

시퀀스 사용
-nextval : 시퀀스 다음값
-currval : 시퀀스 현재값
[주의] nextval이 호출되지 않은 상ㅌ애에서 currval이 사용되면 에러가 난다.

select dept2_seq.currval from dual; ==> 에러 발생함

select dept2_seq.nextval from dual;

select dept2_seq.currval from dual; 

insert into dept2(deptno,dname,loc)
values(dept2_seq.nextval,'sales','seoul');

select * from dept2;

select dept2_seq.currval from dual;

시퀀스명: TEMP_SEQ
시작값: 100부터 시작
증가치: 5만큼씩 감소
최소값은 0으로
CYCLE 옵션 주기
캐시사용 하지 않도록

create sequence temp_seq
increment by -5
start with 100
minvalue 0
maxvalue 100
nocache
cycle;

select * from user_sequences where sequence_name='temp_seq';

select temp_seq.nextval from dual;

#시권스 수정
[주의사항] 시작값은 수정할 수 없다. 시작값을 수정하려면 drop하고 다시 create 한다.
alter SEQUENCE 시퀀스명
[INCREMENT BY n] --증가치
--[START WITH n] -- 수정불가!!
[{MAXVALUE n | NOMAXVALUE}] -- 최대값
[{MINVALUE n | NOMINVALUE}] -- 최소값
[{CYCLE | NOCYCLE}] -- 최대, 최소에 도달한 후 계속 값을 생성할지 여부를 지정 nocycle 0 이 기본
[{CACHE | NOCACHE}] -- 메모리 캐시 디폴트 사이즈 20

dept2_seq를 수정하되 maxvalue는 1000까지
증가치 1씩 증가하도록 수정하세요.
alter SEQUENCE dept2_seq
maxvalue 1000
increment by 1;

select * from user_sequences where sequence_name = 'dept2_seq';

#시퀀스 삭제
drio sequence  시퀀스명;

creat view 뷰이름
as
select 컬럼명1,컬럼명2...
from 뷰에 사용할 테이블명
where 조건

--emp 테이블에서 20번 부서의 모든 컬럼을 포함하는 emp20_view를 생성하라
create view emp20_view
as select * from emp where deptno=10;

select * from emp20_view;

select * from user_view;

desc emp20_view;

# view 삭제
drop view 뷰이름;

drop view emp20_view;

# view 수정
--원래 테이블을 수정하면 뷰가 수정되고 뷰를 수정해도 원래테이블도 수정된다.
create or replace 뷰이름
as select문;

--[문제] 
--	고객테이블의 고객 정보 중 나이가 19세 이상인
--	고객의 정보를
--	확인하는 뷰를 만들어보세요.
--	단 뷰의 이름은 MEMBER_19로 하세요.
create or replace view member_19
as select * from member where age>=19;

select * from member_19;

create or replace view member_19
as select * from member where age >= 40;

--emp테이블에서 30번 부서만 empno를 emp_no로 ename을 name으로
--sal를 salary로 바꾸어 emp30_view를 생성하라

create or replace view emp30_view
as select empno emp_no,ename name, sal salary from emp
where deptno=30;

select * from emp30_view;

create or replace view emp30_view(eno, name, salary,dno)
as select empno, ename, sal, deptno from emp
where deptno=30;

7499사원을 emp에서 20번 부서로 이동시키세요.
update emp set deptno=20 where empno=7499;
select * from emp;

create view emp_dept_view
as select * from emp e join dept d using(deptno);

select * from emp_dept_view;

# with read only 옵션
with read only 옵션을 주면 뷰에 dml문장을 수행할 수 없다.

create or replace view emp10_view
as select empno,ename,job, deptno
from emp where deptno=10
with read only;

select * from emp10_view;

update emp10_view set job='salesman' where empno=7782;
--===>cannot perform a DML operation on a read-only view 오류 읽기만가능

# with check option 옵션

emp에서 job이 salesman인 사람들만 모아서 emp_sales_view 만들되
with check option을 주세요

create or replace view emp_sales_view
as select * from emp where job='SALESMAN'
with check option;
==> where절에서
select * from emp_sales_view;

update emp_sales_view set deptno=10 where empno=7499;
==>수정가능함

update emp_sales_view set job='MANAGER' where ename='WARD';
==> view with check option where-clause violation

# inline view
from 절에서 사용된 서브쿼리를 인라인뷰라고 한다
--EMP에서 장기근속자 3명만 뽑아서 해외여행을 보내고자 한다
--3명을 선출하세요
create or replace view EMP_OLD_VIEW
as select * from emp order by hiredate ASC;


select * from emp_old_view;

select rownum, empno,ename,hiredate from emp_old_view where rownum<4;
select * from(
select rownum rn, A.* from
(select * from emp order by hiredate asc) A
)where rn >2 and rn <=4;

#index
- 자동 생성: 
	  PK나 UNIQUE 제약 조건을 정의하면 UNIQUE 인덱스가
	  자동적으로 생성된다.
	- 사용자가 생성: 
	  COLUMN에 UNIQUE인덱스 또는 NON-UNIQUE 인덱스를
	  생성한다.
	* unique index : 지정된 열의 값이 고유함을 보장
	* non-unique index: 지정된 열의 값에 중복을 허용
    
CREATE INDEX 인덱스명 ON 테이블명(컬럼명[,컬럼명]...)
	**주의: 인덱스는 NOT NULL인 컬럼에만 
	  사용할 수 있다.
	  NULL인 경우에는 인덱스를 정렬할 수 없기 
	  때문에 사용 불가.
      
emp에서 사원명에 인덱스를 생성하세요
emp_ename_indx

create index emp_ename_indx on emp(ename);
select * from emp where ename='SCOTT';

인덱스를 지정하면 내부적으로 해당 컬럼을 일겅서 오름차순 정렬을 한다.
rowid와 ename을 저장하기 위한 저장공간을 할당한 후 값을 저장한다.

select * from user_objects where object_type='INDEX';

select * from user_objects where object_type='VIEW';

상품 테이블에서 인덱스를 걸어두면 좋을 컬럼을 찾아 인덱스를 만드세요.
create index products_category_fk_indx on products (CATEGORY_FK);
create index products_ep_code_fk_indx on products (EP_CODE_FK);
--select * from
--(select * from PRODUCTS P join
--(select * from CATEGORY C join SUPPLY_COMP S) A);

#index 삭제
EMP_ENAME_INDX 인덱스를 삭제하세요


#index 수정
index삭제후 재생성밖에없다!

create [public] synonym 시노님명 for 객체
public은 dba만 줄수있다.
동의어 생성 권한도 부여 받아야 할 수 있다.
system계정으로 접속해서
grant create synonym to 권한부여할계정명;

데이터사전에서 조회
select * from user_objects
where object_type='synonym';

동의어 삭제
drop synonym 동의어명;

drop synonym note;

select * from note;

select * from mystar.mystarstablenote;

select * from emp;
rollback;