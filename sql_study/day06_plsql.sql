--day06_plsql.sql
/*
[1] 프로시저 익명블럭
- 선언부
- 실행부
- 예외처리부
*/
DECLARE
  -- 선언부에서는 변수 선언을 할 수 있다.
  I_MSG VARCHAR2(100);
BEGIN
  -- 실행부에는 SQL 또는 PL/SQL문이 올 수 있다.
  I_MSG := 'HELLO ORACLE';
  DBMS_OUTPUT.PUT_LINE(I_MSG);
END;
/

SET SERVEROUTPUT ON


--[2] 이름을 갖는 프로시저

CREATE OR REPLACE PROCEDURE PRINT_TIME
IS
-- 선언부
    VTIME1 TIMESTAMP;
    VTIME2 TIMESTAMP;     
BEGIN
-- 실행부 날짜 + 숫자 : 일수를 더함
    select systimestamp - 1/24 into vtime1 from dual;
    select systimestamp + 2/24 into vtime2 from dual;
    DBMS_OUTPUT.PUT_LINE('한시간전: '||vtime1);
    DBMS_OUTPUT.PUT_LINE('두시간후: '||vtime2);
END;
/

execute print_time;

--사번을 인 파라미터로 전달하면 해당 사원의
--사번, 이름, 부서명, 담당업무를 가져와
--출력하는 프로시저를 작성해봅시다.

CREATE OR REPLACE PROCEDURE EMP_INFO(PNO IN NUMBER)
IS
VNO NUMBER(4); -- 스칼라타입
VNAME EMP.ENAME%TYPE; -- EMP테이블의 ENAME컬럼과 같은 자료유형으로 하겠다는 의미
VDNAME DEPT.DNAME%TYPE;
VJOB EMP.JOB%TYPE;
VDNO EMP.DEPTNO%TYPE;
BEGIN
-- SELECT INTO로 가져온 데이터 변수에 할당하기
SELECT ENAME, JOB, DEPTNO INTO VNAME, VJOB, VDNO
FROM EMP WHERE EMPNO=PNO;
SELECT DNAME INTO VDNAME FROM DEPT
WHERE DEPTNO=VDNO;
-- DBMS로 출력하기
DBMS_OUTPUT.PUT_LINE('----'||PNO||'번 사원정보----');
DBMS_OUTPUT.PUT_LINE('사 원 명: '||VNAME);
DBMS_OUTPUT.PUT_LINE('담당업무: '||VJOB);
DBMS_OUTPUT.PUT_LINE('부 서 명: '||VDNAME);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PNO||'번 사원은 존재하지 않아요');
END;
/

EXECUTE EMP_INFO(8499);


%ROWTYPE : COMPOSITE 타입 테이블명 %ROWTYPE : 테이블의 행과 같은 타입

--사번을 인 파라미터로 전달하면 해당 사원의
--사번, 이름, 부서명, 담당업무를 가져와
--출력하는 프로시저를 작성해봅시다.

CREATE OR REPLACE PROCEDURE EMP_INFO(PNO IN NUMBER)
IS
VNO NUMBER(4); -- 스칼라타입
VNAME EMP.ENAME%TYPE; -- EMP테이블의 ENAME컬럼과 같은 자료유형으로 하겠다는 의미
VDNAME DEPT.DNAME%TYPE;
VJOB EMP.JOB%TYPE;
VDNO EMP.DEPTNO%TYPE;
BEGIN
-- SELECT INTO로 가져온 데이터 변수에 할당하기
SELECT ENAME, JOB, DEPTNO INTO VNAME, VJOB, VDNO
FROM EMP WHERE EMPNO=PNO;
SELECT DNAME INTO VDNAME FROM DEPT
WHERE DEPTNO=VDNO;
-- DBMS로 출력하기
DBMS_OUTPUT.PUT_LINE('----'||PNO||'번 사원정보----');
DBMS_OUTPUT.PUT_LINE('사 원 명: '||VNAME);
DBMS_OUTPUT.PUT_LINE('담당업무: '||VJOB);
DBMS_OUTPUT.PUT_LINE('부 서 명: '||VDNAME);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PNO||'번 사원은 존재하지 않아요');
END;
/

EXECUTE EMP_INFO(8499);

%TYPE : REFERENCE 타입. 테이블명.컬럼명%TYPE
%ROWTYPE : COMPOSITE 타입  테이블명%ROWTYPE : 테이블의 행과 같은 타입

부서번호를 인파라미터로 주면
해당 부서의 부서명과 근무지를 출력하는 프로시저를 작성합시다

CREATE OR REPLACE PROCEDURE RTYPE(PDNO IN DEPT.DEPTNO%TYPE)
IS
VDEPT DEPT%ROWTYPE;
BEGIN
SELECT DNAME, LOC INTO VDEPT.DNAME, VDEPT.LOC 
FROM DEPT WHERE DEPTNO=PDNO;

DBMS_OUTPUT.PUT_LINE('부서번호: '||PDNO);
DBMS_OUTPUT.PUT_LINE('부 서 명 :'||VDEPT.DNAME);
DBMS_OUTPUT.PUT_LINE('부서위치: '||VDEPT.LOC);
-- 예외처리하기
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PDNO||'번 부서 정보는 없습니다.');
END;
/
EXECUTE RTYPE(50);


--# table type : composite type (복합데이터타입) => 배열과 비슷함
--table 타입에 접근하기 위한 인덱스가 있는데 binary_integer 데이터 형의 인덱스를
--이용할수있다.
--
---구문
--	TYPE table_type_name IS TABLE OF
--	{column_type | variable%TYPE| table.column%TYPE} [NOT NULL]
--	[INDEX BY BINARY_INTEGER];
--	identifier table_type_name;

