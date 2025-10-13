{{ config(materialized="incremental", unique_key=["hz_customer_account_site_key"]) }}

select
  *,
  cust_acct_site_id as hz_customer_account_site_key
from {{ source("redshift_src", "hz_cust_acct_sites_all") }}
