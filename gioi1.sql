-- SELECT datname FROM pg_database;
--
-- SELECT current_database();
-- SELECT current_user;
-- SELECT current_schema();
create schema bt_season05_gioi1;
set search_path to bt_season05_gioi1;

create table customers(
                        customer_id serial primary key,
                        customer_name varchar(50) not null,
                        city varchar(50) not null
);
insert into customers(customer_name, city) values
                                                 ('Nguyễn Văn A','Hà Nội'),
                                                 ('Trần Thị B','Đà Nẵng'),
                                                 ('Lê Văn C','Hồ Chí Minh'),
                                                 ('Phạm Thị D','Hà Nội');

create table orders(
                       order_id serial primary key,
                       customer_id int references customers(customer_id),
                       order_date date not null,
                       total_price numeric(10,2)
);

CREATE SEQUENCE order_id_seq START 101;
ALTER TABLE orders ALTER COLUMN order_id SET DEFAULT nextval('order_id_seq');

insert into orders(customer_id, order_date,total_price) values
                                                         (1,'2024-12-20',3000),
                                                         (2,'2025-01-05',1500),
                                                         (1,'2025-02-10',2500),
                                                         (3,'2025-02-15',4000),
                                                         (4,'2025-03-01',800);

select * from orders;

create table order_items (
                             item_id serial primary key,
                             order_id int references orders(order_id),
                             product_id int,
                             quantity int not null,
                             price numeric(10,2) not null
);
insert into order_items (order_id, product_id, quantity, price)
values
    (101, 1, 2, 1500),
    (102, 2, 1, 1500),
    (103, 3, 5, 500),
    (104, 2, 4, 1000);

select c.customer_id, sum(o.total_price) as "total_revenue", count(*) as order_count
from orders o join customers c on o.customer_id = c.customer_id
group by c.customer_id
having sum(o.total_price)> 2000;

select customer_id, total_revenue
from (
    select c.customer_id as customer_id , sum(o.total_price) as "total_revenue"
    from orders o join customers c on o.customer_id = c.customer_id
    group by c.customer_id
    )
where total_revenue > (
    select avg(total_revenue) as "avg_total_revenue"
    from (
             select sum(o.total_price) as "total_revenue"
             from orders o join customers c on o.customer_id = c.customer_id
             group by c.customer_id
         )
    )
;

select city, sum(total_revenue)
from
    (select c.city, c.customer_id, sum(o.total_price) as "total_revenue"
    from orders o join customers c on o.customer_id = c.customer_id
    group by c.customer_id)
group by city;

select o.customer_id, c.city, count(*) as order_count, sum(o.total_price) as "total_revenue"
from orders o
    join customers c on o.customer_id = c.customer_id
    join order_items oi on o.order_id = oi.order_id
group by o.customer_id, c.city;
-- ủa, trong orders có order_id == 105 nhưng trong order_items không có 105 :v làm cho kết quả chỉ có 3 hàng
-- Nếu order_id == 105 tồn tại trong order_items thì sẽ có 4 hàng