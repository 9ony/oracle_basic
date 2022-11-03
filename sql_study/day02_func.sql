1.단일행 함수
2. 그룹함수
3. 기타 함수

# 단일행 함수
[1] 문자형 함수
[2] 숫자형 함수
[3] 날짜형 함수
[4] 변환 함수

# [1] 문자형 함수
select lower('HAPPY BIRTHDAY'), upper('Happy Birthday') from DUAL;

--select * from dual;
--dual은 1행 1열을 갖는 더미 테이블
select 9*7 from dual;

# init


# concat(변수1,변수2) : 2개 이상의 문자를 결합해준다.
select concat('abc','1234') from dual;

--    [문제] 사원 테이블에서 SCOTT의 사번,이름,담당업무(소문자로),부서번호를
--		출력하세요.
select empno, ename, lower(job) as job, deptno
from emp where ename = upper('scott');
--	 상품 테이블에서 판매가를 화면에 보여줄 때 금액의 단위를 함께 
--	 붙여서 출력하세요.
select products_name, concat(output_price,'원') price from products;
--	 고객테이블에서 고객 이름과 나이를 하나의 컬럼으로 만들어 결과값을 화면에
--	       보여주세요.
select concat(name,age) from member;

--# substr(변수,i,len) : 문자 i 인덱스로 시작한 len 문자 길이만큼의 변수를 반환함
--i가 양수일경우: 앞에서부터
--음수일경우 : 뒤에서부터
select substr('ABCDEFG',3,4), SUBSTR('ABCDEFG',3,2) FROM DUAL;
select substr('991203-1012369',1,6), substr('991203-1012369',-7,7) from dual;

--length(변수) : 문자열 길이 반환
select length('991203-1012369') from dual;

--[문제]
--	사원 테이블에서 첫글자가 'K'보다 크고 'Y'보다 작은 사원의
--	  사번,이름,업무,급여를 출력하세요. 단 이름순으로 정렬하세요.
select empno,ename,job,sal
from emp
where substr(ename,1,1) between 'K' and 'Y';
where substr(ename,1,1)>'K' and substr(ename,1,1)<'Y';
--	사원테이블에서 부서가 20번인 사원의 사번,이름,이름자릿수,
--	급여,급여의 자릿수를 출력하세요.
select empno, ename, length(ename), sal, length(sal)
from emp
where deptno=20;
	
--	사원테이블의 사원이름 중 6자리 이상을 차지하는 사원의이름과 
--	이름자릿수를 보여주세요.
select ename, length(ename) from emp
where length(ename) >= 6;

--#LPAD/RPAD
--LPAD(컬럼,변수1, 변수2): 문자값을 왼쪽부터 채운다.
--RAPD(컬럼,변수1, 변수2): 문자값을 오른쪽부터 채운다.
select ename, LPAD(ename,15,' '), sal,LPAD(sal,10,'*') FROM EMP
where deptno=10;

select dname, rpad(dname,15,'#') from dept;

--#LTRIM/RTRIM
--LTRIM(변수1, 변수2): 변수1의 값중 변수2와 같은 단어가 있으면
--                    그문자를 삭제한 나머지값을 반환함
select ltrim('TTTHELLO TEST','T'), rtrim('TTTHELLO TEST','T') from dual;

--#REPLACE(컬럼,변수1,변수2): 컬럼값중 변수1에 해당하는 문자를 변수2로 대체한다.

SELECT REPLACE('ORACLE TEST','TEST','HI') FROM DUAL;

--사원테이블에서 담당업무 중 좌측에 'A'를 삭제하고
--급여중 좌측의 1을 삭제하여 출력하세요.
SELECT JOB, LTRIM(JOB,'A'), SAL ,LTRIM(SAL,1)
FROM EMP;
--사원테이블에서 10번 부서의 사원에 대해 담당업무 중 우측에'T'를
--	삭제하고 급여중 우측의 0을 삭제하여 출력하세요.
SELECT JOB,RTRIM(JOB,'T'),SAL,RTRIM(SAL,0) FROM EMP;
--사원테이블 JOB에서 'A'를 '$'로 바꾸어 출력하세요.
SELECT JOB,REPLACE(JOB,'A','$') FROM EMP;

