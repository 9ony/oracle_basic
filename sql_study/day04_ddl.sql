create table [스키마.]테이블명(
    컬럼명 자료형 default 기본값 constraint 제약조건이름 제약조건유형,
    ...
);

create table test_tab1(
    no number(2) constraint test_tab1_no_pk primary key,
    name varchar2(20)
);

desc test_tab1;

데이터사전에서 조회

select constraint_name,index_name
from user_constraints;

select *
from user_constraints
where TABLE_NAME='TEST_TAB1';

insert into test_tab1(no,name)
values (1,null);

select*from test_tab1;
commit;

-- 테이블 수준에서 pk제약
create table test_tab2(
    no number(2),
    name varchar(2),
    constraint test_tab2_no_pk primary key (no)
    );
    
select *
from user_constraints
where TABLE_NAME='TEST_TAB2';

제약조건 삭제

alter table 테이블명 drop constraint 제약조건명;
ALTER TABLE 테이블명 DISABLE CONSTRAINT 제약조건명 [CASCADE];

test_tab2의 pk제약조건을 삭제하세요
alter table test_tab2 drop constraint test_tab2_no_pk;

#제약조건 추가
alter table 테이블명 add constraint 제약조건명 제약조건유형 (컬럼명);
--test_tab2_no_pk에 다시 제약조건을 추가해보세요
alter table test_tab2 add constraint test_tab2_pk primary key(no);

select * from user_constraints
where table_name='test_tab2';

# 제약조건명 변경
alter table 테이블명 rename constraint 현재이름 TO 새로운이름;

alter table test_tab2 rename constraint test_tab2_pk to test_tab2_no_pk2;
--------------------------------------
#foreign key 제약조건
부모테이블(master)의 pk를 자식테이블(detail)에서 fk로 참조
==> fk는 detail테이블에서 정의해야 함
master 테이블의 pk,uk로 정의된 컬럼을 fk로 지정할 수 있다.
컬럼의 자료형이 일치해야 한다. 크기는 일치하지 않아도 상관없지만 가능한 맞춰주는게 권장됨.
on delete cascade 옵션을 주면 master 테이블레코드가 삭제될때
detail테이블의 레코드도 같이 삭제된다.
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
    --테이블 수준에서 fk주기
    constraint emp_tab_deptno_fk foreign key (deptno)
    references dept_tab (deptno),
    constraint emp_tab_empno_pk primary key (empno)
);
부서정보 insert하기
10 기획부 서울
20 인사부 인천
select * from dept_tab;
insert into dept_tab values(10,'기획부','서울');
insert into dept_tab values(20,'인사부','인천');

-----------------------------------
사원정보 insert하기
insert into emp_tab(empno,ename,job,mgr,deptno)
values(1000,'홍길동','기획',NULL,10);

insert into emp_tab(empno,ename,job,mgr,deptno)
values(1002,'이영희','인사',NULL,20);
commit;
select * from emp_tab;

insert into emp_tab(empno,ename,job,mgr,deptno)
values(1003,'김순희','노무',1002,20);
insert into emp_tab(empno,ename,job,mgr,deptno)
values(1004,'김길동','재무',1001,20);
commit;

dept_tab에서 기획부를 삭제해보기
delete from dept_tab where deptno=10;
---> 자식레코드가 있을 경우는 부모 테이블의 레코드를 삭제할 수 없다.

홍길동을 20번 부서로 이동하세요.
update emp_tab set deptno=20 where ename='홍길동';

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

insert into board_tab values(2,'choi','저도반가워요','안녕2',sysdate);
select * from board_tab;
insert into reply_tab values(3,'안녕???','KIM','1');
commit;
select * 
from board_tab b join reply_tab r
on b.no = r.no_fk order by 1;

delete from board_tab where no=2;
--on delete cascade 옵션은 주었기 때문에 부모글을 삭제하면 자식글도 함께 삭제된다.

# unique key
컬럼수준 제약
create table uni_tab1(
    deptno number(2) constraint uni_tab1_deptno_uk unique,
    dname char(20),
    loc char(10)
);
select * from user_constraints where table_name='UNI_TAB1';
INSERT INTO UNI_TAB1 VALUES(NULL,'영업부4','서울');
SELECT * FROM UNI_TAB1;
COMMIT;

create table uni_tab2(
    deptno number(2), 
    dname char(20),
    loc char(10),
    constraint uni_tab2_deptno_uk unique (DEPTNO)
);

#NOT NULL 제약조건 -체크제약조건의 일종
- NOT NULL 제약조건은 컬럼 수준에서만 제약할 수 있다.
CREATE TABLE NN_TAB(
DEPTNO NUMBER(2) CONSTRAINT NN_TAB_DEPTNO_NN NOT NULL,
DNAME CHAR(20) NOT NULL,
LOC CHAR(10)
-- CONSTRAINT LOC_NN NOT NULL (LOC) [X]테이블수준에선안됨!
);

