//day05.js
db.orders.drop()
db.items.drop()
use mydb
db.createCollection('orders')

db.orders.insertMany([
{
      cust_id: "abc123",
      ord_date: ISODate("2012-01-02T17:04:11.102Z"),
      status: 'A',
      price: 100,
      items: [ { sku: "xxx", qty: 25, price: 1 },
               { sku: "yyy", qty: 25, price: 1 } ]
    },
    {
      cust_id: "abc123",
      ord_date: ISODate("2012-01-02T17:04:11.102Z"),
      status: 'A',
      price: 500,
      items: [ { sku: "xxx", qty: 25, price: 1 },
               { sku: "yyy", qty: 25, price: 1 } ]
    },
    {
      cust_id: "abc123",
      ord_date: ISODate("2012-01-02T17:04:11.102Z"),
      status: 'B',
      price: 130,
      items: [ { sku: "jkl", qty: 35, price: 2 },
               { sku: "abv", qty: 35, price: 1 } ]
    },
    {
      cust_id: "abc123",
      ord_date: ISODate("2012-01-02T17:04:11.102Z"),
      status: 'B',
      price: 230,
      items: [ { sku: "jkl", qty: 25, price: 2 },
               { sku: "abv", qty: 25, price: 1 } ]
    },
    {
      cust_id: "abc123",
      ord_date: ISODate("2012-01-02T17:04:11.102Z"),
      status: 'A',
      price: 130,
      items: [ { sku: "xxx", qty: 15, price: 1 },
               { sku: "yyy", qty: 15, price: 1 } ]
    },
    {
      cust_id: "abc456",
      ord_date: ISODate("2012-02-02T17:04:11.102Z"),
      status: 'C',
      price: 70,
      items: [ { sku: "jkl", qty: 45, price: 2 },
               { sku: "abv", qty: 45, price: 3 } ]
    },
    {
      cust_id: "abc456",
      ord_date: ISODate("2012-02-02T17:04:11.102Z"),
      status: 'A',
      price: 150,
      items: [ { sku: "xxx", qty: 35, price: 4 },
               { sku: "yyy", qty: 35, price: 5 } ]
    },
    {
      cust_id: "abc456",
      ord_date: ISODate("2012-02-02T17:04:11.102Z"),
      status: 'B',
      price: 20,
      items: [ { sku: "jkl", qty: 45, price: 2 },
               { sku: "abv", qty: 45, price: 1 } ]
    },
    {
      cust_id: "abc456",
      ord_date: ISODate("2012-02-02T17:04:11.102Z"),
      status: 'B',
      price: 120,
      items: [ { sku: "jkl", qty: 45, price: 2 },
               { sku: "abv", qty: 45, price: 1 } ]
    },
    {
      cust_id: "abc780",
      ord_date: ISODate("2012-02-02T17:04:11.102Z"),
      status: 'B',
      price: 260,
      items: [ { sku: "jkl", qty: 50, price: 2 },
               { sku: "abv", qty: 35, price: 1 } ]
    }
])

db.orders.find()
    
//orders에서 고객id와 주문일 주문가격을 가져와 출력하세요
db.orders.aggregate([{$project:{cust_id:1, ord_date:1,price:1,_id:0}}])

//orders 총 주문건수 출력
//select count(*) cnt from orders
db.orders.aggregate([{
    $group:{
        _id:null,
        cnt:{$sum:1}
    }
}])
// $sum:1 = document한당 1을 더함 만약 2가들어가면 20이나옴
//고객별로 주문 건수를 출력하세요
db.orders.aggregate([{
    $group:{
        _id:"$cust_id",
        cnt:{$sum:1}
    }
}])

//고객별로 구매가격 총액을 가져와 보여주세요
//select sum(price) as totalPrice from orders group by cust_id;
db.orders.aggregate([{
    $group:{
        _id:"$cust_id",
        totalPrice:{$sum:"$price"}
    }
}])
//고객별로 구매가격 총액을 가져와 보여주세요 + 오름차순정렬
//select sum(price) as totalPrice from orders group by cust_id order by totalPrice;
db.orders.aggregate([{
    $group:{
        _id:"$cust_id",
        totalPrice:{$sum:"$price"}
    }
},{$sort:{totalPrice:1}}])
//{$sort:{필드명:1}} : 1은 오름차순정렬 -1 내림차순

