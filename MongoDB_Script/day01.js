db //local
//mydb 데이터베이스 생성
use mydb //switched to db mydb 없으면 mydb생성 잇으면 mydb접속
db //생성후 현재db mydb
//mydb에 collection을 생성해보자
db.createCollection("employees",{capped:true,size:10000})
//db.createCollection("테이블명",{} <<옵션)
//{} 옵션 capped:true 저장공간(size한도)이 차면 기존 공간을 재사용하겠다는 설정
db
show collections //생성한 컬렉션확인
show dbs //컬렉션을 만들기전에는 mydb가안뜸 만든후에 나옴

db.employees.find() //employees를 조회하는 문장
db.employees.isCapped() //Capped설정 여부 확인 --> true
db.employees.stats() //employees의 속성정보 출력

db.employees.renameCollection("emp") //employees 컬렉션 이름을 emp로 변경
show collections
db.emp.drop() //컬렉션 삭제
show collections //삭제되었음


// capped 옵션 확인----------------
//컬렉션 생성
db.createCollection("cappedCollection",{capped:true,size:10000})
//capped:true => 최초 제한된 크기로 생성된 공강에서만 데이터를 저장하는 설정
//false 주면 무제한
//size:10000 >>> 10000보다는 크고 가장 가까운 256배수로 max값이 설정 ==> 10240.0
show collections
db.cappedCollection.find()
db.cappedCollection.stats()

//document(row)를 maxsize초과하도록 반복문 이용해서 넣어보자
for (i=0;i<1000;i++){
    db.cappedCollection.insertOne({x:i})
}
db.cappedCollection.find() //647~999
db.cappedCollection.find().count() //353
//10240이 초과하면서 처음들어갔던데이터를 덮어쓰게된다.
//647이후부터 덮어쓰게된것
db.cappedCollection.isCapped()
//-------------------------------------------------

//mongodb CRUD-----------
/* [1] Create :
        - insertOne({}) : 한 개의 document 생성
        - insertMany([]) : 여러 개의 document 생성
        db.emp.insertOne({<-collection (table)
            id:'a001', <-------field-----+ (column)
            name : 'James',<---field-----+-document (record)
            dept : 'Sales' <---field-----+
        })
*/
use mydb
db.createCollection('member')
show collections

db.member.find()
db.getCollection('member').find() //db.member.find()와 동일
db.member.insertOne({
    name : '김민준',
    userid:'min',
    tel:'010-7878-8888',
    age:20
})
db.member.find()
/*
_id 필드가 자동으로 생성 document의 유일성을 보장하는 키
    전체 : 12bytes
          -4bytes : 현재 timestamp => 문서 생성 시점
          -3bytes : machine id
          -2bytes : mongodb 프로세스 id
          -3bytes : 일련변호
*/
//_id를 따로줘도됨
db.member.insertOne({
    _id : '1',
    name : '홍길동',
    userid:'hong',
    tel:'010-4545-4444',
    age:22
})
db.member.find()
//document를 bson으로 변환하여 몽고db에 저장
//_id : 자동으로 index가 생성된다. ==> 검색을 빠르게 할 수 있다. 중복X

db.member.insertMany([
    {name:'이민수',userid:'Lee',age:23},
    {name:'최민좌',userid:'Choi',tel:'011-9999-8888',age:25},
    {name:'유재석',userid:'You',tel:'011-5999-5888',age:231},
])

db.getCollection('member').find()

db.member.insertOne({name:'표진우',userid:'Pyo',passwd:'123',grade:'A'})

db.user.insertMany([
    {_id:1,name:'김철',userid:'kim1',passwd:'1111'},
    {_id:2,name:'최철',userid:'choi1',passwd:'2111'}
])

db.user.find()
db.user.insertMany([
    {_id:3,name:'김철',userid:'kim1',passwd:'1111'},
    {_id:2,name:'최철',userid:'choi1',passwd:'2111'},
    {_id:4,name:'김철',userid:'kim1',passwd:'1111'},
] , {ordered:false}) 
//3은 들어가고 2번에서 중복때문에 막혀서 2,4번은 안들어감 default ==> ordered:true
//ordered:false 주면 순서대로 입력하지않음
//_id가 중복되어도 그 이후의 데이터를 삽입한다.

