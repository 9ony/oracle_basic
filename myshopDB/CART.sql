drop table cart;

create table cart(
    cartNum number(8) primary key,
    idx_fk number(8) references member (idx) on delete cascade,
    pnum_fk number(8) references product (pnum) on delete cascade,
    oqty number(8) not null,
    indate date default sysdate,
    constraint cart_oqty_ck check (oqty > 0 and oqty < 51)
);

drop sequence cart_seq;

create sequence cart_seq nocache;

select * from cart;

--��ٱ��� ����Ʈ ���� (���δ�Ʈ�� ����)
select
		c.*,p.pname,pimage1,price,saleprice,point,(c.oqty*p.saleprice)
		totalPrice,(c.oqty*p.point) totalPoint
		from cart c
		join
		product p
		on c.pnum_fk = p.pnum and c.idx_fk='8';
commit;

--��ٱ��� View ����
create or replace view cartView
as
select
c.*,p.pname,pimage1,price,saleprice,point,(c.oqty*p.saleprice)
totalPrice,(c.oqty*p.point) totalPoint
from cart c
join
product p
on c.pnum_fk = p.pnum ;

select * from cartView;