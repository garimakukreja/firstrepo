{{ config(
    materialized='table',
    dist='order_id', 
) }}


select
	*
from {{ source('Redshift', 'sales') }}

