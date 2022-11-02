IN OUT PARAMETER :���ν����� �а� ���� �۾���
���ÿ� �� �� �ִ� �Ķ����
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
    dbms_output.put_line('���ν��� ����');
    dbms_output.put_line('--------------------------------');
    
    dbms_output.put_line('--------���ν��� ������---------'); 
    
    dbms_output.put_line('ù��° parameter: ' || TO_CHAR(a1, '9,999,999'));
    dbms_output.put_line('�ι�° parameter: ' || a2);
    dbms_output.put_line('����° parameter: ' || a3);
    dbms_output.put_line('�׹�° parameter: ' || a4); 

    a3 := '���ν��� �ܺο��� �� ���� ���� �� �������?';
    msg := '����';
    a4 := msg;     --���⼭ ���� ' �� �ϳ� ���̴̼�����. 

    dbms_output.put_line('--------���ν��� ������---------');
	  
    dbms_output.put_line('ù��° parameter: ' || TO_CHAR(a1, '9,999,999'));
    dbms_output.put_line('�ι�° parameter: ' || a2);
    dbms_output.put_line('����° parameter: ' || a3);
    dbms_output.put_line('�׹�° parameter: ' || a4);


    dbms_output.put_line('--------------------------------');
    dbms_output.put_line('���ν��� ��');
    dbms_output.put_line('--------------------------------');

END;
/

	VARIABLE C VARCHAR2(100) :='��' --[X] �񹮹���
	VARIABLE D VARCHAR2(100)

	EXECUTE INOUT_TEST(5000,'�ȳ�',:C,:D);

	PRINT D
    PRINT C
# PL/SQL�� ���
[1] IF��

	IF ���� THEN
		���๮
	ELSIF ���� THEN
		���๮

	ELSE
		���๮
	END IF;

	**����] ELSIF���� ELSEIF�� �ƴ϶� ELSIF�̶� ���� ��������.**
--����� ���Ķ���ͷ� �����ϸ� ����� �μ���ȣ�� ���� �Ҽӵ� �μ�����
--���ڿ��� ����ϴ� ���ν���
--10 ȸ��μ�
--20 �����μ�
--30 �����μ�
--40 ��μ�
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
	vdname :='ȸ��μ�';
ELSIF vdno =20 THEN
	vdname :='�����μ�';
ELSIF vdno =30 THEN
	vdname :='�����μ�';
ELSIF vdno =40 THEN
	vdname :='��μ�';
ELSE
	vdname :='�μ��� �����';
END IF;
	DBMS_OUTPUT.PUT_LINE(vename||'����: 'vdno||'�� '||vdname||'�μ��� �ֽ��ϴ�' );
END;
/
set serveroutput on
execute dept_find(7788);
--
--������� ���Ķ���ͷ� �����ϸ�
--�ش� ����� ������ ����ؼ� ����ϴ� ���ν����� �ۼ��ϵ�,
--������ COMM�� NULL�� ���� NULL�� �ƴѰ�츦 ������ ����ϼ���
--��¹�
--�����  ���޿�  ���ʽ� ���� 
--����ϼ���
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
    dbms_output.put_line('���޿�: '||vsal);
    dbms_output.put_line('���ʽ�: '||vcomm);
    dbms_output.put_line('�� ��: '||total);
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
    dbms_output.put_line(PNAME||'���� �����ϴ�');
    WHEN TOO_MANY_ROWS THEN
    dbms_output.put_line(PNAME||'���� �����Ͱ� 2�� �̻��Դϴ�.');
END;
/
execute emp_sal('TOM');
select * from emp;

--# for loop��
--FOR index IN [reverse] ���۰�..end�� LOOP
--	����1
--	����2
--	....
--	END LOOP;
--
--	-index�� �ڵ�����Ǵ� binary_integer �� �����̰�. 1�� �����Ѵ�
--	-  reverse �ɼ��� ���� ��� index �� 
--	    upper_bound���� 
--	    lower_bound�� 1�� �����Ѵ�.
--	-  IN �������� coursor�� select ���� �ü� �ִ�.
declare
vsum number(4) :=0;
begin
for i in reverse 1 .. 10 loop
    dbms_output.put_line(i);
    vsum:=vsum+i;
