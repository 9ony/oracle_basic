DROP INDEX PK_UPCATEGORY;
/* ����ī�װ� */
DROP TABLE UPCATEGORY
	CASCADE CONSTRAINTS;
/* ����ī�װ� */
CREATE TABLE UPCATEGORY (
	UPCG_CODE NUMBER(8) NOT NULL, /* ����ī�װ��ڵ� */
	UPCG_NAME VARCHAR2(30) NOT NULL /* ����ī�װ��� */
);
COMMENT ON TABLE UPCATEGORY IS '����ī�װ�';
COMMENT ON COLUMN UPCATEGORY.UPCG_CODE IS '����ī�װ��ڵ�';
COMMENT ON COLUMN UPCATEGORY.UPCG_NAME IS '����ī�װ���';
CREATE UNIQUE INDEX PK_UPCATEGORY
	ON UPCATEGORY (
		UPCG_CODE ASC
	);
ALTER TABLE UPCATEGORY
	ADD
		CONSTRAINT PK_UPCATEGORY
		PRIMARY KEY (
			UPCG_CODE
		);
----------------------------------------------
DROP INDEX PK_DOWNCATEGORY;
/* ����ī�װ� */
DROP TABLE DOWNCATEGORY
	CASCADE CONSTRAINTS;
/* ����ī�װ� */
CREATE TABLE DOWNCATEGORY (
	DOWNCG_CODE NUMBER(8) NOT NULL, /* ����ī�װ��ڵ� */
	UPCG_CODE NUMBER(8) NOT NULL, /* ����ī�װ��ڵ� */
	DOWNCG_NAME VARCHAR2(30) /* ����ī�װ��� */
);
COMMENT ON TABLE DOWNCATEGORY IS '����ī�װ�';
COMMENT ON COLUMN DOWNCATEGORY.DOWNCG_CODE IS '����ī�װ��ڵ�';
COMMENT ON COLUMN DOWNCATEGORY.UPCG_CODE IS '����ī�װ��ڵ�';
COMMENT ON COLUMN DOWNCATEGORY.DOWNCG_NAME IS '����ī�װ���';
CREATE UNIQUE INDEX PK_DOWNCATEGORY
	ON DOWNCATEGORY (
		DOWNCG_CODE ASC,
		UPCG_CODE ASC
	);
ALTER TABLE DOWNCATEGORY
	ADD
		CONSTRAINT PK_DOWNCATEGORY
		PRIMARY KEY (
			DOWNCG_CODE,
			UPCG_CODE
		);
ALTER TABLE DOWNCATEGORY
	ADD
		CONSTRAINT FK_UPCATEGORY_TO_DOWNCATEGORY
		FOREIGN KEY (
			UPCG_CODE
		)
		REFERENCES UPCATEGORY (
			UPCG_CODE
		);
		
create sequence upcategory_seq nocache;
create sequence downcategory_seq nocache;
commit;
insert into upcategory values(upcategory_seq.nextval,'������ǰ');
insert into upcategory values(upcategory_seq.nextval,'��Ȱ��ǰ');
insert into upcategory values(upcategory_seq.nextval,'�Ƿ�');
commit;
select * from upcategory;
insert into downcategory(upcg_code,downcg_code, downcg_name) values(1, downcategory_seq.nextval,'�ֹ氡��');
insert into downcategory(upcg_code,downcg_code, downcg_name) values(1, downcategory_seq.nextval,'��Ȱ����');
insert into downcategory(upcg_code,downcg_code, downcg_name) values(2, downcategory_seq.nextval,'����');
insert into downcategory(upcg_code,downcg_code, downcg_name) values(2, downcategory_seq.nextval,'����');
insert into downcategory(upcg_code,downcg_code, downcg_name) values(3, downcategory_seq.nextval,'�����Ƿ�');
insert into downcategory(upcg_code,downcg_code, downcg_name) values(3, downcategory_seq.nextval,'�����Ƿ�');
commit;
select * from downcategory;