{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  o as integration_id
from {{ source("ebs", "po_headers_all") }}
