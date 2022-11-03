--day06_plsql.sql
/*
[1] ���ν��� �͸��
- �����
- �����
- ����ó����
*/
DECLARE
  -- ����ο����� ���� ������ �� �� �ִ�.
  I_MSG VARCHAR2(100);
BEGIN
  -- ����ο��� SQL �Ǵ� PL/SQL���� �� �� �ִ�.
  I_MSG := 'HELLO ORACLE';
  DBMS_OUTPUT.PUT_LINE(I_MSG);
END;
/

SET SERVEROUTPUT ON


--[2] �̸��� ���� ���ν���

CREATE OR REPLACE PROCEDURE PRINT_TIME
IS
-- �����
    VTIME1 TIMESTAMP;
    VTIME2 TIMESTAMP;     
BEGIN
-- ����� ��¥ + ���� : �ϼ��� ����
    select systimestamp - 1/24 into vtime1 from dual;
    select systimestamp + 2/24 into vtime2 from dual;
    DBMS_OUTPUT.PUT_LINE('�ѽð���: '||vtime1);
    DBMS_OUTPUT.PUT_LINE('�νð���: '||vtime2);
END;
/

execute print_time;

--����� �� �Ķ���ͷ� �����ϸ� �ش� �����
--���, �̸�, �μ���, �������� ������
--����ϴ� ���ν����� �ۼ��غ��ô�.

CREATE OR REPLACE PROCEDURE EMP_INFO(PNO IN NUMBER)
IS
VNO NUMBER(4); -- ��Į��Ÿ��
VNAME EMP.ENAME%TYPE; -- EMP���̺��� ENAME�÷��� ���� �ڷ��������� �ϰڴٴ� �ǹ�
VDNAME DEPT.DNAME%TYPE;
VJOB EMP.JOB%TYPE;
VDNO EMP.DEPTNO%TYPE;
BEGIN
-- SELECT INTO�� ������ ������ ������ �Ҵ��ϱ�
SELECT ENAME, JOB, DEPTNO INTO VNAME, VJOB, VDNO
FROM EMP WHERE EMPNO=PNO;
SELECT DNAME INTO VDNAME FROM DEPT
WHERE DEPTNO=VDNO;
-- DBMS�� ����ϱ�
DBMS_OUTPUT.PUT_LINE('----'||PNO||'�� �������----');
DBMS_OUTPUT.PUT_LINE('�� �� ��: '||VNAME);
DBMS_OUTPUT.PUT_LINE('������: '||VJOB);
DBMS_OUTPUT.PUT_LINE('�� �� ��: '||VDNAME);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PNO||'�� ����� �������� �ʾƿ�');
END;
/

EXECUTE EMP_INFO(8499);


%ROWTYPE : COMPOSITE Ÿ�� ���̺�� %ROWTYPE : ���̺��� ��� ���� Ÿ��

--����� �� �Ķ���ͷ� �����ϸ� �ش� �����
--���, �̸�, �μ���, �������� ������
--����ϴ� ���ν����� �ۼ��غ��ô�.

CREATE OR REPLACE PROCEDURE EMP_INFO(PNO IN NUMBER)
IS
VNO NUMBER(4); -- ��Į��Ÿ��
VNAME EMP.ENAME%TYPE; -- EMP���̺��� ENAME�÷��� ���� �ڷ��������� �ϰڴٴ� �ǹ�
VDNAME DEPT.DNAME%TYPE;
VJOB EMP.JOB%TYPE;
VDNO EMP.DEPTNO%TYPE;
BEGIN
-- SELECT INTO�� ������ ������ ������ �Ҵ��ϱ�
SELECT ENAME, JOB, DEPTNO INTO VNAME, VJOB, VDNO
FROM EMP WHERE EMPNO=PNO;
SELECT DNAME INTO VDNAME FROM DEPT
WHERE DEPTNO=VDNO;
-- DBMS�� ����ϱ�
DBMS_OUTPUT.PUT_LINE('----'||PNO||'�� �������----');
DBMS_OUTPUT.PUT_LINE('�� �� ��: '||VNAME);
DBMS_OUTPUT.PUT_LINE('������: '||VJOB);
DBMS_OUTPUT.PUT_LINE('�� �� ��: '||VDNAME);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PNO||'�� ����� �������� �ʾƿ�');
END;
/

EXECUTE EMP_INFO(8499);

%TYPE : REFERENCE Ÿ��. ���̺��.�÷���%TYPE
%ROWTYPE : COMPOSITE Ÿ��  ���̺��%ROWTYPE : ���̺��� ��� ���� Ÿ��

�μ���ȣ�� ���Ķ���ͷ� �ָ�
�ش� �μ��� �μ���� �ٹ����� ����ϴ� ���ν����� �ۼ��սô�

CREATE OR REPLACE PROCEDURE RTYPE(PDNO IN DEPT.DEPTNO%TYPE)
IS
VDEPT DEPT%ROWTYPE;
BEGIN
SELECT DNAME, LOC INTO VDEPT.DNAME, VDEPT.LOC 
FROM DEPT WHERE DEPTNO=PDNO;

DBMS_OUTPUT.PUT_LINE('�μ���ȣ: '||PDNO);
DBMS_OUTPUT.PUT_LINE('�� �� �� :'||VDEPT.DNAME);
DBMS_OUTPUT.PUT_LINE('�μ���ġ: '||VDEPT.LOC);
-- ����ó���ϱ�
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE(PDNO||'�� �μ� ������ �����ϴ�.');
END;
/
EXECUTE RTYPE(50);


