{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  n as integration_id
from {{ source("ebs", "ap_invoice_lines_all") }}
