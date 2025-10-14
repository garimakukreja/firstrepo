{{ config(materialized="table", unique_key="integration_id") }}

       {# {% do mkTruncate_stage_table() %}

        {% set src_tables = ['fact_ap_holds_f_stg', 'dim_supplier_stg', 'dim_business_unit_stg', 'dim_gl_ledgers_stg', 'dim_gl_account_stg', 'dim_product_stg', 'dim_org_stg', 'dim_legal_entity_stg', 'dim_gl_daily_rates_stg'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}
        #}
        with
            fact_ap_holds_f_stg as (
    select * from {{ ref("fact_ap_holds_f_stg") }}
),
dim_supplier_stg as (
    select * from {{ ref("dim_supplier_stg") }}
),
dim_business_unit_stg as (
    select * from {{ ref("dim_business_unit_stg") }}
),
dim_gl_ledgers_stg as (
    select * from {{ ref("dim_gl_ledgers_stg") }}
),
dim_gl_account_stg as (
    select * from {{ ref("dim_gl_account_stg") }}
),
dim_product_stg as (
    select * from {{ ref("dim_product_stg") }}
),
dim_org_stg as (
    select * from {{ ref("dim_org_stg") }}
),
dim_legal_entity_stg as (
    select * from {{ ref("dim_legal_entity_stg") }}
),
dim_gl_daily_rates_stg as (
    select * from {{ ref("dim_gl_daily_rates_stg") }}
),
fact_ap_holds_f as (
select coalesce(dim_supplier_stg.supplier_id, 0) as supplier_key, coalesce(dim_gl_ledgers_stg.ledger_id, 0) as ledger_key, coalesce(dim_business_unit_stg.bu_id, 0) as bu_key, coalesce(dim_legal_entity_stg.legal_entity_id, 0) as legal_entity_key, coalesce(dim_gl_account_stg.glcc_id, 0) as glcc_key, coalesce(dim_org_stg.org_id, 0) as org_key, cast(coalesce(fact_ap_holds_f_stg.invoice_dt_id, 0) as numeric) as invoice_dt_key, coalesce(fact_ap_holds_f_stg.hold_dt_id, 0) as hold_dt_key, coalesce(fact_ap_holds_f_stg.accounting_dt_id, 0) as accounting_dt_key, coalesce(dim_product_stg.integration_id, 0) as product_key, fact_ap_holds_f_stg.supplier_contact as supplier_contact, fact_ap_holds_f_stg.period_name as period_name, fact_ap_holds_f_stg.period_year as period_year, fact_ap_holds_f_stg.period_num as period_num, cast(fact_ap_holds_f_stg.invoice_id as numeric) as invoice_id, fact_ap_holds_f_stg.invoice_num as invoice_num, fact_ap_holds_f_stg.invoice_desc as invoice_desc, fact_ap_holds_f_stg.invoice_line_num as invoice_line_num, fact_ap_holds_f_stg.hold_lookup_code as hold_lookup_code, fact_ap_holds_f_stg.hold_reason as hold_reason, fact_ap_holds_f_stg.hold_dt as hold_dt, fact_ap_holds_f_stg.hold_details as hold_details, fact_ap_holds_f_stg.accounting_dt as accounting_dt, fact_ap_holds_f_stg.invoice_dt as invoice_dt, fact_ap_holds_f_stg.release_lookup_code as release_lookup_code, fact_ap_holds_f_stg.release_reason as release_reason, fact_ap_holds_f_stg.release_type as release_type, fact_ap_holds_f_stg.identifying_po as identifying_po, fact_ap_holds_f_stg.hold_type as hold_type, fact_ap_holds_f_stg.invoice_source_name as invoice_source_name, fact_ap_holds_f_stg.validation_status as validation_status, fact_ap_holds_f_stg.inv_wfapproval_status as inv_wfapproval_status, fact_ap_holds_f_stg.inv_curr_code as inv_curr_code, fact_ap_holds_f_stg.ledger_curr_code as ledger_curr_code, fact_ap_holds_f_stg.hold_name as hold_name, fact_ap_holds_f_stg.hold_wfapproval_status as hold_wfapproval_status, fact_ap_holds_f_stg.hold_release_name as hold_release_name, cast(fact_ap_holds_f_stg.hold_cnt as numeric) as hold_cnt, fact_ap_holds_f_stg.invoice_amount as invoice_amount, fact_ap_holds_f_stg.invoice_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as invoice_amount_usd, coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as conv_rate_to_usd, coalesce(fact_ap_holds_f_stg.conv_rate_type, 'corporate') as conv_rate_type, fact_ap_holds_f_stg.creation_dt as creation_dt, fact_ap_holds_f_stg.last_update_dt as last_update_dt, fact_ap_holds_f_stg.created_by as created_by, fact_ap_holds_f_stg.last_updated_by as last_updated_by, fact_ap_holds_f_stg.integration_id as integration_id, fact_ap_holds_f_stg.datasource_num_id as datasource_num_id, current_date as w_insert_dt, current_date as w_update_dt from fact_ap_holds_f_stg fact_ap_holds_f_stg left outer join dim_supplier_stg dim_supplier_stg on dim_supplier_stg.integration_id = fact_ap_holds_f_stg.supplier_id and dim_supplier_stg.datasource_num_id = fact_ap_holds_f_stg.datasource_num_id left outer join dim_business_unit_stg dim_business_unit_stg on dim_business_unit_stg.integration_id = fact_ap_holds_f_stg.bu_id and dim_business_unit_stg.datasource_num_id = fact_ap_holds_f_stg.datasource_num_id left outer join dim_gl_ledgers_stg dim_gl_ledgers_stg on dim_gl_ledgers_stg.integration_id = fact_ap_holds_f_stg.ledger_id and dim_gl_ledgers_stg.datasource_num_id = fact_ap_holds_f_stg.datasource_num_id left outer join dim_gl_account_stg dim_gl_account_stg on dim_gl_account_stg.integration_id = fact_ap_holds_f_stg.glcc_id and dim_gl_account_stg.datasource_num_id = fact_ap_holds_f_stg.datasource_num_id left outer join dim_product_stg dim_product_stg on dim_product_stg.integration_id = cast(fact_ap_holds_f_stg.product_id as varchar) and dim_product_stg.datasource_num_id = fact_ap_holds_f_stg.datasource_num_id left outer join dim_org_stg dim_org_stg on cast(dim_org_stg.integration_id as varchar) = cast(fact_ap_holds_f_stg.org_id as varchar) and dim_org_stg.datasource_num_id = fact_ap_holds_f_stg.datasource_num_id left outer join dim_legal_entity_stg dim_legal_entity_stg on dim_legal_entity_stg.integration_id = fact_ap_holds_f_stg.legal_entity_id and dim_legal_entity_stg.datasource_num_id = fact_ap_holds_f_stg.datasource_num_id left outer join dim_gl_daily_rates_stg dim_gl_daily_rates_stg on fact_ap_holds_f_stg.inv_curr_code = dim_gl_daily_rates_stg.from_currency and cast(dim_gl_daily_rates_stg.conversion_dt as date) = cast(fact_ap_holds_f_stg.hold_dt as date) and dim_gl_daily_rates_stg.to_currency = 'usd' and dim_gl_daily_rates_stg.conversion_type = 'corporate' where (1 = 1)
)

        select *
        from fact_ap_holds_f
