IN OUT PARAMETER :프로시저가 읽고 쓰는 작업을
동시에 할 수 있는 파라미터
------------------------------------------
CREATE OR REPLACE PROCEDURE INOUT_TEST (
    a1 IN NUMBER,
    a2 IN VARCHAR2,
    a3 IN OUT VARCHAR2,
    a4 OUT VARCHAR2)
	IS
	msg VARCHAR2(30) := '';

	BEGIN

    dbms_output.put_line('--------------------------------');
    dbms_output.put_line('프로시저 시작');
    dbms_output.put_line('--------------------------------');
    
    dbms_output.put_line('--------프로시져 시작전---------'); 
    
    dbms_output.put_line('첫번째 parameter: ' || TO_CHAR(a1, '9,999,999'));
    dbms_output.put_line('두번째 parameter: ' || a2);
    dbms_output.put_line('세번째 parameter: ' || a3);
    dbms_output.put_line('네번째 parameter: ' || a4); 

    a3 := '프로시저 외부에서 이 값을 받을 수 있을까요?';
    msg := '성공';
    a4 := msg;     --여기서 님은 ' 을 하나 붙이셨더군요. 

    dbms_output.put_line('--------프로시져 시작후---------');
	  
    dbms_output.put_line('첫번째 parameter: ' || TO_CHAR(a1, '9,999,999'));
    dbms_output.put_line('두번째 parameter: ' || a2);
    dbms_output.put_line('세번째 parameter: ' || a3);
    dbms_output.put_line('네번째 parameter: ' || a4);


    dbms_output.put_line('--------------------------------');
    dbms_output.put_line('프로시저 끝');
    dbms_output.put_line('--------------------------------');

END;
/

	VARIABLE C VARCHAR2(100) :='나' --[X] 비문법적
	VARIABLE D VARCHAR2(100)

	EXECUTE INOUT_TEST(5000,'안녕',:C,:D);

	PRINT D
    PRINT C
# PL/SQL의 제어문
[1] IF문

	IF 조건 THEN
		실행문
	ELSIF 조건 THEN
		실행문

	ELSE
		실행문
	END IF;

	**주의] ELSIF문이 ELSEIF가 아니라 ELSIF이란 점에 주의하자.**
--사번을 인파라미터로 전달하면 사원의 부서번호에 따라 소속된 부서명을
--문자열로 출력하는 프로시저
--10 회계부서
--20 연구부서
--30 영업부서
--40 운영부서
CREATE OR REPLACE PROCEDURE DEPT_FIND(
pno in emp.empno%type)
is
vdno emp.deptno%type;
vdname emp.ename%type;
vdname varchar2(20);
BEGIN
   select ename,deptno into vdname,vdno
   from emp
   where empno=pno;
IF vdno=10 THEN
	vdname :='회계부서';
ELSIF vdno =20 THEN
	vdname :='연구부서';
ELSIF vdno =30 THEN
	vdname :='영업부서';
ELSIF vdno =40 THEN
	vdname :='운영부서';
ELSE
	vdname :='부서가 없어요';
END IF;
	DBMS_OUTPUT.PUT_LINE(vename||'님은: 'vdno||'번 '||vdname||'부서에 있습니다' );
END;
/
set serveroutput on
execute dept_find(7788);
--
--사원명을 인파라미터로 전달하면
--해당 사원의 연봉을 계산해서 출력하는 프로시저를 작성하되,
--연봉은 COMM이 NULL인 경우와 NULL아 아닌경우를 나눠서 계산하세요
--출력문
--사원명  월급여  보너스 연봉 
--출력하세요
create or replace procedure emp_sal(
pname in emp.ename%type)
is
vsal emp.sal%type;
vcomm emp.comm%type;
total number(8);
begin
    select emp.sal,emp.comm into vsal,vcomm
    from emp where ename=upper(pname);
    if vcomm is null then
        total := vsal*12;
    else
        total := vsal*12+vcomm;
    end if;
    dbms_output.put_line(pname||'------');
    dbms_output.put_line('월급여: '||vsal);
    dbms_output.put_line('보너스: '||vcomm);
    dbms_output.put_line('연 봉: '||total);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    dbms_output.put_line(PNAME||'님은 없습니다');
    WHEN TOO_MANY_ROWS THEN
    dbms_output.put_line(PNAME||'님의 데이터가 2건 이상입니다.');
