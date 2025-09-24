{{ config(
    materialized='table',
    dist='order_id', 
) }}


select * FROM {{ source('public', 'sales') }}
