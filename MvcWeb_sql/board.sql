drop table board;
-- 단순형 게시판 (파일첨부기능)
create table board(
	num number(8) primary key, --글번호
	userid varchar2(30) not null, --작성자 아이디
	subject varchar2(200), --제목
	content varchar2(2000), --글 내용
	wdate timestamp default systimestamp, --작성일
	filename varchar2(300), --첨부 파일명
	filesize number(8) -- 파일 크기
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
--로우넘으로 페이징 처리를 위해 서브쿼리를 사용해서 select함
--cpage(현재페이지)파라미터 값 받아서 DB에서 해당 cpage에 해당하는
--데이터많 끊어서 가져오자=> SQL문 변경
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