end loop;
dbms_output.put_line('������ ��:'||vsum);
end;
/

--JOB�� ���Ķ���ͷ� �����ϸ� �ش� ������ �����ϴ� ������� ����
--���, �����, �μ���ȣ, �μ���, ������ ����ϼ���
--FOR LOOP�� �̿��ؼ� Ǯ�� ���������� �̿��ϼ���
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

--1~100���� ¦�������
declare
begin
for i in reverse 1 .. 100 loop
    continue --�ǳʶٱ�
--    exit --����
    when
    mod(i,2)=1;
    dbms_output.put_line(i);
end loop;
end;
/

--EMP���̺� ��������� ����ϵ� LOOP�� �̿��ؼ� ����غ��ô�.
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
    DBMS_OUTPUT.PUT_LINE(VCNT-100||'���� ������ �Է� �Ϸ�');
END;
/

select * from emp;

#while loop��
--while ���� loop
--    ���๮
--    exit when ����;
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

#�Ͻ��� Ŀ��

create or replace procedure inplicit_cusor
(pno in emp.empno%type)
is
vsal emp.sal%type;
update_row number;
begin
    select sal into vsal
    from emp where empno = pno;
    -- �˻��� �����Ͱ� �ִٸ�
    if sql%found then
        dbms_output.put_line(pno||'�� ����� ���޿��� '||vsal||'�Դϴ�. 10% �λ����Դϴ�');
    end if;
    update emp set sal=sal*1.1 where empno=pno;
    update_row:= sql%rowcount;
    dbms_output.put_line(update_row||'�� ��� �޿� �λ�');
    select sal into vsal
    from emp where empno = pno;
    -- �˻��� �����Ͱ� �ִٸ�
    if sql%found then
        dbms_output.put_line(pno||'�� ����� �λ�� ���޿��� '||vsal||'�Դϴ�. 10% �λ����Դϴ�');
    end if;
end;
/
exec inplicit_cusor(8100);
rollback;

# ����� Ŀ�� �ڹ�JDBC���� RESULTSET.NEXT()�� ����� ��������
Ŀ�� ����
Ŀ�� OPEN
�ݺ��� ���鼭
Ŀ������ FETCH�Ѵ�
Ŀ�� CLOSE

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
--Ŀ�� ����
CURSOR EMP_CR IS
    SELECT EMPNO , ENAME, HIREDATE
    FROM EMP ORDER BY 1 ASC;
BEGIN
--Ŀ�� ����
OPEN EMP_CR;
LOOP
    FETCH EMP_CR INTO
    VNO, VNAME, VDATE;
EXIT WHEN EMP_CR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(VNO||LPAD(VNAME,12,' ')||LPAD(VDATE,12,' '));
END LOOP;
--Ŀ�� �ݱ�
CLOSE EMP_CR;
END;
/

EXEC EMP_ALL;

--[�ǽ�] �μ��� �����, ��ձ޿�, �ִ�޿�, �ּұ޿��� ������ ����ϴ�
--      ���ν����� �ۼ��ϼ���.
SELECT * FROM EMP;
CREATE OR REPLACE PROCEDURE EMP_COUNT_SAL
IS
VDNO EMP.DEPTNO%TYPE;
VCNT NUMBER;
VAVG EMP.SAL%TYPE;
VMIN EMP.SAL%TYPE;
VMAX EMP.SAL%TYPE;
--Ŀ�� ����
CURSOR EMP_CR IS
    SELECT DEPTNO , COUNT(EMPNO) CNT, AVG(SAL) AVG_SAL,MAX(SAL) MAX_SAL,MIN(SAL) MIN_SAL
    FROM EMP 
    GROUP BY DEPTNO
    HAVING DEPTNO IS NOT NULL;
BEGIN
--Ŀ�� ����
OPEN EMP_CR;
LOOP
    FETCH EMP_CR INTO
    VDNO,VCNT,VAVG,VMIN,VMAX;