--# table type : composite type (���յ�����Ÿ��) => �迭�� �����
--table Ÿ�Կ� �����ϱ� ���� �ε����� �ִµ� binary_integer ������ ���� �ε�����
--�̿��Ҽ��ִ�.
--
---����
--	TYPE table_type_name IS TABLE OF
--	{column_type | variable%TYPE| table.column%TYPE} [NOT NULL]
--	[INDEX BY BINARY_INTEGER];
--	identifier table_type_name;

������� ���� ������ ���� ���̺� Ÿ���� ������ �����ϰ�
������� ���� ������ �����ϱ�
�ݺ��� �̿��ؼ� �̸��� ���� ���� ����ϱ�

create or replace procedure table_type(pdno in emp.deptno%type)
is
--table ����
    type ename_table is table of emp.ename%type
    index by binary_integer;
--table type ���� ����
    ename_tab ename_table;
    i binary_integer :=0;
begin
    for k in (select ename from emp where deptno=pdno) loop
    i:= i+1;
    -- ���̺� ������ ������ ������ �����Ѵ�
    ename_tab(i) :=k.ename;
    end loop;
    
    --���̕� Ÿ�Կ� ����� ���� �������.
    for j in 1..i loop
        dbms_output.put_line(ename_tab(j));
    
    end loop;
end;
/

execute table_type(30);

create or replace procedure table_type2(pdno in emp.deptno%type)
is
--table ����
    type ename_table is table of emp.ename%type
    index by binary_integer;
    type job_table is table of emp.job%type
    index by binary_integer;
--table type ���� ����
    ename_tab ename_table;
    job_tab job_table;
    i binary_integer :=0;
begin
    for k in (select ename,job from emp where deptno=pdno) loop
    i:= i+1;
    -- ���̺� ������ ������ ������ �����Ѵ�
    ename_tab(i) :=k.ename;
    job_tab(i) := k.job;
    end loop;
    
    --���̕� Ÿ�Կ� ����� ���� �������.
    for j in 1..i loop
        dbms_output.put_line(ename_tab(j)||' , '||job_tab(j));
    end loop;
end;
/

execute table_type2(30);

# RECORD TYPE
��ǰ��ȣ�� �Է��ϸ� �ش��ǰ�� ��ǰ��, �ǸŰ�, ������ ����ϴ� ���ν����� �ۼ��ϼ���.

accept pnum prompt '��ȸ�� ��ǰ��ȣ�� �Է��ϼ���'
-- pnum �� ����Ҷ��� &pnum

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
    dbms_output.put_line(vpnum||'�� ��ǰ ����------');
    dbms_output.put_line('��ǰ��: ' ||prod_rec.vpname);
    dbms_output.put_line('������: ' ||prod_rec.vcomp);
    dbms_output.put_line('�� ��: ' ||prod_rec.vprice);

end;
/


���ε� ���� - non-pl/sql����
variable myvar number
--���ν��� ���ο� ���ε� ������ �����Ϸ���
--���ε庯�� �տ� �ݷ�(:)�� ���� ���ξ�� ����Ѵ�.
declare
begin
:myvar :=700;
end;
/
print myvar;

--# ���ν��� �Ķ���� ����
--[1] in �Ķ����
--[2] out �Ķ����
--[3] in out �Ķ����
--
--memo���̺� ���ο� ���ڵ带 insert�ϴ� ���ν����� �ۼ��ϼ���
--�ۼ��ڿ� �޸𳻿��� in �Ķ���ͷ� �޽��ϴ�.
CREATE OR REPLACE PROCEDURE MEMO_ADD(
PNAME IN VARCHAR2 DEFAULT '�ƹ���',
PMSG IN MEMO.MSG%TYPE)
IS
BEGIN
    INSERT INTO MEMO(IDX,NAME,MSG,WDATE)
    VALUES(MEMO_SEQ.NEXTVAL,PNAME, PMSG, SYSDATE);
    COMMIT;
END;
/

exec memo_add('ȫ�浿','���ν����� �Է¹޾Ҿ��');
exec memo_add(pmsg=>'�ȳ�?');
select * from memo;

OUT PARAMETER : ���ν����� ����ڿ��� �Ѱ��ִ� ��
	���ν������� ���� ������ �� �ִ�.
	����Ʈ ���� ������ �� ����.

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
������
���ε� ���� ����
���ν����� �����Ҷ� ���ε庯���� �ƿ��Ķ������ �Ű������� �����Ѵ�
���ε� �������� ���
var gname varchar2(20);
exec emp_find(10000,:gname);

print gname;

--�μ���ȣ�� ���Ķ���ͷ� �ް�, �޿� �λ���� ���Ķ���ͷ� �޾Ƽ�
--EMP���̺��� Ư�� �μ� �������� �޿��� �λ����ְ�
--�׷��� �ش� �μ��� ��ձ޿��� �ƿ��Ķ���ͷ� �����ϴ� ���ν�����
--�ۼ��� ��
--�ش� �μ��� ��ձ޿��� ����ϼ���

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

--MEMO_EDIT ���ν����� �ۼ��ϼ���
--���Ķ���� 3�� �޾Ƽ�(�۹�ȣ, �ۼ���, �޽���)
--UPDATE���� �����ϴ� ���ν���

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

exec memo_edit(10,'�ƹ���','edit_memo�� ������Ʈ');

select * from memo;
update memo set name='�赥��',msg='������ɱ�' where idx=11;
rollback;
commit;