사원들의 업무 정보를 담을 테이블 타입의 변수를 선언하고
사원들의 업무 정보를 저장하기
반복문 이용해서 이름과 업무 정보 출력하기

create or replace procedure table_type(pdno in emp.deptno%type)
is
--table 선언
    type ename_table is table of emp.ename%type
    index by binary_integer;
--table type 변수 선언
    ename_tab ename_table;
    i binary_integer :=0;
begin
    for k in (select ename from emp where deptno=pdno) loop
    i:= i+1;
    -- 테이블 변수에 가져온 값들을 저장한다
    ename_tab(i) :=k.ename;
    end loop;
    
    --테이븙 타입에 저장된 값을 출력하자.
    for j in 1..i loop
        dbms_output.put_line(ename_tab(j));
    
    end loop;
end;
/

execute table_type(30);

create or replace procedure table_type2(pdno in emp.deptno%type)
is
--table 선언
    type ename_table is table of emp.ename%type
    index by binary_integer;
    type job_table is table of emp.job%type
    index by binary_integer;
--table type 변수 선언
    ename_tab ename_table;
    job_tab job_table;
    i binary_integer :=0;
begin
    for k in (select ename,job from emp where deptno=pdno) loop
    i:= i+1;
    -- 테이블 변수에 가져온 값들을 저장한다
    ename_tab(i) :=k.ename;
    job_tab(i) := k.job;
    end loop;
    
    --테이븙 타입에 저장된 값을 출력하자.
    for j in 1..i loop
        dbms_output.put_line(ename_tab(j)||' , '||job_tab(j));
    end loop;
end;
/

execute table_type2(30);

# RECORD TYPE
삼품번호를 입력하면 해당삼품의 상품명, 판매가, 제조사 출력하는 프로시저를 작성하세요.

accept pnum prompt '조회할 상품번호를 입력하세요'
-- pnum 을 사용할때는 &pnum

declare
    type prod_record_type is record(
    vpname products.products_name%type,
    vprice products.output_price%type,
    vcomp products.company%type
    );
    prod_rec prod_record_type;
    vpnum NUMBER :='&pnum';
begin
    select products_name,output_price,company 
    into prod_rec
    from products
    where pnum=vpnum;
    dbms_output.put_line(vpnum||'번 상품 정보------');
    dbms_output.put_line('상품명: ' ||prod_rec.vpname);
    dbms_output.put_line('제조사: ' ||prod_rec.vcomp);
    dbms_output.put_line('가 격: ' ||prod_rec.vprice);

end;
/


바인드 변수 - non-pl/sql변수
variable myvar number
--프로시저 내부에 바인드 변수를 참조하려면
--바인드변수 앞에 콜론(:)을 참조 접두어로 기술한다.
declare
begin
:myvar :=700;
end;
/
print myvar;

--# 프로시저 파라미터 종류
--[1] in 파라미터
--[2] out 파라미터
--[3] in out 파라미터
--
--memo테이블에 새로운 레코드를 insert하는 프로시저를 작성하세요
--작성자와 메모내용은 in 파라미터로 받습니다.
CREATE OR REPLACE PROCEDURE MEMO_ADD(
PNAME IN VARCHAR2 DEFAULT '아무개',
PMSG IN MEMO.MSG%TYPE)
IS
BEGIN
    INSERT INTO MEMO(IDX,NAME,MSG,WDATE)
    VALUES(MEMO_SEQ.NEXTVAL,PNAME, PMSG, SYSDATE);
    COMMIT;
END;
/

exec memo_add('홍길동','프로시저로 입력받았어요');
exec memo_add(pmsg=>'안녕?');
select * from memo;

OUT PARAMETER : 프로시저가 사용자에게 넘겨주는 값
	프로시저에서 값을 변경할 수 있다.
	디폴트 값을 지정할 수 없다.

create or replace procedure emp_find(
pno in emp.empno%type,
gname out emp.ename%type)
is
begin
    select ename into gname
    from emp
    where empno = pno;
end;
/
실행방법
바인드 변수 선언
프로시저를 실행할때 바인드변수를 아웃파라미터의 매개변수로 전달한다
바인드 변수값을 출력
var gname varchar2(20);
exec emp_find(10000,:gname);

print gname;

--부서번호를 인파라미터로 받고, 급연 인상률도 인파라미터로 받아서
--EMP테이블의 특정 부서 직원들의 급여를 인상해주고
--그런뒤 해당 부서의 평균급여를 아웃파라미터로 전달하는 프로시저를
--작성한 뒤
--해당 부서의 평균급여를 출력하세요

CREATE OR REPLACE PROCEDURE SAL_AVG(
DNO IN EMP.DEPTNO%TYPE,
SALRATE IN NUMBER,
AVGSAL OUT EMP.SAL%TYPE )
IS 
BEGIN
    UPDATE EMP SET SAL=SAL+SAL*SALRATE/100 
    WHERE DEPTNO=DNO;
    SELECT AVG(SAL) INTO AVGSAL FROM EMP WHERE DEPTNO=DNO;
END;
/

VAR TOTAL NUMBER;

EXEC SAL_AVG(10,10,:TOTAL);

PRINT TOTAL;
rollback;
select * from emp where deptno=10;

--MEMO_EDIT 프로시저를 작성하세요
--인파라미터 3개 받아서(글번호, 작성자, 메시지)
--UPDATE문을 수행하는 프로시저

create or replace procedure memo_edit(
pno in memo.idx%type,
pname in memo.name%type,
pmsg in memo.msg%type
)
is
begin
update memo set name=pname,msg=pmsg where pno=idx;
end;
/

exec memo_edit(10,'아무개','edit_memo로 업데이트');

select * from memo;
update memo set name='김데드',msg='데드락될까' where idx=11;
rollback;
commit;