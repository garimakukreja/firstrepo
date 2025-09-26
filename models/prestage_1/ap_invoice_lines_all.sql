{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  invoice_line_id as integration_id
from {{ source("redshift_src", "ap_invoice_lines_all") }}
