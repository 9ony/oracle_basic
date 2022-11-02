create table [��Ű��.]���̺��(
    �÷��� �ڷ��� default �⺻�� constraint ���������̸� ������������,
    ...
);

create table test_tab1(
    no number(2) constraint test_tab1_no_pk primary key,
    name varchar2(20)
);

desc test_tab1;

�����ͻ������� ��ȸ

select constraint_name,index_name
from user_constraints;

select *
from user_constraints
where TABLE_NAME='TEST_TAB1';

insert into test_tab1(no,name)
values (1,null);

select*from test_tab1;
commit;

-- ���̺� ���ؿ��� pk����
create table test_tab2(
    no number(2),
    name varchar(2),
    constraint test_tab2_no_pk primary key (no)
    );
    
select *
from user_constraints
where TABLE_NAME='TEST_TAB2';

�������� ����

alter table ���̺�� drop constraint �������Ǹ�;
ALTER TABLE ���̺�� DISABLE CONSTRAINT �������Ǹ� [CASCADE];

test_tab2�� pk���������� �����ϼ���
alter table test_tab2 drop constraint test_tab2_no_pk;

#�������� �߰�
alter table ���̺�� add constraint �������Ǹ� ������������ (�÷���);
--test_tab2_no_pk�� �ٽ� ���������� �߰��غ�����
alter table test_tab2 add constraint test_tab2_pk primary key(no);

select * from user_constraints
where table_name='test_tab2';

# �������Ǹ� ����
alter table ���̺�� rename constraint �����̸� TO ���ο��̸�;

alter table test_tab2 rename constraint test_tab2_pk to test_tab2_no_pk2;
--------------------------------------
#foreign key ��������
�θ����̺�(master)�� pk�� �ڽ����̺�(detail)���� fk�� ����
==> fk�� detail���̺��� �����ؾ� ��
master ���̺��� pk,uk�� ���ǵ� �÷��� fk�� ������ �� �ִ�.
�÷��� �ڷ����� ��ġ�ؾ� �Ѵ�. ũ��� ��ġ���� �ʾƵ� ��������� ������ �����ִ°� �����.
on delete cascade �ɼ��� �ָ� master ���̺��ڵ尡 �����ɶ�
detail���̺��� ���ڵ嵵 ���� �����ȴ�.
---------------------------------------------
create table dept_tab(
    deptno number(2),
    dname varchar2(15),
    loc varchar2(15),
    constraint dept_tab_deptno_pk primary key (deptno)
);

create table emp_tab(
    empno number(4),
    ename varchar2(20),
    job varchar2(10),
    mgr number(4) constraint emp_tab_mgr_fk REFERENCES emp_tab(empno),
    hiredate date,
    sal number(7,2),
    comm number(7,2),
    deptno number(2),
    --���̺� ���ؿ��� fk�ֱ�
    constraint emp_tab_deptno_fk foreign key (deptno)
    references dept_tab (deptno),
    constraint emp_tab_empno_pk primary key (empno)
);
�μ����� insert�ϱ�
10 ��ȹ�� ����
20 �λ�� ��õ
select * from dept_tab;
insert into dept_tab values(10,'��ȹ��','����');
insert into dept_tab values(20,'�λ��','��õ');

-----------------------------------
������� insert�ϱ�
insert into emp_tab(empno,ename,job,mgr,deptno)
values(1000,'ȫ�浿','��ȹ',NULL,10);

insert into emp_tab(empno,ename,job,mgr,deptno)
values(1002,'�̿���','�λ�',NULL,20);
commit;
select * from emp_tab;

insert into emp_tab(empno,ename,job,mgr,deptno)
values(1003,'�����','�빫',1002,20);
insert into emp_tab(empno,ename,job,mgr,deptno)
values(1004,'��浿','�繫',1001,20);
commit;

dept_tab���� ��ȹ�θ� �����غ���
delete from dept_tab where deptno=10;
---> �ڽķ��ڵ尡 ���� ���� �θ� ���̺��� ���ڵ带 ������ �� ����.

ȫ�浿�� 20�� �μ��� �̵��ϼ���.
update emp_tab set deptno=20 where ename='ȫ�浿';

