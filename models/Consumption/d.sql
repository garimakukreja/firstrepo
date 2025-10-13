{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  i as integration_id
from {{ source("ebs", "ap_invoice_distributions_all") }}
