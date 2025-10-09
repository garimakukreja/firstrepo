{{ config(materialized="incremental", unique_key=["hz_customer_account_key"]) }}

select
  *,
  cust_account_id as hz_customer_account_key
from {{ source("redshift_src", "hz_cust_accounts") }}
