{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  cust_trx_type_id as integration_id
from {{ source("redshift_src", "ra_cust_trx_types_all") }}
