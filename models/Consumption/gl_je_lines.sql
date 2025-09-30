{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  JE_LINE_ID as integration_id
from {{ source("redshift_src", "gl_je_lines") }}