//[1] 고객별 최소 주문가격(price)과 최대 주문가격을 구해 출력하세요
db.orders.aggregate([{
    $group:{
        _id:"$cust_id",
        maxPrice:{$max:"$price"},
        minPrice:{$min:"$price"}
    }
}])
//[2] 고객별 평균 주문가격을 보여주세요
db.orders.aggregate([{
    $group:{
        _id:"$cust_id",
        avgPrice:{$avg:"$price"}
    }
}])
db.orders.find()
//[3] 고객의 주문날짜별 구매총액을 보여주세요
db.orders.aggregate([{
    $group:{
        _id:{
            cust_id:"$cust_id",
            date:{$dateToString:{format:"%Y-%m-%d",date:"$ord_date"}}
            },
        sumPrice:{$sum:"$price"}
        }
}])

//[4] 고객별 주문건수가 1개를 초과하는 주문데이터를 보여주세요
//select cust_id,count(*) from orders group by cust_id
//having count(*) > 1
db.orders.aggregate([{
    $group:{
        _id:"$cust_id",
        count:{$sum:1}
        }},{$match:{count:{$gt:1}}
}])
//[5]  status별로 묶어 주문건수는 2개이상인 데이터를 가져와 보여주세요
//having count(*) > 1
//having 절은 $match이용 
db.orders.aggregate([{
    $group:{_id:"$cust_id",
            count:{$sum:1}}
},{$match:{count:{$gte:2}}}])

//[6] status별 주문총액을 가져와 출력하세요
db.orders.aggregate([{
    $group:{_id:"$status",
            sumPrice:{$sum:"$price"}}
}])
//[7] status가 'A'인 주문을 대상으로 고객별 주문 총액을 출력하세요
//select cust_id, sum(price) sumPrice from orders
//where status='A' group by cust_id
//where 절일땐 match가 앞으로 온다
db.orders.aggregate([{
    $match:{status:'A'}},{
    $group:{_id:"$cust_id",
            sumPrice:{$sum:"$price"}}
}])
/*[8]
    select cust_id, ord_date, sum(price) as total from orders where status='B'
     group by cust_id, ord_date having total > 250*/
db.orders.aggregate([{
    $match:{status:'B'}},{
            $group:{
            _id:{cust_id:"$cust_id",
            sumPrice:{$sum:"$price"},
            ord_date:{$dateToString:{format:"%Y-%m-%d",date:"$ord_date"}}},
            total:{$sum:"$price"}}},
            {$match:{total:{$gt:250}}
}])
//[9]고객별 주문상품의 총수량을 출력하세요
db.orders.aggregate([
    {$unwind:"$items"},
    {$group:{_id:"$cust_id", qty:{$sum:"$items.qty"}}}])

db.createCollection('items')
show collections

db.items.insertMany([
    { "_id" : 1, "item" : "abc", "price" : 10, "quantity" : 2, "date" : ISODate("2014-03-01T08:00:00Z") },
    { "_id" : 2, "item" : "jkl", "price" : 20, "quantity" : 1, "date" : ISODate("2014-03-01T09:00:00Z") },
    { "_id" : 3, "item" : "xyz", "price" : 5, "quantity" : 10, "date" : ISODate("2014-03-15T09:00:00Z") },
    { "_id" : 4, "item" : "xyz", "price" : 5, "quantity" : 20, "date" : ISODate("2014-04-04T11:21:39.736Z") },
    { "_id" : 5, "item" : "abc", "price" : 10, "quantity" : 10, "date" : ISODate("2014-04-04T21:23:13.331Z") }
])

db.items.find()
//{$multiply:["$price","quantity"]} ==> price * quantity

//[10] item별 총주문금액을 구해 출력하세요
db.items.aggregate([{
    $group:{_id:"$item",
            totalPrice:{$sum:{$multiply:["$price","$quantity"]}}
    }}])
//[11] 일자별 총주문금액과, 평균수량, 총주문건수를 구해 출력하세요
db.items.aggregate([{
    $group:{_id:{date:{$dateToString:{format:"%Y-%m-%d",date:"$date"}}},
            totalPrice:{$sum:{$multiply:["$price","$quantity"]}},
            avgqty:{$avg:"$quantity"},
            ordercount:{$sum:1}
    }
}])


db.items.aggregate([{
    $group:{_id:{year:{$year:"$date"},month:{$month:"$date"},day:{$dayOfMonth:"$date"}},
            totalPrice:{$sum:{$multiply:["$price","$quantity"]}},
            avgqty:{$avg:"$quantity"},
            ordercount:{$sum:1}
    }
}])
db.posts.find() //자바에서 collection 생성후 데이터 삽입 됬는지 확인