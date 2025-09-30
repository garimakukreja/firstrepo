{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  JE_HEADER_ID as integration_id
from {{ source("redshift_src", "gl_je_headers") }}
