{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  requisition_line_id as integration_id
from {{ source("redshift_src", "po_requisition_lines_all_tmp") }}
