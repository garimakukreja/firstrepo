{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  je_header_id as integration_id
from {{ source("redshift_src", "gl_je_headers") }}
