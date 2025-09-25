select
    o.order_sk,
    o.order_id,
    o.order_date,
    c.customer_sk,
    c.customer_id,
    p.product_sk,
    p.product_id
from {{ ref('stg_orders') }} o
left join {{ ref('stg_customers') }} c on o.customer_id = c.customer_id
left join {{ ref('stg_products') }} p on p.product_id = p.product_id
