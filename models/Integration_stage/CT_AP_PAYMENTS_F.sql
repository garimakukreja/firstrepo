{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ct_ap_payments_f_stg', 'ct_supplier_d', 'ct_business_unit_d', 'ct_gl_ledgers_d', 'ct_gl_account_d', 'ct_org_d', 'ct_legal_entity_d', 'ct_gl_daily_rates_d'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            ct_ap_payments_f_stg as (
    select * from {{ ref("ct_ap_payments_f_stg") }}
),
ct_supplier_d as (
    select * from {{ ref("ct_supplier_d") }}
),
ct_business_unit_d as (
    select * from {{ ref("ct_business_unit_d") }}
),
ct_gl_ledgers_d as (
    select * from {{ ref("ct_gl_ledgers_d") }}
),
ct_gl_account_d as (
    select * from {{ ref("ct_gl_account_d") }}
),
ct_org_d as (
    select * from {{ ref("ct_org_d") }}
),
ct_legal_entity_d as (
    select * from {{ ref("ct_legal_entity_d") }}
),
ct_gl_daily_rates_d as (
    select * from {{ ref("ct_gl_daily_rates_d") }}
),
ct_ap_payments_f as (
SELECT COALESCE(ct_supplier_d.supplier_key, 0) AS supplier_key, COALESCE(ct_gl_ledgers_d.ledger_key, 0) AS ledger_key, COALESCE(ct_business_unit_d.bu_key, 0) AS bu_key, COALESCE(ct_legal_entity_d.legal_entity_key, 0) AS legal_entity_key, COALESCE(ct_gl_account_d.glcc_key, 0) AS glcc_key, COALESCE(ct_org_d.org_key, 0) AS org_key, COALESCE(ct_ap_payments_f_stg.invoice_dt_id, 0) AS invoice_dt_key, COALESCE(ct_ap_payments_f_stg.payment_dt_id, 0) AS payment_dt_key, COALESCE(ct_ap_payments_f_stg.gl_dt_id, 0) AS gl_dt_key, COALESCE(ct_ap_payments_f_stg.accounting_dt_id, 0) AS accounting_dt_key, ct_ap_payments_f_stg.period_name, ct_ap_payments_f_stg.period_year, ct_ap_payments_f_stg.period_num, ct_ap_payments_f_stg.supplier_contact, ct_ap_payments_f_stg.check_id, ct_ap_payments_f_stg.check_num, ct_ap_payments_f_stg.check_voucher_num, ct_ap_payments_f_stg.check_dt, ct_ap_payments_f_stg.payment_curr_code, ct_ap_payments_f_stg.gl_dt, ct_ap_payments_f_stg.accounting_dt, ct_ap_payments_f_stg.invoice_dt, ct_ap_payments_f_stg.invoice_id, ct_ap_payments_f_stg.invoice_num, ct_ap_payments_f_stg.inv_curr_code, ct_ap_payments_f_stg.payment_due_dt, ct_ap_payments_f_stg.po_number, ct_ap_payments_f_stg.payee_name, ct_ap_payments_f_stg.payee_site_name, ct_ap_payments_f_stg.check_status, ct_ap_payments_f_stg.payment_status, ct_ap_payments_f_stg.payment_status_flag, ct_ap_payments_f_stg.payment_stopped_dt, ct_ap_payments_f_stg.payment_void_dt, ct_ap_payments_f_stg.payment_released_dt, ct_ap_payments_f_stg.remit_to_bank_account_no, ct_ap_payments_f_stg.remit_to_bank_name, ct_ap_payments_f_stg.remit_to_branch_name, ct_ap_payments_f_stg.remit_to_address, ct_ap_payments_f_stg.beneficiary_name, ct_ap_payments_f_stg.payment_method_name, ct_ap_payments_f_stg.cancelled_dt, ct_ap_payments_f_stg.cancelled_by, ct_ap_payments_f_stg.accrual_posted_flag, ct_ap_payments_f_stg.cash_posted_flag, ct_ap_payments_f_stg.posted_flag, ct_ap_payments_f_stg.invoice_amount, ct_ap_payments_f_stg.check_amount, ct_ap_payments_f_stg.payment_amount, ct_ap_payments_f_stg.invoice_due_amt, ct_ap_payments_f_stg.invoice_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS invoice_amount_usd, ct_ap_payments_f_stg.check_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS check_amount_usd, ct_ap_payments_f_stg.payment_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS payment_amount_usd, ct_ap_payments_f_stg.invoice_due_amt * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS invoice_due_amt_usd, COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS conv_pymt_rate_to_usd, COALESCE(ct_ap_payments_f_stg.conv_pymt_rate_type, 'Corporate') AS conv_pymt_rate_type, COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS conv_inv_rate_to_usd, COALESCE(ct_ap_payments_f_stg.conv_inv_rate_type, 'Corporate') AS conv_inv_rate_type, ct_ap_payments_f_stg.creation_dt, ct_ap_payments_f_stg.last_update_dt, ct_ap_payments_f_stg.created_by, ct_ap_payments_f_stg.last_updated_by, ct_ap_payments_f_stg.integration_id, ct_ap_payments_f_stg.datasource_num_id, CURRENT_DATE AS w_insert_dt, CURRENT_DATE AS w_update_dt, ct_ap_payments_f_stg.payment_type, ct_ap_payments_f_stg.payment_date, ct_ap_payments_f_stg.payment_terms, ct_ap_payments_f_stg.discount_amount_taken, ct_ap_payments_f_stg.amount_applicable_to_discount, ct_ap_payments_f_stg.over_due_flag, ct_ap_payments_f_stg.payment_late_flag FROM ct_ap_payments_f_stg ct_ap_payments_f_stg LEFT OUTER JOIN ct_supplier_d ct_supplier_d ON ct_supplier_d.integration_id = ct_ap_payments_f_stg.supplier_id AND ct_supplier_d.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id LEFT OUTER JOIN ct_business_unit_d ct_business_unit_d ON ct_business_unit_d.integration_id = ct_ap_payments_f_stg.bu_id AND ct_business_unit_d.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id LEFT OUTER JOIN ct_gl_ledgers_d ct_gl_ledgers_d ON ct_gl_ledgers_d.integration_id = ct_ap_payments_f_stg.ledger_id AND ct_gl_ledgers_d.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id LEFT OUTER JOIN ct_gl_account_d ct_gl_account_d ON ct_gl_account_d.integration_id = ct_ap_payments_f_stg.glcc_id AND ct_gl_account_d.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id LEFT OUTER JOIN ct_org_d ct_org_d ON CAST(ct_org_d.integration_id AS VARCHAR) = CAST(ct_ap_payments_f_stg.org_id AS VARCHAR) AND ct_org_d.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id LEFT OUTER JOIN ct_legal_entity_d ct_legal_entity_d ON ct_legal_entity_d.integration_id = ct_ap_payments_f_stg.legal_entity_id AND ct_legal_entity_d.datasource_num_id = ct_ap_payments_f_stg.datasource_num_id LEFT OUTER JOIN ct_gl_daily_rates_d ct_gl_daily_rates_d ON ct_gl_daily_rates_d.from_currency = ct_ap_payments_f_stg.payment_curr_code AND ct_gl_daily_rates_d.to_currency = 'USD' AND ct_gl_daily_rates_d.conversion_type = 'Corporate' AND CAST(ct_gl_daily_rates_d.conversion_dt AS DATE) = CAST(ct_ap_payments_f_stg.invoice_dt AS DATE) WHERE 1 = 1
)

        select *
        from ct_ap_payments_f;
