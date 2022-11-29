/* ȸ�� */
CREATE TABLE member (
	idx NUMBER(8) NOT NULL, /* ȸ����ȣ */
	name VARCHAR2(30 BYTE) NOT NULL, /* �̸� */
	userid VARCHAR2(20 BYTE) NOT NULL, /* ���̵� */
	pwd VARCHAR2(16 BYTE) NOT NULL, /* ��й�ȣ */
	hp1 CHAR(3 BYTE) NOT NULL, /* ����ó1 */
	hp2 CHAR(4 BYTE) NOT NULL, /* ����ó2 */
	hp3 CHAR(4 CHAR) NOT NULL, /* ����ó3 */
	post CHAR(5 CHAR), /* �����ȣ */
	addr1 VARCHAR2(100 BYTE), /* �ּ�1 */
	addr2 VARCHAR2(100 BYTE), /* �ּ�2 */
	indate DATE, /* ������ */
	mileage NUMBER(8), /* ������ */
	status NUMBER(2) /* ȸ������ */
);

COMMENT ON TABLE member IS 'ȸ��';

COMMENT ON COLUMN member.idx IS 'ȸ����ȣ';

COMMENT ON COLUMN member.name IS '�̸�';

COMMENT ON COLUMN member.userid IS '���̵�';

COMMENT ON COLUMN member.pwd IS '��й�ȣ';

COMMENT ON COLUMN member.hp1 IS '����ó1';

COMMENT ON COLUMN member.hp2 IS '����ó2';

COMMENT ON COLUMN member.hp3 IS '����ó3';

COMMENT ON COLUMN member.post IS '�����ȣ';

COMMENT ON COLUMN member.addr1 IS '�ּ�1';

COMMENT ON COLUMN member.addr2 IS '�ּ�2';

COMMENT ON COLUMN member.indate IS '������';

COMMENT ON COLUMN member.mileage IS '������';

COMMENT ON COLUMN member.status IS 'ȸ������';

CREATE UNIQUE INDEX PK_member
	ON member (
		idx ASC
	);

ALTER TABLE member
	ADD
		CONSTRAINT PK_member
		PRIMARY KEY (
			idx
		);

/* ��ǰ */
CREATE TABLE product (
	PNUM NUMBER(8) NOT NULL, /* ��ǰ��ȣ */
	DOWNCG_CODE NUMBER(8), /* ����ī�װ��ڵ� */
	UPCG_CODE NUMBER(8), /* ����ī�װ��ڵ� */
	PNAME VARCHAR2(50 BYTE) NOT NULL, /* ��ǰ�� */
	PIMAGE1 VARCHAR2(50), /* �̹���1 */
	PIMAGE2 VARCHAR2(50), /* �̹���2 */
	PIMAGE3 VARCHAR2(50), /* �̹���3 */
	PRICE NUMBER(8) NOT NULL, /* ��ǰ���� */
	SALEPRICE NUMBER(8), /* ��ǰ�ǸŰ� */
	PQTY NUMBER(8), /* ��ǰ���� */
	POINT NUMBER(8), /* ����Ʈ */
	PSPEC VARCHAR2(200 BYTE), /* ���� */
	PCONTENTS VARCHAR2(1000 BYTE), /* ��ǰ���� */
	PCOMPANY VARCHAR2(50 BYTE), /* ������ */
	PINDATE DATE /* ����� */
);

COMMENT ON TABLE product IS '��ǰ';

COMMENT ON COLUMN product.PNUM IS '��ǰ��ȣ';

COMMENT ON COLUMN product.DOWNCG_CODE IS '����ī�װ��ڵ�';

COMMENT ON COLUMN product.UPCG_CODE IS '����ī�װ��ڵ�';

COMMENT ON COLUMN product.PNAME IS '��ǰ��';

COMMENT ON COLUMN product.PIMAGE1 IS '�̹���1';

COMMENT ON COLUMN product.PIMAGE2 IS '�̹���2';

COMMENT ON COLUMN product.PIMAGE3 IS '�̹���3';

COMMENT ON COLUMN product.PRICE IS '��ǰ����';

COMMENT ON COLUMN product.SALEPRICE IS '��ǰ�ǸŰ�';

COMMENT ON COLUMN product.PQTY IS '��ǰ����';

