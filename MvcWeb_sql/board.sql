drop table board;
-- �ܼ��� �Խ��� (����÷�α��)
create table board(
	num number(8) primary key, --�۹�ȣ
	userid varchar2(30) not null, --�ۼ��� ���̵�
	subject varchar2(200), --����
	content varchar2(2000), --�� ����
	wdate timestamp default systimestamp, --�ۼ���
	filename varchar2(300), --÷�� ���ϸ�
	filesize number(8) -- ���� ũ��
);

drop sequence board_seq;

create sequence board_seq
start with 1
increment by 1
nocache;