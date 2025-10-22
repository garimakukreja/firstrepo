{{
    config(
        materialized="incremental",
        unique_key="integration_id",
        incremental_strategy="merge",
    )
}}

SELECT *, batch_id as integration_id
from
    {{ source("ebs", "ap_batches_all") }}
    {{ incremental_filter_condition("last_update_date") }}