commit;
select * from board_tab;
drop table board_tab;
create table board_tab(
    no number(8),
    userid varchar2(20) not null,
    title varchar2(100),
    content varchar2(1000),
    wdate date default sysdate,
    constraint board_tab_no_pk primary key (no)
);
select * from user_constraints where table_name='REPLY_TAB';
select * from user_constraints where table_name='BOARD_TAB';
create table reply_tab(
    rno number(8),
    content varchar2(300),
    userid varchar2(20) not null,
    no_fk number(8),
    constraint reply_tab_rno_pk primary key(rno),
    constraint reply_tab_no_fk foreign key(no_fk)
    references board_tab(no) on delete cascade
);

insert into board_tab values(2,'choi','�����ݰ�����','�ȳ�2',sysdate);
select * from board_tab;
insert into reply_tab values(3,'�ȳ�???','KIM','1');
commit;
select * 
from board_tab b join reply_tab r
on b.no = r.no_fk order by 1;

delete from board_tab where no=2;
--on delete cascade �ɼ��� �־��� ������ �θ���� �����ϸ� �ڽı۵� �Բ� �����ȴ�.

# unique key
�÷����� ����
create table uni_tab1(
    deptno number(2) constraint uni_tab1_deptno_uk unique,
    dname char(20),
    loc char(10)
);
select * from user_constraints where table_name='UNI_TAB1';
INSERT INTO UNI_TAB1 VALUES(NULL,'������4','����');
SELECT * FROM UNI_TAB1;
COMMIT;

create table uni_tab2(
    deptno number(2), 
    dname char(20),
    loc char(10),
    constraint uni_tab2_deptno_uk unique (DEPTNO)
);

#NOT NULL �������� -üũ���������� ����
- NOT NULL ���������� �÷� ���ؿ����� ������ �� �ִ�.
CREATE TABLE NN_TAB(
DEPTNO NUMBER(2) CONSTRAINT NN_TAB_DEPTNO_NN NOT NULL,
DNAME CHAR(20) NOT NULL,
LOC CHAR(10)
-- CONSTRAINT LOC_NN NOT NULL (LOC) [X]���̺���ؿ����ȵ�!
);

# CHECK ��������
-���� �����ؾ��ϴ� ������ �����Ѵ�.

CREATE TABLE CK_TAB(
DEPTNO NUMBER(2) CONSTRAINT CK_TAB_DEPTNO_CK CHECK (DEPTNO IN(10,20,30,40)),
DENAME CHAR(20)
);
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='CK_TAB2';
INSERT INTO CK_TAB VALUES(50,'AAA');

CREATE TABLE CK_TAB2(
DEPTNO NUMBER(2),
DENAME CHAR(20),
LOC CHAR(20),
CONSTRAINT CK_TAB2_LOC_CK CHECK (LOC IN('����','����'))
);
INSERT INTO CK_TAB2 VALUES(10,'AAA','����');

ZIPCODE ���̺� �����
CREATE TABLE ZIPCODE(
    POST1 CHAR(3),
    POST2 CHAR(3),
    ADDR VARCHAR2(60) CONSTRAINT ZIPCODE_ADDR_NN NOT NULL,
    CONSTRAINT ZIPCODE_POST1_POST2_PK PRIMARY KEY(POST1,POST2)
);
MEMBER_TAB ���̺����
CREATE TABLE MEMBER_TAB(
    ID NUMBER(4) NOT NULL,
    NAME VARCHAR2(10) NOT NULL,
    GENDER CHAR(1),
    JUMIN1 CHAR(6),
    JUMIN2 CHAR(7),
    TEL VARCHAR2(15),
    POST1 CHAR(3),
    POST2 CHAR(3),
    ADDR VARCHAR2(60),
    CONSTRAINT MEMBER_TAB_ID_PK PRIMARY KEY(ID),
    CONSTRAINT MEMBER_TAB_GENDER_CK CHECK ( GENDER IN('F','M')),
    CONSTRAINT MEMBER_TAB_JUMIN_UK UNIQUE (JUMIN1,JUMIN2),
    CONSTRAINT MEMBER_TAB_POST_PK FOREIGN KEY (POST1,POST2)
    REFERENCES ZIPCODE(POST1,POST2)
);
DESC MEMBER_TAB;

