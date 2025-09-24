{{ config(
    materialized='table',
    dist='order_id', 
) }}


select
	*
from {{ ref('sales') }} 

