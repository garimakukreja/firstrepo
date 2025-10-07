{{ 
    config(
        materialized = "incremental",
        unique_key = "integration_id",
        post_hook = "{{ mkInsert_unspecified_row(this.name) }}"
    ) 
}}

with
    ct_supplier_d_stg as (
        {% if is_incremental() %}
            select stg.*, coalesce(tgt.w_insert_dt, current_timestamp()) as w_insert_dt
            from {{ ref("CT_SUPPLIER_D_STG") }} stg
            left outer join {{ this }} tgt
                on stg.integration_id = tgt.integration_id
        {% else %}
            select stg.*, current_timestamp() as w_insert_dt
            from {{ ref("CT_SUPPLIER_D_STG") }} stg
        {% endif %}
    ),

    ct_supplier_d as (
        select
            {{ dbt_utils.surrogate_key(['integration_id']) }} as bu_key,
            *,
            current_timestamp() as w_update_dt
        from ct_supplier_d_stg
    )

select *
from ct_supplier_d;