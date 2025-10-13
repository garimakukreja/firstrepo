{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  salesrep_id as integration_id
from {{ source("ebs", "ra_salesreps_all") }}
