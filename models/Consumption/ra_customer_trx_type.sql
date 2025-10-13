{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  cust_trx_type_id as integration_id
from {{ source("ebs", "ra_cust_trx_types_all") }}
