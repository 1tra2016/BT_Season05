-- SELECT datname FROM pg_database;
--
-- SELECT current_database();
-- SELECT current_user;
-- SELECT current_schema();
create schema bt_season05_kha1;
set search_path to bt_season05_kha1;

create table products(
    product_id serial primary key,
    product_name varchar(50) not null,
    category varchar(50) not null
);
insert into products(product_name, category) values
    ('Laptop Dell','Electronics'),
    ('IPhone 15','Electronics'),
    ('Bàn học gỗ','Furniture'),
    ('Ghế xoay','Furniture');

create table orders(
    order_id serial primary key,
    product_id int references products(product_id),
    quantity int not null,
    total_price numeric(10,2)
);

CREATE SEQUENCE order_id_seq START 101;
ALTER TABLE orders ALTER COLUMN order_id SET DEFAULT nextval('order_id_seq');

insert into orders(product_id, quantity,total_price) values
    (1,2,2200),
    (2,3,3300),
    (3,5,2500),
    (4,4,1600),
    (1,1,1100);

select * from orders;

select p.category, sum(o.total_price) as "Total_sales",sum(o.quantity) as "total_quantity"
    from products p join orders o on p.product_id = o.product_id
    group by category;

select p.category, sum(o.total_price) as "Total_sales",sum(o.quantity) as "total_quantity"
    from products p join orders o on p.product_id = o.product_id
    group by category
    having sum(o.total_price) > 2000
    order by sum(o.total_price) desc;
