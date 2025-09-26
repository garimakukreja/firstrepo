{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  payment_hist_dist_id as integration_id
from {{ source("redshift_src", "ap_payment_hist_dists_tmp") }}
