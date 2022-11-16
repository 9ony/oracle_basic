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


select * from board order by num desc;
select * from board;
commit;

select board_seq.nextval from dual;


select * from (
    select A.*,rownum rn from 
        (select board.* from board order by num desc) A
)where rn between 1 and 5;
--�ο������ ����¡ ó���� ���� ���������� ����ؼ� select��
--cpage(����������)�Ķ���� �� �޾Ƽ� DB���� �ش� cpage�� �ش��ϴ�
--�����͸� ��� ��������=> SQL�� ����
--
--select * from(
--select a.*, rownum rn from
-- (select * from board order by num desc) a
-- ) where rn between ${start} and ${end};
-- 
-- cpage   pageSize     start         end
-- 1          5            1             5
-- 2          5            6             10
-- 3          5            11            15
-- 4          5            16            20
-- ...
-- end= cpage * pageSize;
-- start = end - (pageSize-1)