EXIT WHEN EMP_CR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(VDNO||LPAD(VCNT,12,' ')||LPAD(TRUNC(VAVG,0),12,' ')||LPAD(VMIN,12,' ')||LPAD(VMAX,12,' '));
END LOOP;
--Ŀ�� �ݱ�
CLOSE EMP_CR;
END;
/

#FOR LOOP�� �̿��� Ŀ��
CREATE OR REPLACE PROCEDURE EMP_COUNT_SAL
IS
--Ŀ�� ����
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

--�μ����̺��� ��� ������ ������ ����ϴ� ���ν����� �ۼ��ϵ�
--FOR LOOP+�������� �̿��ϱ�
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

#�̸� ���ǵ� ����ó���ϱ�
SELECT * FROM MEMBER;
--MEMBER ���̺��� USERID �÷��� UNIQUE ���������� �߰��ϵ� �������� �̸� �־� �߰��ϼ���
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
        DBMS_OUTPUT.PUT_LINE('ȸ������ �Ϸ�');
    END IF;
    DBMS_OUTPUT.PUT_LINE(VNAME||'��'||VID||'���̵�� ��� �Ǿ����ϴ�');
    dbms_output.put_line(10/0);
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
    dbms_output.put_line('����Ϸ��� ���̵� �����մϴ�');
    WHEN TOO_MANY_ROWS THEN
    dbms_output.put_line(VNAME ||'�� �����ʹ� 2�� �̻� �ֽ��ϴ�.');
    WHEN OTHERS THEN
    dbms_output.put_line('��Ÿ ����'||SQLERRM||SQLCODE);
END;
/
SELECT * FROM MEMBER;
EXEC MEMBER_NR('��9','ID19','1234',19,'������','�λ�');

--delete from MEMBER where NUM>11;

CREATE OR REPLACE PROCEDURE USER_EXCEPT
(PDNO IN DEPT.DEPTNO%TYPE)

--1.���� ����
    MY_DEFINE_ERROR EXCEPTION;
    VCNT NUMBER;
BEGIN
    SELECT COUNT(EMPNO) INTO VCNT
    FROM EMP WHERE DEPTNO = PDNO;
    --2. ���� �߻���Ű��-> RAISE���� �̿�
    IF VCNT <5 THEN
        RAISE MY_DEFINE_ERROR;
    END IF;
    
    --3.���� ó�� �ܰ�
    EXCEPTION
        WHEN MY_DEFINE_ERROR THEN
            RAISE_APPLICATION_ERROR(-20001,'�μ� �ο��� 5�� �̸��� �μ��� �ȵſ�');
END;
/
# FUNCTION
- ����ȯ�濡 �ݵ�� �ϳ��� ���� 
   RETURN�ϱ� ���� PL/SQL�Լ��� ����Ѵ�.
--������� �Է��ϸ� �ش� ����� �Ҽӵ� �μ����� ��ȯ�ϴ� �Լ��� �ۼ��ϼ���

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
    DBMS_OUTPUT.PUT_LINE(PNAME||'����� �����ϴ�');
    RETURN SQLERRM;
    WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE(PNAME||'��� �����Ͱ� 2�� �̻��Դϴ�');
    RETURN SQLERRM;
END;
/

VAR GNAME VARCHAR2;
EXEC :GNAME := GET_DNAME('TOM');
PRINT GNAME;

--# �ڹ�jdbc day05.test3.java ���ν��� ���� �ǽ��� ���ν���
--#��� �޸����� �������� ���ν����� �ۼ��ؼ� �ڹٿ� �����غ��ô�.
create or replace procedure memo_all(
mycr out sys_refcursor)
is
begin
    OPEN mycr for
    select idx,name,msg,wdate from memo
    order by idx desc;
end;
/
--out�Ķ���ͷ� mycr(sys_refcursor)�� �ڹٿ� ������

--# �ڹ�jdbc day05.test4.java ���ν��� ���� �ǽ��� ���ν���
--#�μ���ȣ ���Ķ���� -> �μ����ִ� �������(�����,����,�Ի���)�� �μ�����(�μ���,�ٹ���)��
--#�������� ���ν����� �ۼ��غ��� Ŀ���� �ƿ��Ķ���ͺ�����
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