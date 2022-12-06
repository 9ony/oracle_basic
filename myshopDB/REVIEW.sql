drop table review;

CREATE TABLE REVIEW (
	NUM NUMBER(8) primary key, /* �۹�ȣ */
	userid varchar2(30) references member(userid), /* ȸ����ȣ */
    PNUM_FK number(8) references product(pnum), /* ��ǰ��ȣ */
	CONTENT VARCHAR2(500) not null, /* ���� */
	SCORE NUMBER(1) not null, /* ������ */
	FILENAME VARCHAR2(100) default 'noimage.png', /* ���ε����� */
	WDATE DATE default sysdate); /* �ۼ��� */
drop sequence review_seq;
create sequence review_seq nocache;
