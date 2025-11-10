-- SELECT datname FROM pg_database;
--
-- SELECT current_database();
-- SELECT current_user;
-- SELECT current_schema();
create schema bt_season05_gioi2;
set search_path to bt_season05_gioi2;

create table customers (
    customer_id serial primary key,
    customer_name varchar(100),
    city varchar(50)
);

create table orders (
    order_id serial primary key,
    customer_id int references customers(customer_id),
    order_date date,
    total_amount numeric(10,2)
);

create table order_items (
    item_id serial primary key,
    order_id int references orders(order_id),
    product_name varchar(100),
    quantity int,
    price numeric(10,2)
);

-- Điền giá trị để kiểm thử code--
insert into customers (customer_id, customer_name, city) values
                                                             (1, 'Nguyễn Văn A', 'Hà Nội'),
                                                             (2, 'Trần Thị B', 'Đà Nẵng'),
                                                             (3, 'Lê Văn C', 'Hồ Chí Minh'),
                                                             (4, 'Phạm Thị D', 'Hà Nội');

insert into orders (order_id, customer_id, order_date, total_amount) values
                                                                         (101, 1, '2024-12-20', 3000),
                                                                         (102, 2, '2025-01-05', 1500),
                                                                         (103, 1, '2025-02-10', 2500),
                                                                         (104, 3, '2025-02-15', 4000),
                                                                         (105, 4, '2025-03-01', 800);
insert into order_items (item_id, order_id, product_name, quantity, price) values
                                                                             (1, 101, 'Laptop Dell', 2, 1500),
                                                                             (2, 102, 'IPhone 15', 1, 1500),
                                                                             (3, 103, 'Bàn học gỗ', 5, 500),
                                                                             (4, 104, 'IPhone 15', 4, 1000);
insert into order_items (item_id, order_id, product_name, quantity, price) values
    (5, 105, 'Ghế xoay', 1, 800);

-- 1
select
    c.customer_name as "tên khách",
    o.order_date as "ngày đặt hàng",
    o.total_amount as "tổng tiền"
from orders o join customers c on o.customer_id = c.customer_id;

-- 2
select
    sum(o.total_amount) as "Tổng danh thu",
    avg(o.total_amount) as "Trung bình giá trị đơn hàng",
    max(o.total_amount) as "Đơn hàng lớn nhất",
    min(o.total_amount) as "Đơn hàng nhỏ nhất",
    count(order_id) as "Số lượng đơn hàng"
from orders o join customers c on o.customer_id = c.customer_id;

--3
select c.city as "Thành phố",sum(o.total_amount) as "Tổng doanh thu"
     from orders o join customers c on o.customer_id = c.customer_id
     group by c.city
     having sum(o.total_amount) > 10000;

--4
select o.order_id, c.customer_name, o.order_date, oi.quantity, oi.price
from orders o left join order_items oi on oi.order_id = o.order_id join customers c on o.customer_id = c.customer_id;

--5
select c.customer_name as "Tên khách hàng", sum(o.total_amount) as "Có tổng doanh thu cao nhất là"
from orders o join customers c on o.customer_id = c.customer_id
group by o.customer_id,c.customer_name
order by sum(o.total_amount) desc
limit(1);

--6
select city
from customers
union all
select c.city
from orders o full outer join customers c on o.customer_id = c.customer_id;

select city
from customers
intersect
select c.city
from orders o join customers c on o.customer_id = c.customer_id;