-- Независимый расчёт; EXISTS не размножает заказ при нескольких платежах.
with raw_revenue as (
    select coalesce(sum(o.total_amount), 0) as revenue
    from {{ source('shop', 'orders') }} as o
    where o.status = 'paid'
      and exists (
          select 1 from {{ source('shop', 'payments') }} as p
          where p.order_id = o.order_id
            and p.payment_status = 'success' and p.amount >= 0
      )
), mart_revenue as (
    select coalesce(sum(order_amount), 0) as revenue
    from {{ ref('fct_orders') }} where is_confirmed
)
select r.revenue as raw_revenue, m.revenue as mart_revenue
from raw_revenue r cross join mart_revenue m
where r.revenue <> m.revenue
