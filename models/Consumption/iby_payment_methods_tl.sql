{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  payment_method_code as integration_id
from {{ source("redshift_src", "iby_payment_methods_tl") }}