END;
/
execute emp_sal('TOM');
select * from emp;

--# for loop문
--FOR index IN [reverse] 시작값..end값 LOOP
--	문장1
--	문장2
--	....
--	END LOOP;
--
--	-index는 자동선언되는 binary_integer 형 변수이고. 1씩 증가한다
--	-  reverse 옵션이 사용될 경우 index 는 
--	    upper_bound에서 
--	    lower_bound로 1씩 감소한다.
--	-  IN 다음에는 coursor나 select 문이 올수 있다.
declare
vsum number(4) :=0;
begin
for i in reverse 1 .. 10 loop
    dbms_output.put_line(i);
    vsum:=vsum+i;
end loop;
dbms_output.put_line('까지의 합:'||vsum);
end;
/

--JOB을 인파라미터로 전달하면 해당 업무를 수행하는 사원들의 정보
--사번, 사원명, 부서번호, 부서명, 업무를 출력하세요
--FOR LOOP를 이용해서 풀되 서브쿼리를 이용하세요
create or replace procedure emp_job(
pjob in emp.job%type)
is 
begin
    for e in (select empno,ename,deptno,job,
                (select dname from dept where deptno = emp.deptno) dname
                from emp
                where job=upper(pjob)) loop
        dbms_output.put_line(e.empno||lpad(e.ename,10,' ')||
        lpad(e.deptno,8,' ')||lpad(e.job,12,' ')||lpad(e.dname,16,' '));
    end loop;
end;
/

exec emp_job('analyst');

--1~100까지 짝수만출력
declare
begin
for i in reverse 1 .. 100 loop
    continue --건너뛰기
--    exit --종료
    when
    mod(i,2)=1;
    dbms_output.put_line(i);
end loop;
end;
/

--EMP테이블에 사원정보를 등록하되 LOOP문 이용해서 등록해봅시다.
--'NONAME1'
DECLARE
VCNT NUMBER(3) := 100;
BEGIN
    LOOP
        INSERT INTO EMP(EMPNO, ENAME,HIREDATE)
        VALUES(VCNT+8100,'NONAME'||VCNT, SYSDATE);
    VCNT := VCNT+1;
    EXIT WHEN VCNT >105;    
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(VCNT-100||'건의 데이터 입력 완료');
END;
/

select * from emp;

#while loop문
--while 조건 loop
--    실행문
--    exit when 조건;
--end loop;

declare
vcnt number(3) := 0;
begin
    while vcnt<10 loop
        vcnt := vcnt+2;
        continue when vcnt = 2;
        dbms_output.put_line(vcnt);
    end loop;
end;
/
create or replace procedure grade_avg(
pnum in number)
is
num NUMBER(3) := pnum;
begin
    case TRUNC(num,-1)
    when 90 then dbms_output.put_line('A');
    when 80 then dbms_output.put_line('B');
    when 70 then dbms_output.put_line('C');
    when 60 then dbms_output.put_line('D');
    else dbms_output.put_line('F');
    end case;
end;
/
execute grade_avg(80);

#암시적 커서

create or replace procedure inplicit_cusor
(pno in emp.empno%type)
is
vsal emp.sal%type;
update_row number;
begin
    select sal into vsal
    from emp where empno = pno;
    -- 검새된 데이터가 있다면
    if sql%found then
        dbms_output.put_line(pno||'번 사원의 월급여는 '||vsal||'입니다. 10% 인상예정입니다');
    end if;
    update emp set sal=sal*1.1 where empno=pno;
    update_row:= sql%rowcount;
    dbms_output.put_line(update_row||'명 사원 급여 인상');
    select sal into vsal
    from emp where empno = pno;
    -- 검새된 데이터가 있다면
    if sql%found then
        dbms_output.put_line(pno||'번 사원의 인상된 월급여는 '||vsal||'입니다. 10% 인상예정입니다');
    end if;
end;
/
exec inplicit_cusor(8100);
rollback;

# 명시적 커서 자바JDBC에서 RESULTSET.NEXT()와 비슷한 역할을함
커서 선언
커서 OPEN
반복문 돌면서
커서에서 FETCH한다
커서 CLOSE

CREATE OR REPLACE PROCEDURE EMP_ALL
IS
VNO EMP.EMPNO%TYPE;
VNAME EMP.ENAME%TYPE;
VDATE EMP.HIREDATE%TYPE;
BEGIN
    SELECT EMPNO , ENAME, HIREDATE
    INTO VNO, VNAME, VDATE
    FROM EMP ORDER BY 1 ASC;
