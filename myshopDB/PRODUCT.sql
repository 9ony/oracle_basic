DROP INDEX PK_PRODUCT;

/* ��ǰ */
DROP TABLE PRODUCT 
	CASCADE CONSTRAINTS;

/* ��ǰ */
CREATE TABLE PRODUCT (
	PNUM NUMBER(8) NOT NULL, /* ��ǰ��ȣ */
	DOWNCG_CODE NUMBER(8), /* ����ī�װ��ڵ� */
	UPCG_CODE NUMBER(8), /* ����ī�װ��ڵ� */
	PNAME VARCHAR2(50) NOT NULL, /* ��ǰ�� */
	PIMAGE1 VARCHAR2(50), /* �̹���1 */
	PIMAGE2 VARCHAR2(50), /* �̹���2 */
	PIMAGE3 VARCHAR2(50), /* �̹���3 */
	PRICE NUMBER(8) NOT NULL, /* ��ǰ���� */
	SALEPRICE NUMBER(8), /* ��ǰ�ǸŰ� */
	PQTY NUMBER(8), /* ��ǰ���� */
	POINT NUMBER(8), /* ����Ʈ */
	PSPEC VARCHAR2(20), /* ���� */
	PCONTENTS VARCHAR2(1000), /* ��ǰ���� */
	PCOMPANY VARCHAR2(50), /* ������ */
	PINDATE DATE /* ����� */
);

COMMENT ON TABLE PRODUCT IS '��ǰ';

COMMENT ON COLUMN PRODUCT.PNUM IS '��ǰ��ȣ';

COMMENT ON COLUMN PRODUCT.DOWNCG_CODE IS '����ī�װ��ڵ�';

COMMENT ON COLUMN PRODUCT.UPCG_CODE IS '����ī�װ��ڵ�';

COMMENT ON COLUMN PRODUCT.PNAME IS '��ǰ��';

COMMENT ON COLUMN PRODUCT.PIMAGE1 IS '�̹���1';

COMMENT ON COLUMN PRODUCT.PIMAGE2 IS '�̹���2';

COMMENT ON COLUMN PRODUCT.PIMAGE3 IS '�̹���3';

COMMENT ON COLUMN PRODUCT.PRICE IS '��ǰ����';

COMMENT ON COLUMN PRODUCT.SALEPRICE IS '��ǰ�ǸŰ�';

COMMENT ON COLUMN PRODUCT.PQTY IS '��ǰ����';

COMMENT ON COLUMN PRODUCT.POINT IS '����Ʈ';

COMMENT ON COLUMN PRODUCT.PSPEC IS '����';

COMMENT ON COLUMN PRODUCT.PCONTENTS IS '��ǰ����';

COMMENT ON COLUMN PRODUCT.PCOMPANY IS '������';

COMMENT ON COLUMN PRODUCT.PINDATE IS '�����';

CREATE UNIQUE INDEX PK_PRODUCT
	ON PRODUCT (
		PNUM ASC
	);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT PK_PRODUCT
		PRIMARY KEY (
			PNUM
		);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT FK_DOWNCATEGORY_TO_PRODUCT
		FOREIGN KEY (
			DOWNCG_CODE,
			UPCG_CODE
		)
		REFERENCES DOWNCATEGORY (
			DOWNCG_CODE,
			UPCG_CODE
		);

ALTER TABLE PRODUCT
	ADD
		CONSTRAINT FK_UPCATEGORY_TO_PRODUCT
		FOREIGN KEY (
			UPCG_CODE
		)
		REFERENCES UPCATEGORY (
			UPCG_CODE
		);

create sequence product_seq nocache;
select * from product;
--���ϸ� ���� ����
alter table product modify pimage1 varchar2(200);
alter table product modify pimage2 varchar2(200);
alter table product modify pimage3 varchar2(200);

-- ���������� �̿��ؼ� ī�װ��̸��� ������
select p.*,
		(select upCg_name from upCategory where upCg_code=p.upCg_code) upCg_name,
		(select downCg_name from downCategory where downCg_code=p.downCg_code) downCg_name 
		from product p order by pnum desc;