# CHECK 제약조건
-행이 만족해야하는 조건을 정의한다.

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
CONSTRAINT CK_TAB2_LOC_CK CHECK (LOC IN('서울','수월'))
);
INSERT INTO CK_TAB2 VALUES(10,'AAA','서울');

ZIPCODE 테이블 만들기
CREATE TABLE ZIPCODE(
    POST1 CHAR(3),
    POST2 CHAR(3),
    ADDR VARCHAR2(60) CONSTRAINT ZIPCODE_ADDR_NN NOT NULL,
    CONSTRAINT ZIPCODE_POST1_POST2_PK PRIMARY KEY(POST1,POST2)
);
MEMBER_TAB 테이블만들기
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

# SUBQUERY를 이용한 테이블 생성
--사원 테이블에서 30번 부서에 근무하는 사원의 정보만 추출하여
--	          EMP_30 테이블을 생성하여라. 단 열은 사번,이름,업무,입사일자,
--		  급여,보너스를 포함한다.
CREATE TABLE EMP_30(ENO,ENAME,JOB,HDATE,SAL,COMM)
AS
SELECT EMPNO,ENAME,JOB,HIREDATE,SAL,COMM
FROM EMP WHERE DEPTNO=30;

SELECT * FROM EMP_30;
SELECT * FROM EMP WHERE DEPTNO=30;
--[문제1]
--		EMP테이블에서 부서별로 인원수,평균 급여, 급여의 합, 최소 급여,
--		최대 급여를 포함하는 EMP_DEPTNO 테이블을 생성하라.
CREATE TABLE EMP_DEPTNO(ECOUNT,AVGSAL,SUMSAL,MINSAL,MAXSAL)
AS
SELECT COUNT(EMPNO),ROUND(AVG(SAL)),SUM(SAL),MIN(SAL),MAX(SAL) FROM EMP
GROUP BY DEPTNO;
SELECT * FROM EMP_DEPTNO;
--	[문제2]	EMP테이블에서 사번,이름,업무,입사일자,부서번호만 포함하는
--		EMP_TEMP 테이블을 생성하는데 자료는 포함하지 않고 구조만
--		생성하여라
CREATE TABLE EMP_TEMP
AS
SELECT EMPNO,ENAME,JOB,HIREDATE,DEPTNO
FROM EMP WHERE 1=2;

#DDL
CREATE, DROP, ALTER , RENAME, TUNCATE;

#컬럼 추가 변경 삭제
ALTER TABLE 테이블명 ADD 추가할컬럼정보 [DEFAULT 값];
ALTER TABLE 테이블명 MODIFY 변경할컬럼정보;
ALTER TABLE 테이블명 RENAME COLUMN OLD_NAME TO NEW_NAME;
ALTER TABLE 테이블명 DROP COLUMN 삭제할컬럼명
--
CREATE TABLE TEMP(
NO NUMBER(4)
);
DESC TEMP;

TEMP테이블에 NAME 컬럼추가 NOTNULL조건 추가
TEMP테이블에 INDATE추가하되 기본값은 SYSDATE
ALTER TABLE TEMP ADD NAME VARCHAR2(20) NOT NULL;
ALTER TABLE TEMP ADD INDATE DATE DEFAULT SYSDATE;

PRODUCTS 테이블에 PROD_DESC 컬럼을 추가하되 NOT NULL 제약조건을 주세요
ALTER TABLE PRODUCTS ADD PROD_DESC VARCHAR2(1000);
ALTER TABLE PRODUCTS DROP COLUMN PROD_DESC;
SELECT * FROM PRODUCTS;


TEMP테이블의 NO 컬럼의 자료형을 CHAR(4)로 변경
ALTER TABLE TEMP MODIFY NO CHAR(4);
DESC TEMP;

TEMP 테이블의 NO 컬럼명을 NUM으로 변경하세요.
ALTER TABLE TEMP RENAME COLUMN NO TO NUM;

TEMP 테이블의 INDATE 컬럼을 삭제하세요
ALTER TABLE TEMP DROP COLUMN INDATE;

TEMP 테이블 NUM에 PRIMARY KEY 제약조건 추가
ALTER TABLE TEMP ADD CONSTRAINT TEMP_NUM_PK PRIMARY KEY(NUM);

SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='TEMP';
INSERT INTO TEMP VALUES(5,'AAA');
DELETE FROM TEMP WHERE NUM=1;
ALTER TABLE TEMP ENABLE CONSTRAINT TEMP_NUM_PK;
SELECT * FROM TEMP;

#제약조건 활성화
ALTER TABLE 테이블 ENABLE CONSTRAINT 제약조건명 [CASCADE];

#객체이름 변경
RENAME 현재이름 TO 변경할이름;

TEMP 테이블명을 TEST_TEMP테이블로 변경하세요
RENAME TEMP TO TEST_TEMP;

SELECT * FROM TEST_TEMP;

select * from memo;
