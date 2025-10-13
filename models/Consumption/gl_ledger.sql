{{ config(materialized="incremental", unique_key=["gl_ledger_key"]) }}

select
  *,
  ledger_id as gl_ledger_key
from {{ source("redshift_src", "gl_ledgers") }}