# SUBQUERY�� �̿��� ���̺� ����
--��� ���̺��� 30�� �μ��� �ٹ��ϴ� ����� ������ �����Ͽ�
--	          EMP_30 ���̺��� �����Ͽ���. �� ���� ���,�̸�,����,�Ի�����,
--		  �޿�,���ʽ��� �����Ѵ�.
CREATE TABLE EMP_30(ENO,ENAME,JOB,HDATE,SAL,COMM)
AS
SELECT EMPNO,ENAME,JOB,HIREDATE,SAL,COMM
FROM EMP WHERE DEPTNO=30;

SELECT * FROM EMP_30;
SELECT * FROM EMP WHERE DEPTNO=30;
--[����1]
--		EMP���̺��� �μ����� �ο���,��� �޿�, �޿��� ��, �ּ� �޿�,
--		�ִ� �޿��� �����ϴ� EMP_DEPTNO ���̺��� �����϶�.
CREATE TABLE EMP_DEPTNO(ECOUNT,AVGSAL,SUMSAL,MINSAL,MAXSAL)
AS
SELECT COUNT(EMPNO),ROUND(AVG(SAL)),SUM(SAL),MIN(SAL),MAX(SAL) FROM EMP
GROUP BY DEPTNO;
SELECT * FROM EMP_DEPTNO;
--	[����2]	EMP���̺��� ���,�̸�,����,�Ի�����,�μ���ȣ�� �����ϴ�
--		EMP_TEMP ���̺��� �����ϴµ� �ڷ�� �������� �ʰ� ������
--		�����Ͽ���
CREATE TABLE EMP_TEMP
AS
SELECT EMPNO,ENAME,JOB,HIREDATE,DEPTNO
FROM EMP WHERE 1=2;

#DDL
CREATE, DROP, ALTER , RENAME, TUNCATE;

#�÷� �߰� ���� ����
ALTER TABLE ���̺�� ADD �߰����÷����� [DEFAULT ��];
ALTER TABLE ���̺�� MODIFY �������÷�����;
ALTER TABLE ���̺�� RENAME COLUMN OLD_NAME TO NEW_NAME;
ALTER TABLE ���̺�� DROP COLUMN �������÷���
--
CREATE TABLE TEMP(
NO NUMBER(4)
);
DESC TEMP;

TEMP���̺� NAME �÷��߰� NOTNULL���� �߰�
TEMP���̺� INDATE�߰��ϵ� �⺻���� SYSDATE
ALTER TABLE TEMP ADD NAME VARCHAR2(20) NOT NULL;
ALTER TABLE TEMP ADD INDATE DATE DEFAULT SYSDATE;

PRODUCTS ���̺� PROD_DESC �÷��� �߰��ϵ� NOT NULL ���������� �ּ���
ALTER TABLE PRODUCTS ADD PROD_DESC VARCHAR2(1000);
ALTER TABLE PRODUCTS DROP COLUMN PROD_DESC;
SELECT * FROM PRODUCTS;


TEMP���̺��� NO �÷��� �ڷ����� CHAR(4)�� ����
ALTER TABLE TEMP MODIFY NO CHAR(4);
DESC TEMP;

TEMP ���̺��� NO �÷����� NUM���� �����ϼ���.
ALTER TABLE TEMP RENAME COLUMN NO TO NUM;

TEMP ���̺��� INDATE �÷��� �����ϼ���
ALTER TABLE TEMP DROP COLUMN INDATE;

TEMP ���̺� NUM�� PRIMARY KEY �������� �߰�
ALTER TABLE TEMP ADD CONSTRAINT TEMP_NUM_PK PRIMARY KEY(NUM);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='TEMP';
INSERT INTO TEMP VALUES(5,'AAA');
DELETE FROM TEMP WHERE NUM=1;
ALTER TABLE TEMP ENABLE CONSTRAINT TEMP_NUM_PK;
SELECT * FROM TEMP;

#�������� Ȱ��ȭ
ALTER TABLE ���̺� ENABLE CONSTRAINT �������Ǹ� [CASCADE];

#��ü�̸� ����
RENAME �����̸� TO �������̸�;

TEMP ���̺���� TEST_TEMP���̺�� �����ϼ���
RENAME TEMP TO TEST_TEMP;

SELECT * FROM TEST_TEMP;

select * from memo;
