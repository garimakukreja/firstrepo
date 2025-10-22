{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  po_line_id as integration_id
from {{ source("ebs", "po_lines_all") }}
