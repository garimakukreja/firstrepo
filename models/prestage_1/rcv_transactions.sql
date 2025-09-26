{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  transaction_id as integration_id
from {{ source("redshift_src", "rcv_transactions") }}
