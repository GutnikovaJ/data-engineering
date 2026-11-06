{{ config(materialized='table', distributed_replicated=true) }}
-- date_spine не включает end_date, поэтому прибавляем один день.
with calendar as (
    {{ dbt_utils.date_spine(
        datepart='day',
        start_date="(select min(order_date) from " ~ ref('stg_shop__orders') ~ ")",
        end_date="(select max(order_date) + interval '1 day' from " ~ ref('stg_shop__orders') ~ ")"
    ) }}
)
select date_day::date as date_day,
       extract(year from date_day)::integer as year,
       extract(quarter from date_day)::integer as quarter,
       extract(month from date_day)::integer as month,
       extract(isodow from date_day)::integer as day_of_week,
       extract(isodow from date_day) in (6, 7) as is_weekend
from calendar
