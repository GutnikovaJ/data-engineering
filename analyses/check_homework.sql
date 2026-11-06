-- Запуск через psql описан в README. Все запросы только читают данные.
select count(*) as orders_count,
       count(*) filter (where is_confirmed) as confirmed_orders,
       sum(order_amount) filter (where is_confirmed) as confirmed_revenue,
       count(*) filter (where order_status = 'test') as test_orders
from analytics_marts.fct_orders;
select count(*) as order_items_count,
       sum(line_amount) filter (where is_confirmed) as confirmed_revenue
from analytics_marts.fct_order_items;
select count(*) as customers_count, count(*) filter (where is_buyer) as buyers_count
from analytics_marts.dim_customers;
select customer_id, first_confirmed_order_id, first_confirmed_at,
       confirmed_orders_count, confirmed_revenue, is_buyer
from analytics_marts.dim_customers where customer_id in (1, 40) order by customer_id;
select count(*) as products_count from analytics_marts.dim_products;
select product_id, root_category_name, parent_category_name, category_name
from analytics_marts.dim_products where product_id in (11, 12) order by product_id;
select count(*) as days_count, min(date_day), max(date_day) from analytics_marts.dim_dates;
select p.root_category_name, sum(i.line_amount) as confirmed_revenue
from analytics_marts.fct_order_items i
join analytics_marts.dim_products p on i.product_id = p.product_id
where i.is_confirmed group by p.root_category_name order by p.root_category_name;
select * from analytics_dbt_test__audit.assert_confirmed_orders_not_overpaid;
select c.relname, pg_get_table_distributedby(c.oid) as distribution, am.amname as storage
from pg_class c join pg_namespace n on n.oid = c.relnamespace
left join pg_am am on am.oid = c.relam
where n.nspname = 'analytics_marts' and c.relkind = 'r' order by c.relname;