--고객 테이블의 직업에 해당하는 컬럼에서 직업 정보가 학생인 정보를 모두
--	 대학생으로 변경해 출력되게 하세요.
SELECT JOB, REPLACE(JOB,'학생','대학생') FROM MEMBER;

-- 고객 테이블 주소에서 서울시를 서울특별시로 수정하세요.
-- 서울특별시로 수정하세요.
SELECT NAME,ADDR FROM MEMBER;
UPDATE MEMBER SET ADDR= REPLACE(ADDR,'서울시','서울특별시');
ROLLBACK;

# [2] 숫자형 함수
# ROUND(값), ROUND(값,자리수): 반올림 함수
자리수가 양수면 소수자리를,
자리수가 음수면 정수자리를 반올림한다.
SELECT ROUND(4567.567),ROUND(4567.567,0),ROUND(4567.567,2),ROUND(4567.567,-1) FROM DUAL;

#TRUC() : 절삭함
SELECT TRUNC(4567.567),TRUNC(4567.567,0),TRUNC(4567.567,2),TRUNC(4567.567,-2) FROM DUAL;

#MOD(값1,값2): 나머지값을 반환

--고객 테이블에서 회원이름, 마일리지,나이, 마일리지를 나이로 나눈값을 반올림하여 출력하세요
SELECT NAME , MILEAGE, AGE ,ROUND(MILEAGE/AGE,0)FROM MEMBER;
--상품 테이블의 상품 정보가운데 백원 단위까지 버린 배송비를 비교하여 출력하세요.
SELECT PRODUCTS_NAME, TRANS_COST, TRUNC(TRANS_COST,-3) FROM PRODUCTS;
--사원테이블에서 부서번호가 10인 사원의 급여를 	30으로 나눈 나머지를 출력하세요.
SELECT DEPTNO,ENAME,SAL,MOD(SAL,30) FROM EMP
WHERE DEPTNO=10;

# CHR(숫자),ASCII('문자')
SELECT CHR(65), ASCII('A') FROM DUAL;

# ABS(값): 절대값을 구하는 함수
SELECT NAME, AGE ,AGE-40, ABS(AGE-40) FROM MEMBER;

#CEIL(값): 올림값
#FLOOR(값): 내림값

SELECT CEIL(123.001), FLOOR(123.001) FROM DUAL;

#POWER() : 거듭제곱
#SQRT() : 루트
#SIGN() : 양수,음수,0인지 구분
SELECT POWER(2,7), SQRT(64), SQRT(133) FROM DUAL;
SELECT AGE-40, SIGN(AGE-40) FROM MEMBER;

[3] 날짜형 함수
SELECT SYSDATE, SYSTIMESTAMP FROM DUAL;

SELECT SYSDATE+3 "3일뒤", SYSDATE-2 "이틀전" FROM DUAL;

--내가푼거
SELECT SYSTIMESTAMP, REPLACE(SYSTIMESTAMP,substr(SYSTIMESTAMP,10,2),substr(SYSTIMESTAMP,10,2)+2) FROM DUAL;
--강사님꺼
SELECT SYSTIMESTAMP, TO_CHAR(SYSTIMESTAMP + 2/24,'YY/MM/DD HH24:MI:SS') "두 시간 뒤" FROM DUAL;
--사원테이블에서 현재까지의 근무 일수가 몇 주 몇일인가를 출력하세요
--    단 근무일수가 많은 사람순으로 출력하세요.

select concat(round((sysdate-hiredate)/7),'주'),concat(floor(mod(sysdate-hiredate,7)),'일') from emp;
SELECT HIREDATE,SYSDATE, TRUNC(SYSDATE-HIREDATE),TRUNC((SYSDATE-HIREDATE)/7) WEEKS, TRUNC(MOD((SYSDATE-HIREDATE),7)) DAYS FROM EMP;

