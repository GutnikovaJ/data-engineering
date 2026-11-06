{{ config(materialized='view') }}
-- Идём от корней вниз: число уровней не ограничено тремя.
with recursive category_tree as (
    select category_id, parent_category_id, category_name,
           null::text as parent_category_name,
           category_name as root_category_name
    from {{ ref('stg_shop__product_categories') }}
    where parent_category_id is null

    union all

    select c.category_id, c.parent_category_id, c.category_name,
           p.category_name as parent_category_name, p.root_category_name
    from {{ ref('stg_shop__product_categories') }} as c
    join category_tree as p on c.parent_category_id = p.category_id
)
select * from category_tree