COMMENT ON COLUMN product.POINT IS '����Ʈ';

COMMENT ON COLUMN product.PSPEC IS '����';

COMMENT ON COLUMN product.PCONTENTS IS '��ǰ����';

COMMENT ON COLUMN product.PCOMPANY IS '������';

COMMENT ON COLUMN product.PINDATE IS '�����';

CREATE UNIQUE INDEX PK_product
	ON product (
		PNUM ASC
	);

ALTER TABLE product
	ADD
		CONSTRAINT PK_product
		PRIMARY KEY (
			PNUM
		);

/* ����ī�װ� */
CREATE TABLE UPCATEGORY (
	UPCG_CODE NUMBER(8) NOT NULL, /* ����ī�װ��ڵ� */
	UPCG_NAME VARCHAR2(30 BYTE) NOT NULL /* ����ī�װ��� */
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

/* ����ī�װ� */
CREATE TABLE DOWNCATEGORY (
	DOWNCG_CODE NUMBER(8) NOT NULL, /* ����ī�װ��ڵ� */
	UPCG_CODE NUMBER(8) NOT NULL, /* ����ī�װ��ڵ� */
	DOWNCG_NAME VARCHAR2(30 BYTE) NOT NULL /* ����ī�װ��� */
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

/* ��ٱ��� */
CREATE TABLE CART (
	CARTNUM NUMBER(8) NOT NULL, /* ��ٱ��Ϲ�ȣ */
	idx_FK NUMBER(8), /* ȸ����ȣ */
	PNUM_FK NUMBER(8), /* ��ǰ��ȣ */
	OQTY NUMBER(8), /* ���� */
	INDATE DATE /* ����� */
);

COMMENT ON TABLE CART IS '��ٱ���';

COMMENT ON COLUMN CART.CARTNUM IS '��ٱ��Ϲ�ȣ';

COMMENT ON COLUMN CART.idx_FK IS 'ȸ����ȣ';

COMMENT ON COLUMN CART.PNUM_FK IS '��ǰ��ȣ';

COMMENT ON COLUMN CART.OQTY IS '����';

COMMENT ON COLUMN CART.INDATE IS '�����';

/* �ı�Խ��� */
CREATE TABLE REVIEW (
	NUM NUMBER(8) NOT NULL, /* �۹�ȣ */
	idx NUMBER(8), /* ȸ����ȣ */
	PNUM NUMBER(8), /* ��ǰ��ȣ */
	TITLE VARCHAR2(200), /* ���� */
	NAME VARCHAR2(30), /* �ۼ��� */
	CONTENT VARCHAR2(2000), /* ���� */
	SCORE NUMBER(1), /* ������ */
	WDATE DATE, /* �ۼ��� */
	FILENAME VARCHAR2(100) /* ���ε����� */
);

COMMENT ON TABLE REVIEW IS '�ı�Խ���';

COMMENT ON COLUMN REVIEW.NUM IS '�۹�ȣ';

COMMENT ON COLUMN REVIEW.idx IS 'ȸ����ȣ';

COMMENT ON COLUMN REVIEW.PNUM IS '��ǰ��ȣ';

COMMENT ON COLUMN REVIEW.TITLE IS '����';

COMMENT ON COLUMN REVIEW.NAME IS '�ۼ���';

COMMENT ON COLUMN REVIEW.CONTENT IS '����';

COMMENT ON COLUMN REVIEW.SCORE IS '������';

COMMENT ON COLUMN REVIEW.WDATE IS '�ۼ���';

COMMENT ON COLUMN REVIEW.FILENAME IS '���ε�����';

CREATE UNIQUE INDEX PK_REVIEW
	ON REVIEW (
		NUM ASC
	);

ALTER TABLE REVIEW
	ADD
		CONSTRAINT PK_REVIEW
		PRIMARY KEY (
			NUM
		);

/* �ֹ����� */
CREATE TABLE ORDER_DESC (
	ONUM VARCHAR2(30) NOT NULL, /* �ֹ���ȣ */
	idx NUMBER(8) NOT NULL, /* ȸ����ȣ */
	OTOTALPRICE NUMBER(10), /* �ֹ��Ѿ� */
	ORORALPOINT NUMBER(8), /* ��������Ʈ */
	ORDERLIVER VARCHAR2(20 BYTE), /* ��ۻ��� */
	OPAYSTATE VARCHAR2(20 BYTE), /* ���һ��� */
	ORDERDATE DATE, /* �ֹ��� */
	ORDERMEMO VARCHAR2(200 BYTE), /* ��۽ÿ�û���� */
	OPOINTUSE NUMBER(2) /* �����ݻ��� */
);

COMMENT ON TABLE ORDER_DESC IS '�ֹ�����';

COMMENT ON COLUMN ORDER_DESC.ONUM IS '�ֹ���ȣ';

COMMENT ON COLUMN ORDER_DESC.idx IS 'ȸ����ȣ';

COMMENT ON COLUMN ORDER_DESC.OTOTALPRICE IS '�ֹ��Ѿ�';

COMMENT ON COLUMN ORDER_DESC.ORORALPOINT IS '��������Ʈ';

COMMENT ON COLUMN ORDER_DESC.ORDERLIVER IS '��ۻ���';

COMMENT ON COLUMN ORDER_DESC.OPAYSTATE IS '���һ���';

COMMENT ON COLUMN ORDER_DESC.ORDERDATE IS '�ֹ���';

COMMENT ON COLUMN ORDER_DESC.ORDERMEMO IS '��۽ÿ�û����';

COMMENT ON COLUMN ORDER_DESC.OPOINTUSE IS '�����ݻ���';

CREATE UNIQUE INDEX PK_ORDER_DESC
	ON ORDER_DESC (
		ONUM ASC
	);

ALTER TABLE ORDER_DESC
	ADD
		CONSTRAINT PK_ORDER_DESC
		PRIMARY KEY (
			ONUM
		);

/* �ֹ���ǰ */
CREATE TABLE ORDER_PRODUCT (
	ONUM VARCHAR2(30) NOT NULL, /* �ֹ���ȣ */
	PNUM NUMBER(8) NOT NULL, /* ��ǰ��ȣ */
	SALEPRICE NUMBER(10), /* �ܰ� */
	OQTY NUMBER(8), /* ���� */
	PIMAGE VARCHAR2(50), /* �̹���1 */
	OPOINT NUMBER(8) /* ����Ʈ */
);

COMMENT ON TABLE ORDER_PRODUCT IS '�ֹ���ǰ';

COMMENT ON COLUMN ORDER_PRODUCT.ONUM IS '�ֹ���ȣ';

COMMENT ON COLUMN ORDER_PRODUCT.PNUM IS '��ǰ��ȣ';

COMMENT ON COLUMN ORDER_PRODUCT.SALEPRICE IS '�ܰ�';

COMMENT ON COLUMN ORDER_PRODUCT.OQTY IS '����';

COMMENT ON COLUMN ORDER_PRODUCT.PIMAGE IS '�̹���1';

COMMENT ON COLUMN ORDER_PRODUCT.OPOINT IS '����Ʈ';

CREATE UNIQUE INDEX PK_ORDER_PRODUCT
	ON ORDER_PRODUCT (
		ONUM ASC,
		PNUM ASC
	);

ALTER TABLE ORDER_PRODUCT
	ADD
		CONSTRAINT PK_ORDER_PRODUCT
		PRIMARY KEY (
			ONUM,
			PNUM
		);

/* ������ */
CREATE TABLE RECEIVER (
	ONUM VARCHAR2(30) NOT NULL, /* �ֹ���ȣ */
	NAME VARCHAR2(30) NOT NULL, /* �����ڸ� */
	HP1 CHAR(3) NOT NULL, /* ����ó1 */
	HP2 CHAR(4) NOT NULL, /* ����ó2 */
	HP3 CHAR(4) NOT NULL, /* ����ó3 */
	POST CHAR(5) NOT NULL, /* �����ȣ */
	ADDR1 VARCHAR2(100) NOT NULL, /* �ּ�1 */
	ADDR2 VARCHAR2(100) NOT NULL /* �ּ�2 */
);

COMMENT ON TABLE RECEIVER IS '������';

COMMENT ON COLUMN RECEIVER.ONUM IS '�ֹ���ȣ';

COMMENT ON COLUMN RECEIVER.NAME IS '�����ڸ�';

COMMENT ON COLUMN RECEIVER.HP1 IS '����ó1';

COMMENT ON COLUMN RECEIVER.HP2 IS '����ó2';

COMMENT ON COLUMN RECEIVER.HP3 IS '����ó3';

COMMENT ON COLUMN RECEIVER.POST IS '�����ȣ';

COMMENT ON COLUMN RECEIVER.ADDR1 IS '�ּ�1';

COMMENT ON COLUMN RECEIVER.ADDR2 IS '�ּ�2';

CREATE UNIQUE INDEX PK_RECEIVER
	ON RECEIVER (
		ONUM ASC
	);

ALTER TABLE RECEIVER
	ADD
		CONSTRAINT PK_RECEIVER
		PRIMARY KEY (
			ONUM
		);

ALTER TABLE product
	ADD
		CONSTRAINT FK_DOWNCATEGORY_TO_product
		FOREIGN KEY (
			DOWNCG_CODE,
			UPCG_CODE
		)
		REFERENCES DOWNCATEGORY (
			DOWNCG_CODE,
			UPCG_CODE
		);

ALTER TABLE product
	ADD
		CONSTRAINT FK_UPCATEGORY_TO_product
		FOREIGN KEY (
			UPCG_CODE
		)
		REFERENCES UPCATEGORY (
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

ALTER TABLE CART
	ADD
		CONSTRAINT FK_member_TO_CART
		FOREIGN KEY (
			idx_FK
		)
		REFERENCES member (
			idx
		);

ALTER TABLE CART
	ADD
		CONSTRAINT FK_product_TO_CART
		FOREIGN KEY (
			PNUM_FK
		)
		REFERENCES product (
			PNUM
		);

ALTER TABLE REVIEW
	ADD
		CONSTRAINT FK_product_TO_REVIEW
		FOREIGN KEY (
			PNUM
		)
		REFERENCES product (
			PNUM
		);

ALTER TABLE REVIEW
	ADD
		CONSTRAINT FK_member_TO_REVIEW
		FOREIGN KEY (
			idx
		)
		REFERENCES member (
			idx
		);

ALTER TABLE ORDER_DESC
	ADD
		CONSTRAINT FK_member_TO_ORDER_DESC
		FOREIGN KEY (
			idx
		)
		REFERENCES member (
			idx
		);

ALTER TABLE ORDER_PRODUCT
	ADD
		CONSTRAINT FK_ORDER_DESC_TO_ORDER_PRODUCT
		FOREIGN KEY (
			ONUM
		)
		REFERENCES ORDER_DESC (
			ONUM
		);

ALTER TABLE ORDER_PRODUCT
	ADD
		CONSTRAINT FK_product_TO_ORDER_PRODUCT
		FOREIGN KEY (
			PNUM
		)
		REFERENCES product (
			PNUM
		);

ALTER TABLE RECEIVER
	ADD
		CONSTRAINT FK_ORDER_DESC_TO_RECEIVER
		FOREIGN KEY (
			ONUM
		)
		REFERENCES ORDER_DESC (
			ONUM
		);
-----���̺� ���� �� �������� �߰�-----
--create sequence MEMBER_IDX_SQ;


--status �������� ��Ī���� �÷��� ������ �����͸� ������ ������ ���̺��� ����� ��ɾ�

select member.*, decode(status,0,'Ȱ��ȸ��',-1,'����ȸ��',-2,'Ż��ȸ��') statusStr
from member;
-- ������ ����Ŭ�����Ǵ°�
select member.*,
case status
    when 0 then 'Ȱ��ȸ��'
    when -1 then '����ȸ��'
    when -2 then 'Ż��ȸ��'
end as statusStr
from member;
-- case���̿� mysql������
select * from member;
--update member set status='-2' where idx=6;
--commit;

update member set status=9 where idx=1;
commit;

-- grant create view, create synonym to multi; >>system������ multi���� ��������Ѻο�

--status���� -1 ���� ū ȸ���鸸 ��Ƽ� memberView�� ��������
create or replace view memberView
as
select member.*, decode(status,0,'Ȱ��ȸ��',-1,'����ȸ��',-2,'Ż��ȸ��',9,'������') statusStr
from member where status >-2;

select * from memberView;

---------------------------------------------------
create sequence product_seq nocache;