# MONTHS_NETWEEN(DATE1,DATE2) 날짜1과 날짜2 사이의 월수를 계산함

SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('22-07-26','YY-MM-DD')) FROM DUAL;

# ADD_MONTHS(DATE,N) : 날짜에 N개월을 더함
SELECT ADD_MONTHS(SYSDATE,2),ADD_MONTHS(SYSDATE,-2) FROM DUAL;

# LAST_DAY(D) : 월의 마지막 날짜를 반환함 (평년/윤년 자동 계산함)
SELECT LAST_DAY('22-02-01'), LAST_DAY('20-02-01'), LAST_DAY(SYSDATE) FROM DUAL;

--고객 테이블이 두 달의 기간을 가진 유료 회원이라는 가정하에 등록일을 기준으로
--유료 회원인 고객의 정보를 보여주세요.

SELECT NAME,REG_DATE,ADD_MONTHS(REG_DATE,2) AS "서비스 만기일" FROM MEMBER;

SELECT SYSDATE FROM DUAL;

SELECT TO_CHAR(SYSDATE,'YY-MM-DD HH:MI:SS') FROM DUAL;

[4] 변환함수
TO_CHAR()
TO_DATE()
TO_NUMBER()

# TO_CHAR(날짜) : 날짜유형을 문자열로 변환한다
  TO_CHAR(숫자) : 숫자유형을 문자열로 변환한다
  
  
  TO_CHAR(D,출력형식)
  SELECT TO_CHAR(SYSDATE), TO_CHAR(SYSDATE, 'YY-MM-DD HH12:MI:SS') FROM DUAL;
  
--    고객테이블의 등록일자를 0000-00-00 의 형태로 출력하세요.
SELECT REG_DATE,TO_CHAR(REG_DATE,'YYYY-MM-DD') FROM MEMBER;
	 
--    고객테이블에 있는 고객 정보 중 등록연도가 2013년인 
--    고객의 정보를 보여주세요.
SELECT * FROM MEMBER
WHERE TO_CHAR(REG_DATE,'YYYY')='2013';
--    고객테이블에 있는 고객 정보 중 등록일자가 2013년 5월1일보다 
--    늦은 정보를 출력하세요. 
--    단, 고객등록 정보는 년, 월만 보이도록 합니다.
SELECT NUM,USERID,AGE,MILEAGE,ADDR,NAME,TO_CHAR(REG_DATE,'YY-MM') AS REG_DATE FROM MEMBER
WHERE TO_CHAR(REG_DATE,'YY-MM-DD')<'13-05-01';

TO_CHAR(N,출력형식) : 숫자형을 문자열로 변환

SELECT TO_CHAR(100000,'999,999'), TO_CHAR(100000,'$999G999') FROM DUAL;

--  상품 테이블에서 상품의 공급 금액을 가격 표시 방법으로 표시하세요.
--	  천자리 마다 , 를 표시합니다.
SELECT PRODUCTS_NAME,INPUT_PRICE,TO_CHAR(INPUT_PRICE,'999,999,999') "공급가격" FROM PRODUCTS;
--  상품 테이블에서 상품의 판매가를 출력하되 주화를 표시할 때 사용하는 방법을
--	  사용하여 출력하세요.[예: \10,000]
SELECT PRODUCTS_NAME,OUTPUT_PRICE,TO_CHAR(OUTPUT_PRICE,'L999,999,999') FROM PRODUCTS;

# TO_DATE(STR, 출력형식): 문자열을 날짜 유형으로 변환한다
SELECT TO_DATE('20221128','YYYYMMDD') +2 FROM DUAL;

SELECT * FROM MEMBER
WHERE REG_DATE > TO_DATE('20130601','YYYYMMDD');

# TO_NUMBER(STR,출력형식): 문자열을 숫자형식으로 변환한다
SELECT TO_NUMBER('10,000','99,999')*2 FROM DUAL;

--'$8,590' ===> 숫자로 변환해보세요
select to_number('$8,590','$999g999')from dual;

select to_char(-23,'999$'),to_char(-23,'99D99') from dual;

