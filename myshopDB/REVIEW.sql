drop table review;

CREATE TABLE REVIEW (
	NUM NUMBER(8) primary key, /* 글번호 */
	userid varchar2(30) references member(userid), /* 회원번호 */
    PNUM_FK number(8) references product(pnum), /* 상품번호 */
	CONTENT VARCHAR2(500) not null, /* 내용 */
	SCORE NUMBER(1) not null, /* 평가점수 */
	FILENAME VARCHAR2(100) default 'noimage.png', /* 업로드파일 */
	WDATE DATE default sysdate); /* 작성일 */
drop sequence review_seq;
create sequence review_seq nocache;