END;
/
CREATE OR REPLACE PROCEDURE EMP_ALL
IS
VNO EMP.EMPNO%TYPE;
VNAME EMP.ENAME%TYPE;
VDATE EMP.HIREDATE%TYPE;
--커서 선언
CURSOR EMP_CR IS
    SELECT EMPNO , ENAME, HIREDATE
    FROM EMP ORDER BY 1 ASC;
BEGIN
--커서 오픈
OPEN EMP_CR;
LOOP
    FETCH EMP_CR INTO
    VNO, VNAME, VDATE;
EXIT WHEN EMP_CR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(VNO||LPAD(VNAME,12,' ')||LPAD(VDATE,12,' '));
END LOOP;
--커서 닫기
CLOSE EMP_CR;
END;
/

EXEC EMP_ALL;

--[실습] 부서별 사원수, 평균급여, 최대급여, 최소급여를 가져와 출력하는
--      프로시저를 작성하세요.
SELECT * FROM EMP;
CREATE OR REPLACE PROCEDURE EMP_COUNT_SAL
IS
VDNO EMP.DEPTNO%TYPE;
VCNT NUMBER;
VAVG EMP.SAL%TYPE;
VMIN EMP.SAL%TYPE;
VMAX EMP.SAL%TYPE;
--커서 선언
CURSOR EMP_CR IS
    SELECT DEPTNO , COUNT(EMPNO) CNT, AVG(SAL) AVG_SAL,MAX(SAL) MAX_SAL,MIN(SAL) MIN_SAL
    FROM EMP 
    GROUP BY DEPTNO
    HAVING DEPTNO IS NOT NULL;
BEGIN
--커서 오픈
OPEN EMP_CR;
LOOP
    FETCH EMP_CR INTO
    VDNO,VCNT,VAVG,VMIN,VMAX;
EXIT WHEN EMP_CR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(VDNO||LPAD(VCNT,12,' ')||LPAD(TRUNC(VAVG,0),12,' ')||LPAD(VMIN,12,' ')||LPAD(VMAX,12,' '));
END LOOP;
--커서 닫기
CLOSE EMP_CR;
END;
/

#FOR LOOP를 이용한 커서
CREATE OR REPLACE PROCEDURE EMP_COUNT_SAL
IS
--커서 선언
CURSOR EMP_CR IS
    SELECT DEPTNO , COUNT(EMPNO) CNT, AVG(SAL) AVG_SAL,MAX(SAL) MAX_SAL,MIN(SAL) MIN_SAL
    FROM EMP 
    GROUP BY DEPTNO
    HAVING DEPTNO IS NOT NULL;
BEGIN
    FOR K IN EMP_CR LOOP
    DBMS_OUTPUT.PUT_LINE(K.DEPTNO||LPAD(K.CNT,12,' ')||LPAD(TRUNC(K.AVG_SAL,0),12,' ')||LPAD(K.MIN_SAL,12,' ')||LPAD(K.MAX_SAL,12,' '));
    END LOOP;

END;
/
EXEC EMP_COUNT_SAL;

--부서테이블의 모든 정보를 가져와 출력하는 프로시저를 작성하되
--FOR LOOP+서브쿼리 이용하기
CREATE OR REPLACE PROCEDURE DEPT_ALL
IS
BEGIN
    FOR K IN (SELECT * FROM DEPT ORDER BY 1) LOOP
    DBMS_OUTPUT.PUT_LINE(K.DEPTNO||LPAD(K.DNAME,12,' ')||LPAD(K.LOC,12,' '));
    END LOOP;
END;
/

EXEC DEPT_ALL;
SELECT * FROM DEPT ORDER BY 1;

#미리 정의된 예외처리하기
SELECT * FROM MEMBER;
--MEMBER 테이블의 USERID 컬럼에 UNIQUE 제약조건을 추가하되 제약조건 이름 주어 추가하세요
ALTER TABLE MEMBER ADD CONSTRAINT MEMBER_USERID_UK UNIQUE(USERID);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='MEMBER';

CREATE SEQUENCE MEMBER_SEQ
START WITH 11
INCREMENT BY 1
NOCACHE;