select to_char(-23,'99.9'),to_char(-23,'99.99EEEE') from dual;

#그룹함수
- 여러개의 행 또는 테이블 전체에 적용하여 하나의 결과를 반환하는 함수
--count 열의 개수
select count(empno) from emp;

select count(comm) from emp;
-- null 값을 무시하고 셈

--관리자수 세보기 (distinct 중복값 제거후 셈)
select count(distinct mgr) from emp;
select * from emp;

--null값을 포함하여 카운팅 (*)<<
select count(*) from emp;

create table test(a number, b number, c number);
desc test;
insert into test values(null,null,null);
--commit;
select * from test;
select count(a) from test;
select count(*) from test;

--count는 primary키로 세는거 추천! 제약조건때문에 null값이없음

avg()
max()
min()
sum()

--emp테이블에서 모든 SALESMAN에 대하여 급여의 평균,
--	 최고액,최저액,합계를 구하여 출력하세요.
select avg(sal) "평균",max(sal) "최대값",min(sal) "최소값",sum(sal) "합계"
from emp
where job='SALESMAN';
select * from emp where job='SALESMAN';

--EMP테이블에 등록되어 있는 인원수, 보너스에 NULL이 아닌 인원수,
--   보너스의 평균,등록되어 있는 부서의 수를 구하여 출력하세요.
select count(empno), count(comm) , avg(comm) ,count(distinct deptno) from emp;

#group by절
group by절을 이용할때는 group by 절에서 사용한 컬럼과 그룹함수만 select 할수 있다.

--17] 고객 테이블에서 직업의 종류, 각 직업에 속한 최대 마일리지 정보를 보여주세요.
select job, max(mileage) from member group by job;

--	18] 상품 테이블에서 각 상품카테고리별로 총 몇 개의 상품이 있는지 보여주세요.

select category_fk, count(pnum) from products group by category_fk 
		order by category_fk asc;
--		또한 최대 판매가와 최소 판매가를 함께 보여주세요.

select category_fk, count(*), max(output_price),min(output_price) 
		from products group by category_fk order by category_fk asc;

--	19] 상품 테이블에서 각 공급업체 코드별로 공급한 상품의 평균입고가를 보여주세요.
select ep_code_fk, avg(input_price) from products group by ep_code_fk;
--문제1] 사원 테이블에서 입사한 년도별로 사원 수를 보여주세요.

select to_char(hiredate,'YY'),count(empno) 
from emp group by to_char(hiredate,'YY') order by 1;

--	문제2] 사원 테이블에서 해당년도 각 월별로 입사한 사원수를 보여주세요.
select to_char(hiredate,'YY-MM'),count(empno)from emp group by to_char(hiredate,'YY-MM'); 
--	문제3] 사원 테이블에서 업무별 최대 연봉, 최소 연봉을 출력하세요.
select job,max(sal),min(sal) from emp group by job;

#having 절
- group by 의 결과에 조건을 주어 제한할 때 사용한다.
#w>g>h>o 우선순위
20] 고객 테이블에서 직업의 종류와 각 직업에 속한 사람의 수가 
	     2명 이상인 직업군의 정보를 보여주시오.
select job, count(num) from member group by job 
having count(num) >1;

21] 고객 테이블에서 직업의 종류와 각 직업에 속한 최대 마일리지 정보를 보여주세요.
	      단, 직업군의 최대 마일리지가 0인 경우는 제외시킵시다.
select job, max(mileage) from member 
group by job having max(mileage)<>0;

	문제1] 상품 테이블에서 각 카테고리별로 상품을 묶은 경우, 해당 카테고리의 상품이 2개인 
	      상품군의 정보를 보여주세요.
select category_fk from products 
group by category_fk
having count(pnum)=2;
select * from products;
	문제2] 상품 테이블에서 각 공급업체 코드별로 상품 판매가의 평균값 중 단위가 100단위로 떨어
	      지는 항목의 정보를 보여주세요.
select ep_code_fk ,avg(output_price)
from products
group by ep_code_fk having mod(avg(output_price),100)=0;