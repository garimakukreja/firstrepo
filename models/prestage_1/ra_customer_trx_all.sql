{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  customer_trx_id as integration_id
from {{ source("redshift_src", "ra_customer_trx_all") }}
