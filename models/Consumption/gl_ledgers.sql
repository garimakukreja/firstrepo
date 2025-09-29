{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  ledger_id as integration_id
from {{ source("redshift_src", "gl_ledgers") }}
