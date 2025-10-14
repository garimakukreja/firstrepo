{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ct_ap_trans_f_stg', 'ct_gl_account_d', 'ct_supplier_d', 'ct_gl_ledgers_d', 'ct_legal_entity_d', 'ct_org_d', 'ct_business_unit_d', 'ct_product_d', 'ct_gl_daily_rates_d'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            ct_ap_trans_f_stg as (
    select * from {{ ref("ct_ap_trans_f_stg") }}
),
ct_gl_account_d as (
    select * from {{ ref("ct_gl_account_d") }}
),
ct_supplier_d as (
    select * from {{ ref("ct_supplier_d") }}
),
ct_gl_ledgers_d as (
    select * from {{ ref("ct_gl_ledgers_d") }}
),
ct_legal_entity_d as (
    select * from {{ ref("ct_legal_entity_d") }}
),
ct_org_d as (
    select * from {{ ref("ct_org_d") }}
),
ct_business_unit_d as (
    select * from {{ ref("ct_business_unit_d") }}
),
ct_product_d as (
    select * from {{ ref("ct_product_d") }}
),
ct_gl_daily_rates_d as (
    select * from {{ ref("ct_gl_daily_rates_d") }}
),
ct_ap_trans_f as (
SELECT COALESCE(ct_supplier_d.supplier_key, 0) AS supplier_key, COALESCE(cgl_ledgers_d.ledger_key, 0) AS ledger_key, COALESCE(clegal_entity_d.legal_entity_key, 0) AS legal_entity_key, COALESCE(ct_ap_trans_f_stg.invoice_dt_id, 0) AS invoice_dt_key, COALESCE(ct_ap_trans_f_stg.payment_due_dt_id, 0) AS payment_due_dt_key, COALESCE(ct_ap_trans_f_stg.gl_dt_id, 0) AS gl_dt_key, COALESCE(ct_ap_trans_f_stg.accounting_dt_id, 0) AS accounting_dt_key, COALESCE(cgl_account_d.glcc_key, 0) AS glcc_liab_key, COALESCE(cgl_account_d1.glcc_key, 0) AS glcc_expense_key, COALESCE(ct_business_unit_d.bu_key, 0) AS bu_key, COALESCE(ct_org_d.org_key, 0) AS org_key, COALESCE(ct_ap_trans_f_stg.project_id, 0) AS project_id, COALESCE(ct_ap_trans_f_stg.task_id, 0) AS task_id, COALESCE(ct_product_d.product_key, 0) AS product_key, ct_ap_trans_f_stg.period_name, ct_ap_trans_f_stg.period_year, ct_ap_trans_f_stg.period_num, ct_ap_trans_f_stg.supplier_contact, ct_ap_trans_f_stg.ledger_name, ct_ap_trans_f_stg.invoice_id, ct_ap_trans_f_stg.invoice_num, ct_ap_trans_f_stg.invoice_desc, ct_ap_trans_f_stg.invoice_line_num, ct_ap_trans_f_stg.dist_line_num, ct_ap_trans_f_stg.inv_curr_code, cgl_ledgers_d.ledger_curr_code, ct_ap_trans_f_stg.payment_curr_code, ct_ap_trans_f_stg.invoice_dt, ct_ap_trans_f_stg.gl_dt, ct_ap_trans_f_stg.accounting_dt, ct_ap_trans_f_stg.payment_due_dt, ct_ap_trans_f_stg.inv_source, ct_ap_trans_f_stg.inv_type_code, ct_ap_trans_f_stg.inv_type_name, ct_ap_trans_f_stg.inv_type_name AS transaction_sub_type, ct_ap_trans_f_stg.payment_terms, ct_ap_trans_f_stg.payment_method_code, ct_ap_trans_f_stg.payment_method_desc, ct_ap_trans_f_stg.payment_status_flag, ct_ap_trans_f_stg.payment_status, ct_ap_trans_f_stg.approval_status, ct_ap_trans_f_stg.goods_received_dt, ct_ap_trans_f_stg.invoice_received_dt, ct_ap_trans_f_stg.exch_rate, ct_ap_trans_f_stg.header_category_code, ct_ap_trans_f_stg.cancelled_dt, ct_ap_trans_f_stg.cancelled_by, ct_ap_trans_f_stg.project_name, ct_ap_trans_f_stg.task_name, ct_ap_trans_f_stg.line_type_lookup_code, ct_ap_trans_f_stg.line_type_lookup_desc, ct_ap_trans_f_stg.line_source, ct_ap_trans_f_stg.line_source_desc, ct_ap_trans_f_stg.uom_code, ct_ap_trans_f_stg.uom_desc, ct_ap_trans_f_stg.line_cancelled_flag, ct_ap_trans_f_stg.type_1099, ct_ap_trans_f_stg.line_category_code, ct_ap_trans_f_stg.accrual_posted_flag, ct_ap_trans_f_stg.cash_posted_flag, ct_ap_trans_f_stg.dist_glcc_concat, ct_ap_trans_f_stg.posted_flag, ct_ap_trans_f_stg.dist_category_code, ct_ap_trans_f_stg.po_header_id, ct_ap_trans_f_stg.po_number, ct_ap_trans_f_stg.po_line_id, ct_ap_trans_f_stg.po_line_num, ct_ap_trans_f_stg.po_line_location_id, ct_ap_trans_f_stg.po_shipment_num, ct_ap_trans_f_stg.po_distribution_id, ct_ap_trans_f_stg.rcv_transaction_id, ct_ap_trans_f_stg.po_receipt_num, ct_ap_trans_f_stg.match_type, ct_ap_trans_f_stg.po_release_id, ct_ap_trans_f_stg.unit_price, ct_ap_trans_f_stg.quantity_invoiced, ct_ap_trans_f_stg.inv_amount, ct_ap_trans_f_stg.inv_line_amount, ct_ap_trans_f_stg.inv_dist_line_amount, ct_ap_trans_f_stg.inv_ledger_amount, ct_ap_trans_f_stg.paid_amount, ct_ap_trans_f_stg.remaining_due_amount, ct_ap_trans_f_stg.amt_applicable_to_disc, ct_ap_trans_f_stg.base_amount, ct_ap_trans_f_stg.inv_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS inv_amount_usd, ct_ap_trans_f_stg.inv_line_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS inv_line_amount_usd, ct_ap_trans_f_stg.inv_dist_line_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS inv_dist_line_amount_usd, ct_ap_trans_f_stg.inv_ledger_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS inv_ledger_amount_usd, ct_ap_trans_f_stg.paid_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS paid_amount_usd, ct_ap_trans_f_stg.remaining_due_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS remaining_due_amount_usd, COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS conv_rate_to_usd, ct_ap_trans_f_stg.conv_rate_type, ct_ap_trans_f_stg.creation_dt, ct_ap_trans_f_stg.last_update_dt, ct_ap_trans_f_stg.created_by, ct_ap_trans_f_stg.last_updated_by, ct_ap_trans_f_stg.integration_id, ct_ap_trans_f_stg.datasource_num_id, ct_ap_trans_f_stg.inv_line_amount AS trans_amt, ct_ap_trans_f_stg.transaction_status, ct_ap_trans_f_stg.transaction_type, ct_ap_trans_f_stg.discount_amount_taken, ct_ap_trans_f_stg.delete_flag, ct_ap_trans_f_stg.w_insert_dt, ct_ap_trans_f_stg.w_update_dt, CAST(NULL AS VARCHAR) AS payment_number, CAST(NULL AS VARCHAR) AS hold_flag, CAST(NULL AS VARCHAR) AS remit_to_supplier_name, CAST(NULL AS VARCHAR) AS remit_to_address_name, CAST(NULL AS VARCHAR) AS remit_to_supplier_id, ct_ap_trans_f_stg.voucher_num FROM ct_ap_trans_f_stg LEFT JOIN ct_gl_account_d cgl_account_d ON ct_ap_trans_f_stg.glcc_liab_id = cgl_account_d.integration_id AND ct_ap_trans_f_stg.datasource_num_id = cgl_account_d.datasource_num_id LEFT JOIN ct_supplier_d ct_supplier_d ON ct_ap_trans_f_stg.supplier_id = ct_supplier_d.integration_id AND ct_ap_trans_f_stg.datasource_num_id = ct_supplier_d.datasource_num_id LEFT JOIN ct_gl_account_d cgl_account_d1 ON ct_ap_trans_f_stg.glcc_expense_id = cgl_account_d1.integration_id AND ct_ap_trans_f_stg.datasource_num_id = cgl_account_d1.datasource_num_id LEFT JOIN ct_gl_ledgers_d cgl_ledgers_d ON ct_ap_trans_f_stg.ledger_id = cgl_ledgers_d.integration_id AND ct_ap_trans_f_stg.datasource_num_id = cgl_ledgers_d.datasource_num_id LEFT JOIN ct_legal_entity_d clegal_entity_d ON CAST(ct_ap_trans_f_stg.legal_entity_id AS VARCHAR) = CAST(clegal_entity_d.integration_id AS VARCHAR) AND ct_ap_trans_f_stg.datasource_num_id = clegal_entity_d.datasource_num_id LEFT JOIN ct_org_d ct_org_d ON CAST(ct_ap_trans_f_stg.org_id AS VARCHAR) = CAST(ct_org_d.integration_id AS VARCHAR) AND ct_ap_trans_f_stg.datasource_num_id = ct_org_d.datasource_num_id LEFT JOIN ct_business_unit_d ct_business_unit_d ON ct_ap_trans_f_stg.bu_id = ct_business_unit_d.integration_id AND ct_ap_trans_f_stg.datasource_num_id = ct_business_unit_d.datasource_num_id LEFT JOIN ct_product_d ct_product_d ON ct_ap_trans_f_stg.product_id = ct_product_d.integration_id AND ct_ap_trans_f_stg.datasource_num_id = ct_product_d.datasource_num_id LEFT JOIN ct_gl_daily_rates_d ct_gl_daily_rates_d ON ct_ap_trans_f_stg.inv_curr_code = ct_gl_daily_rates_d.from_currency AND CAST(ct_gl_daily_rates_d.conversion_dt AS DATE) = CAST(ct_ap_trans_f_stg.invoice_dt AS DATE) AND ct_gl_daily_rates_d.to_currency = 'USD' AND ct_gl_daily_rates_d.conversion_type = 'Corporate' WHERE 1=1
)

        select *
        from ct_ap_trans_f;
