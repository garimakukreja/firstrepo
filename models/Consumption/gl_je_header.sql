{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  je_header_id as integration_id
from {{ source("ebs", "gl_je_headers") }}
