{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  a as integration_id
from {{ source("ebs", "ce_payment_documents") }}
