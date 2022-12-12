drop table spring_board;

create table spring_board(
    num number(8) primary key, --�۹�ȣ
    name varchar2(30) not null, --�ۼ���
    passwd varchar2(20) not null, --�ۺ�й�ȣ
    subject varchar2(200) not null, --������
    content varchar2(2000), --�۳���
    wdate date default sysdate,  --�ۼ���
    readnum number(8) default 0, --��ȸ��
    filename varchar2(500), --÷�����ϸ� [÷�����ϸ�տ� ������÷�� ex) random��_a.txx] ==> ������ ���ϸ�
    originFilename varchar2(500), --�������ϸ� [a.txt] ==> ���� ���ϸ�
    filesize number(8),--÷������ũ��
    refer number(8),--�� �׷��ȣ[�亯�� �Խ����϶� �ʿ��� �÷�]
    lev number(8), --�亯 ���� [�亯�� �Խ����϶� �ʿ��� �÷�]
    sunbun number --���� �� �׷� ���� ���� ���Ľ� �ʿ��� �÷� [�亯�� �Խ����϶� �ʿ��� �÷�]
);
drop sequence spring_board_seq;

create sequence spring_board_seq
start with 1
increment by 1
nocache;

select * from spring_board order by num desc;
update spring_board set subject='<script>alert("���� ��ũ��Ʈ");</script>' where num=4;
commit;

select * from spring_board order by refer desc,sunbun asc;

select * from (
select rownum rn, a.* from
 (select * from spring_board order by refer desc,sunbun asc) a
 )
 where rn between 1 and 5;

--����¡ó�� ���2 
 select * from (
 select row_number() over(order by refer desc, sunbun asc) rn, spring_board.* from spring_board
)
 where rn between 1 and 5;
 
-- --�ε�ȣ��
-- where rn >0 and rn<6;
-- 
-- cpage    pageSize  start  end
-- 1          5        0      6
-- 2          5        5      11
-- 3          5        10      16
-- 4          5        15      21
-- 
-- start = (cpage-1)*pageSize;
-- end = start+(pageSize+1);