{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  po_header_id as integration_id
from {{ source("redshift_src", "po_headers_all_tmp") }}