CREATE OR REPLACE PROCEDURE MEMBER_NR(
VNAME IN MEMBER.NAME%TYPE,
VID IN MEMBER.USERID%TYPE,
VPW IN MEMBER.PASSWD%TYPE,
VAGE IN MEMBER.AGE%TYPE,
VJOB IN MEMBER.JOB%TYPE,
VADDR IN MEMBER.ADDR%TYPE)
IS
PNAME = 
BEGIN
    INSERT INTO MEMBER (NUM,NAME,USERID,PASSWD,AGE,JOB,ADDR,REG_DATE)
        VALUES(MEMBER_SEQ.NEXTVAL,VNAME,VID,VPW,VAGE,VJOB,VADDR,SYSDATE);
    IF SQL%ROWCOUNT>0 THEN
        DBMS_OUTPUT.PUT_LINE('회원가입 완료');
    END IF;
    DBMS_OUTPUT.PUT_LINE(VNAME||'님'||VID||'아이디로 등록 되었습니다');
    dbms_output.put_line(10/0);
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    dbms_output.put_line('등록하려는 아이디가 존재합니다');
    WHEN TOO_MANY_ROWS THEN
    dbms_output.put_line(VNAME ||'님 데이터는 2건 이상 있습니다.');
    WHEN OTHERS THEN
    dbms_output.put_line('기타 에러'||SQLERRM||SQLCODE);
END;
/
SELECT * FROM MEMBER;
EXEC MEMBER_NR('김9','ID19','1234',19,'교육생','부산');

--delete from MEMBER where NUM>11;

CREATE OR REPLACE PROCEDURE USER_EXCEPT
(PDNO IN DEPT.DEPTNO%TYPE)

--1.예외 선언
    MY_DEFINE_ERROR EXCEPTION;
    VCNT NUMBER;
BEGIN
    SELECT COUNT(EMPNO) INTO VCNT
    FROM EMP WHERE DEPTNO = PDNO;
    --2. 예외 발생시키기-> RAISE문을 이용
    IF VCNT <5 THEN
        RAISE MY_DEFINE_ERROR;
    END IF;
    
    --3.예외 처리 단계
    EXCEPTION
        WHEN MY_DEFINE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20001,'부서 인원이 5명 미만인 부서는 안돼요');
END;
/
# FUNCTION
- 실행환경에 반드시 하나의 값을 
   RETURN하기 위해 PL/SQL함수를 사용한다.
--사원명을 입력하면 해당 사원이 소속된 부서명을 반환하는 함수를 작성하세요

CREATE OR REPLACE FUNCTION GET_DNAME(
PNAME IN EMP.ENAME%TYPE)
RETURN VARCHAR2
IS
VDNO EMP.DEPTNO%TYPE;
VDNAME DEPT.DNAME%TYPE;
BEGIN
    SELECT DEPTNO INTO VDNO FROM EMP
    WHERE ENAME=PNAME;
    SELECT DNAME INTO VDNAME FROM DEPT
    WHERE DEPTNO = VDNO;
    RETURN VDNAME;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PNAME||'사원은 없습니다');
    RETURN SQLERRM;
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE(PNAME||'사원 데이터가 2건 이상입니다');
    RETURN SQLERRM;
END;
/

VAR GNAME VARCHAR2;
EXEC :GNAME := GET_DNAME('TOM');
PRINT GNAME;

--# 자바jdbc day05.test3.java 프로시저 연동 실습용 프로시저
--#모든 메모목록을 가져오는 프로시저를 작성해서 자바와 연동해봅시다.
create or replace procedure memo_all(
mycr out sys_refcursor)
is
begin
    OPEN mycr for
    select idx,name,msg,wdate from memo
    order by idx desc;
end;
/
--out파라미터로 mycr(sys_refcursor)를 자바에 보낸다

--# 자바jdbc day05.test4.java 프로시저 연동 실습용 프로시저
--#부서번호 인파라미터 -> 부서에있는 사원정보(사원명,업무,입사일)와 부서정보(부서명,근무지)를
--#가져오는 프로시저를 작성해보자 커서로 아웃파라미터보내기
create or replace procedure emp_forjava(
pdno in emp.deptno%type,
mycr out sys_refcursor)
is
begin
    OPEN mycr for
    select ename,job,hiredate,dname,loc from
    (select * from emp where emp.deptno=pdno) A join dept D
    on A.deptno = D.deptno;
end;
/
select * from emp;