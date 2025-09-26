{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  ae_header_id, ae_line_num as integration_id
from {{ source("redshift_src", "xla_ae_lines") }}
