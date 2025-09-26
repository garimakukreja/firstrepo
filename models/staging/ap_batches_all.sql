{{ config(materialized="incremental", unique_key="batch_id") }}

select *
from {{ sources("redshift_src", "ap_batches_all") }}
