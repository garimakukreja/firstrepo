{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  distribution_line_number as integration_id
from {{ source("ebs", "ap_invoice_distributions_all") }}
