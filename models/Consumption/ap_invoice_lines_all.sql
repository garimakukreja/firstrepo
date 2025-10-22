{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  INVOICE_ID||'~'||LINE_NUMBER as integration_id
from {{ source("ebs", "ap_invoice_lines_all") }}
