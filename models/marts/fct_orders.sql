{{ config(materialized='table', distributed_by='order_id', orientation='column') }}
-- Задание 4. Факт заказов: одна строка — один заказ. Тестовые заказы в витрину не попадают.
-- Материализация — table (задана для папки marts в dbt_project.yml).
select
    order_id,
    customer_id,
    order_date,
    ordered_at,
    order_status,
    order_amount,
    paid_amount,
    refunded_amount,
    net_paid_amount,
    successful_payments_count,
    first_paid_at,
    is_confirmed,
    (select count(*) from {{ ref('stg_shop__order_items') }} as i
     where i.order_id = orders.order_id) as items_count
from {{ ref('int_orders_with_payments') }} as orders
where not is_test_order