/*
[실습1]---------------------------------------------------------------------
1. boardDB생성
2. board 컬렉션 생성
3. board 컬렉션에 name 필드값으로 "자유게시판"을 넣어본다
4. article 컬렉션을 만들어 document들을 삽입하되,
   bid필드에 3에서 만든 board컬렉션 자유게시판의 _id값이 참조되도록 처리해보자.

5. 똑 같은 방법으로 "공지사항게시판"을 만들고 그 안에 공지사항 글을 작성하자.
--------------------------------------------------------------------------
*/
use boardDB
db
db.board.drop()
db.article.drop()

freeboard_res=db.board.insertOne({name:'자유게시판'})
//freeboard_res에는 자유게시판 도큐먼트의 _id값이 담긴다

freeboard_id=freeboard_res.insertedId

db.article.insertMany([
   { bid:freeboard_id, title:'자유게시판 첫번째 글',content:'안녕하세요?',writer:'kim'},
   { bid:freeboard_id, title:'자유게시판 두번째 글',content:'반가워요',writer:'choi'},
   { bid:freeboard_id, title:'자유게시판 세번째 글',content:'Hello',writer:'lee'}
])

db.article.find()
//5. 똑 같은 방법으로 "공지사항게시판"을 만들고 그 안에 공지사항 글을 작성하자.
notice_res=db.board.insertOne({name:'공지사항 게시판'})
notice_id=notice_res.insertedId
db.notice.insertMany([
    {bid:notice_id,title:'오늘 모임 공지',content:'6시에 강남역에서 만나요',write:'admin'},
    {bid:notice_id,title:'스터디 공지',content:'오전 6시에 강남역에서 만나요',write:'admin'}
])
db.notice.find()
db.article.find()

/* R: read 조회
    - findOne() : 매칭되는 1 개의 document를 조회
    - find() : 매칭되는 document list 조회
    find({조건들},{필드들})
*/
use mydb
db.member.find({})
//select * from member
arr=db.member.find().toArray()
//모든 문서를 배열로 반환
arr[0]
arr[1]
db.member.find()
//member에서 name, tel만 조회하고 싶다면
db.member.find({},{name:true,tel:true,_id:false})
//select name, tel from member

db.member.find({},{name:1,tel:1,_id:0})
//위 문장과 동일함 true=>1로, false:0으로 호환가능

//select * from member where age=20
db.member.find({age:20},{})

//select name,userid,age from member where age=22
db.member.find({age:22},{name:1,userid:1,age:1})

//userid 가 'You'이고 age:21인 회원정보를 가져와 출력하세요
db.member.find({userid:'You', age:21})

//age가 20 이거나 userid가 'You'인 회원정보를 보여주세요
db.member.find({$or:[{age:20},{userid:'You'}]},{})
//select * from member where age=20 or userid='You'

db.member.find()

//논리연산
// $or : 배열 안 두 개 이상의 조건 중 하나라도 참인 경우를 반환
// $and : 배열 안 두 개 이상의 조건이 모두 참인 경우를 반환
// $nor  : $or의 반대. 배열안 두 개 이상의 조건이 모두 아닌 경우를 반환함

//<1> userid가 'Choi'인 회원의 name,userid, tel 만 가져오기
db.member.find({userid:'Choi'},{name:1,userid:1,tel:1})
//<2> age가 21세 이거나 userid가 'Lee'인 회원정보 가져오기
db.member.find({$or:[{age:21},{userid:'Lee'}]})
//<3> 이름이 이민수 이면서 나이가 23세인 회원정보 가져오기
db.member.find({name:'이민수',age:23})
db.member.find({$and:[{name:'이민수'},{age:23}]})

/*
[실습2]
1. employees Collection 생성 {capped:true, size:100000} Capped Collection, size는 100000 으로 생성
2. scott계정의 emp레코드를 mydb의 emp Document 데이터로 넣기 
  => insertOne()으로 3개 문서 삽입, 
     insertMany로 나머지 문서 삽입해보기
*/