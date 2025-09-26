{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  id as integration_id
from {{ source("redshift_src", "iby_payment_methods_tl") }}
