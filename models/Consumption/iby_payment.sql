{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  payment_id as integration_id
from {{ source("ebs", "iby_payments_all") }}
