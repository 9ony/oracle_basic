drop table spring_board;

create table spring_board(
    num number(8) primary key, --글번호
    name varchar2(30) not null, --작성자
    passwd varchar2(20) not null, --글비밀번호
    subject varchar2(200) not null, --글제목
    content varchar2(2000), --글내용
    wdate date default sysdate,  --작성일
    readnum number(8) default 0, --조회수
    filename varchar2(500), --첨부파일명 [첨부파일명앞에 랜덤값첨부 ex) random값_a.txx] ==> 물리적 파일명
    originFilename varchar2(500), --원본파일명 [a.txt] ==> 논리적 파일명
    filesize number(8),--첨부파일크기
    refer number(8),--글 그룹번호[답변형 게시판일때 필요한 컬럼]
    lev number(8), --답변 레벨 [답변형 게시판일때 필요한 컬럼]
    sunbun number --같은 글 그룹 내에 순서 정렬시 필요한 컬럼 [답변형 게시판일때 필요한 컬럼]
);
drop sequence spring_board_seq;

create sequence spring_board_seq
start with 1
increment by 1
nocache;

select * from spring_board order by num desc;
update spring_board set subject='<script>alert("제목에 스크립트");</script>' where num=4;
commit;

select * from spring_board order by refer desc,sunbun asc;

select * from (
select rownum rn, a.* from
 (select * from spring_board order by refer desc,sunbun asc) a
 )
 where rn between 1 and 5;

--페이징처리 방법2 
 select * from (
 select row_number() over(order by refer desc, sunbun asc) rn, spring_board.* from spring_board
)
 where rn between 1 and 5;
 
-- --부등호로
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