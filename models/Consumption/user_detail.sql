{{ config(materialized="incremental", unique_key=["user_detail_key"]) }}

select
  *,
  user_id as user_detail_key
from {{ source("redshift_src", "fnd_user") }}
