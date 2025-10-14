{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ct_ap_payments_f_stg', 'dim_supplier_stg', 'dim_business_unit_stg', 'dim_gl_ledgers_stg', 'dim_gl_account_stg', 'dim_org_stg', 'dim_legal_entity_stg', 'dim_gl_daily_rates_stg'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            ct_ap_payments_f_stg as (
    select * from {{ ref("ct_ap_payments_f_stg") }}
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
dim_org_stg as (
    select * from {{ ref("dim_org_stg") }}
),
dim_legal_entity_stg as (
    select * from {{ ref("dim_legal_entity_stg") }}
),
dim_gl_daily_rates_stg as (
    select * from {{ ref("dim_gl_daily_rates_stg") }}
),
fact_ap_payments_f as (
select coalesce(dim_supplier_stg.supplier_key, 0) as supplier_key, coalesce(dim_gl_ledgers_stg.ledger_key, 0) as ledger_key, coalesce(dim_business_unit_stg.bu_key, 0) as bu_key, coalesce(dim_legal_entity_stg.legal_entity_key, 0) as legal_entity_key, coalesce(dim_gl_account_stg.glcc_key, 0) as glcc_key, coalesce(dim_org_stg.org_key, 0) as org_key, coalesce(ct_ap_payments_f_stg.invoice_dt_id, 0) as invoice_dt_key, coalesce(ct_ap_payments_f_stg.payment_dt_id, 0) as payment_dt_key, coalesce(ct_ap_payments_f_stg.gl_dt_id, 0) as gl_dt_key, coalesce(ct_ap_payments_f_stg.accounting_dt_id, 0) as accounting_dt_key, ct_ap_payments_f_stg.period_name, ct_ap_payments_f_stg.period_year, ct_ap_payments_f_stg.period_num, ct_ap_payments_f_stg.supplier_contact, ct_ap_payments_f_stg.check_id, ct_ap_payments_f_stg.check_num, ct_ap_payments_f_stg.check_voucher_num, ct_ap_payments_f_stg.check_dt, ct_ap_payments_f_stg.payment_curr_code, ct_ap_payments_f_stg.gl_dt, ct_ap_payments_f_stg.accounting_dt, ct_ap_payments_f_stg.invoice_dt, ct_ap_payments_f_stg.invoice_id, ct_ap_payments_f_stg.invoice_num, ct_ap_payments_f_stg.inv_curr_code, ct_ap_payments_f_stg.payment_due_dt, ct_ap_payments_f_stg.po_number, ct_ap_payments_f_stg.payee_name, ct_ap_payments_f_stg.payee_site_name, ct_ap_payments_f_stg.check_status, ct_ap_payments_f_stg.payment_status, ct_ap_payments_f_stg.payment_status_flag, ct_ap_payments_f_stg.payment_stopped_dt, ct_ap_payments_f_stg.payment_void_dt, ct_ap_payments_f_stg.payment_released_dt, ct_ap_payments_f_stg.remit_to_bank_account_no, ct_ap_payments_f_stg.remit_to_bank_name, ct_ap_payments_f_stg.remit_to_branch_name, ct_ap_payments_f_stg.remit_to_address, ct_ap_payments_f_stg.beneficiary_name, ct_ap_payments_f_stg.payment_method_name, ct_ap_payments_f_stg.cancelled_dt, ct_ap_payments_f_stg.cancelled_by, ct_ap_payments_f_stg.accrual_posted_flag, ct_ap_payments_f_stg.cash_posted_flag, ct_ap_payments_f_stg.posted_flag, ct_ap_payments_f_stg.invoice_amount, ct_ap_payments_f_stg.check_amount, ct_ap_payments_f_stg.payment_amount, ct_ap_payments_f_stg.invoice_due_amt, ct_ap_payments_f_stg.invoice_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as invoice_amount_usd, ct_ap_payments_f_stg.check_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as check_amount_usd, ct_ap_payments_f_stg.payment_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as payment_amount_usd, ct_ap_payments_f_stg.invoice_due_amt * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as invoice_due_amt_usd, coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as conv_pymt_rate_to_usd, coalesce(ct_ap_payments_f_stg.conv_pymt_rate_type, 'corporate') as conv_pymt_rate_type, coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as conv_inv_rate_to_usd, coalesce(ct_ap_payments_f_stg.conv_inv_rate_type, 'corporate') as conv_inv_rate_type, ct_ap_payments_f_stg.creation_dt, ct_ap_payments_f_stg.last_update_dt, ct_ap_payments_f_stg.created_by, ct_ap_payments_f_stg.last_updated_by, ct_ap_payments_f_stg.integration_id, ct_ap_payments_f_stg.datasource_num_id, current_date as w_insert_dt, current_date as w_update_dt, ct_ap_payments_f_stg.payment_type, ct_ap_payments_f_stg.payment_date, ct_ap_payments_f_stg.payment_terms, ct_ap_payments_f_stg.discount_amount_taken, ct_ap_payments_f_stg.amount_applicable_to_discount, ct_ap_payments_f_stg.over_due_flag, ct_ap_payments_f_stg.payment_late_flag from ct_ap_payments_f_stg ct_ap_payments_f_stg left outer join dim_supplier_stg dim_supplier_stg on dim_supplier_stg.integration_id = ct_ap_payments_f_stg.supplier_id and dim_supplier_stg.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id left outer join dim_business_unit_stg dim_business_unit_stg on dim_business_unit_stg.integration_id = ct_ap_payments_f_stg.bu_id and dim_business_unit_stg.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id left outer join dim_gl_ledgers_stg dim_gl_ledgers_stg on dim_gl_ledgers_stg.integration_id = ct_ap_payments_f_stg.ledger_id and dim_gl_ledgers_stg.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id left outer join dim_gl_account_stg dim_gl_account_stg on dim_gl_account_stg.integration_id = ct_ap_payments_f_stg.glcc_id and dim_gl_account_stg.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id left outer join dim_org_stg dim_org_stg on cast(dim_org_stg.integration_id as varchar) = cast(ct_ap_payments_f_stg.org_id as varchar) and dim_org_stg.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id left outer join dim_legal_entity_stg dim_legal_entity_stg on dim_legal_entity_stg.integration_id = ct_ap_payments_f_stg.legal_entity_id and dim_legal_entity_stg.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id left outer join dim_gl_daily_rates_stg dim_gl_daily_rates_stg on dim_gl_daily_rates_stg.from_currency = ct_ap_payments_f_stg.payment_curr_code and dim_gl_daily_rates_stg.to_currency = 'usd' and dim_gl_daily_rates_stg.conversion_type = 'corporate' and cast(dim_gl_daily_rates_stg.conversion_dt as date) = cast(ct_ap_payments_f_stg.invoice_dt as date) where 1 = 1
)

        select *
        from fact_ap_payments_f;
