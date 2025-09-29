{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  salesrep_id as integration_id
from {{ source("redshift_src", "ra_salesreps_all") }}
