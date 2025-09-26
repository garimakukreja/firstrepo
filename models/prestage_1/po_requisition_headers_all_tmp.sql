{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  requisition_header_id as integration_id
from {{ source("redshift_src", "po_requisition_headers_all_tmp") }}
