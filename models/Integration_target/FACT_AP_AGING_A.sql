{{ config(materialized="table", unique_key="integration_id") }}

{#
{% do mkTruncate_stage_table() %}
{% set src_tables = [
    'fact_ap_aging_a_stg',
    'dim_supplier_stg',
    'dim_gl_ledgers_stg',
    'dim_legal_entity_stg',
    'dim_gl_account_stg',
    'dim_business_unit_stg',
    'dim_org_stg'
] %}
{% set last_update_date = mkget_last_update_date(src_tables) %}
#}

with
    fact_ap_aging_a_stg as (
        select * from {{ ref("fact_ap_aging_a_stg") }}
    ),
    dim_supplier_stg as (
        select * from {{ ref("dim_supplier_stg") }}
    ),
    dim_gl_ledgers_stg as (
        select * from {{ ref("dim_gl_ledgers_stg") }}
    ),
    dim_legal_entity_stg as (
        select * from {{ ref("dim_legal_entity_stg") }}
    ),
    dim_gl_account_stg as (
        select * from {{ ref("dim_gl_account_stg") }}
    ),
    dim_business_unit_stg as (
        select * from {{ ref("dim_business_unit_stg") }}
    ),
    dim_org_stg as (
        select * from {{ ref("dim_org_stg") }}
    ),

fact_ap_aging_a as (
    select
        cast(coalesce(stg.snapshot_dt_id, 0) as numeric) as snapshot_dt_key,

        -- 🔹 Safe coalesce casting for integration keys
        coalesce(cast(supplier_d.integration_id as varchar), '0') as supplier_key,
        coalesce(cast(gl_ledgers_d.integration_id as varchar), '0') as ledger_key,
        coalesce(cast(legal_entity_d.integration_id as varchar), '0') as legal_entity_key,
        coalesce(cast(business_unit_d.integration_id as varchar), '0') as bu_key,
        coalesce(cast(gl_account_d.integration_id as varchar), '0') as glcc_expense_key,
        coalesce(cast(org_d.integration_id as varchar), '0') as org_key,

        cast(coalesce(stg.invoice_dt_id, 0) as numeric) as invoice_dt_key,
        cast(coalesce(stg.payment_due_dt_id, 0) as numeric) as payment_due_dt_key,
        cast(coalesce(stg.accounting_dt_id, 0) as numeric) as accounting_dt_key,

        gl_ledgers_d.ledger_name,
        business_unit_d.bu_id as bu_num,
        business_unit_d.bu_name as bu_name,
        legal_entity_d.legal_enity_num as legal_entity_num,
        legal_entity_d.legal_entity_name as legal_entity_name,
        supplier_d.supplier_num as supplier_num,
        supplier_d.supplier_name as supplier_name,
        supplier_d.supplier_site_code as supplier_site_name,
        org_d.org_num as org_num,
        org_d.org_name as org_name,

        stg.invoice_id,
        stg.invoice_num,
        stg.description,
        stg.inv_curr_code,
        stg.led_curr_code,
        stg.payment_due_dt,
        stg.invoice_dt,
        stg.accounting_dt,
        stg.payment_status_flag,
        stg.over_due_flag,
        stg.active_flag,
        stg.approval_status,
        stg.source,
        stg.payment_type,
        stg.aging_bucket,
        stg.open_bucket,
        stg.payment_terms,
        stg.payment_method_code,
        stg.past_due_days,
        stg.invoice_amt,
        stg.invoice_due_amt,
        stg.inv_ledger_amt,
        stg.inv_paid_amt,
        stg.invoice_amt_usd,
        stg.invoice_due_amt_usd,
        stg.inv_ledger_amt_usd,
        stg.conv_rate_to_usd,
        stg.conv_rate_type,
        stg.inv_due_ledger_amt,
        stg.creation_dt,
        stg.last_update_dt,
        stg.created_by,
        stg.last_updated_by,
        stg.integration_id,
        stg.datasource_num_id,
        stg.delete_flag,
        stg.w_insert_dt,
        stg.w_update_dt

    from fact_ap_aging_a_stg stg
    left join dim_supplier_stg supplier_d
        on stg.supplier_id = supplier_d.integration_id
        and stg.datasource_num_id = supplier_d.datasource_num_id
    left join dim_gl_ledgers_stg gl_ledgers_d
        on cast(stg.ledger_id as varchar) = cast(gl_ledgers_d.integration_id as varchar)
        and stg.datasource_num_id = gl_ledgers_d.datasource_num_id
    left join dim_legal_entity_stg legal_entity_d
        on cast(stg.legal_entity_id as varchar) = cast(legal_entity_d.integration_id as varchar)
        and stg.datasource_num_id = legal_entity_d.datasource_num_id
    left join dim_gl_account_stg gl_account_d
        on cast(stg.glcc_id as varchar) = cast(gl_account_d.integration_id as varchar)
        and stg.datasource_num_id = gl_account_d.datasource_num_id
    left join dim_business_unit_stg business_unit_d
        on cast(stg.bu_id as varchar) = cast(business_unit_d.integration_id as varchar)
        and stg.datasource_num_id = business_unit_d.datasource_num_id
    left join dim_org_stg org_d
        on cast(stg.org_id as varchar) = cast(org_d.integration_id as varchar)
        and stg.datasource_num_id = org_d.datasource_num_id
    where 1=1
)

select *
from fact_ap_aging_a
