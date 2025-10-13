{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  invoice_id as integration_id
from {{ source("ebs", "ap_invoices_all") }}
