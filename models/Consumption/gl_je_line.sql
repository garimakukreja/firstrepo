{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  je_line_id as integration_id
from {{ source("ebs", "gl_je_lines") }}
