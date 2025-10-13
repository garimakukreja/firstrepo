{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  payment_method_code as integration_id
from {{ source("ebs", "iby_payment_methods_tl") }}
