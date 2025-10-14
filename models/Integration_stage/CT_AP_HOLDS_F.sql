{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ct_ap_holds_f_stg', 'ct_supplier_d', 'ct_business_unit_d', 'ct_gl_ledgers_d', 'ct_gl_account_d', 'ct_product_d', 'ct_org_d', 'ct_legal_entity_d', 'ct_gl_daily_rates_d'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            ct_ap_holds_f_stg as (
    select * from {{ ref("ct_ap_holds_f_stg") }}
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
ct_product_d as (
    select * from {{ ref("ct_product_d") }}
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
ct_ap_holds_f as (
SELECT COALESCE(ct_supplier_d.supplier_key, 0) AS supplier_key, COALESCE(ct_gl_ledgers_d.ledger_key, 0) AS ledger_key, COALESCE(ct_business_unit_d.bu_key, 0) AS bu_key, COALESCE(ct_legal_entity_d.legal_entity_key, 0) AS legal_entity_key, COALESCE(ct_gl_account_d.glcc_key, 0) AS glcc_key, COALESCE(ct_org_d.org_key, 0) AS org_key, CAST(COALESCE(ct_ap_holds_f_stg.invoice_dt_id, 0) AS NUMERIC) AS invoice_dt_key, COALESCE(ct_ap_holds_f_stg.hold_dt_id, 0) AS hold_dt_key, COALESCE(ct_ap_holds_f_stg.accounting_dt_id, 0) AS accounting_dt_key, COALESCE(ct_product_d.product_key, 0) AS product_key, ct_ap_holds_f_stg.supplier_contact AS supplier_contact, ct_ap_holds_f_stg.period_name AS period_name, ct_ap_holds_f_stg.period_year AS period_year, ct_ap_holds_f_stg.period_num AS period_num, CAST(ct_ap_holds_f_stg.invoice_id AS NUMERIC) AS invoice_id, ct_ap_holds_f_stg.invoice_num AS invoice_num, ct_ap_holds_f_stg.invoice_desc AS invoice_desc, ct_ap_holds_f_stg.invoice_line_num AS invoice_line_num, ct_ap_holds_f_stg.hold_lookup_code AS hold_lookup_code, ct_ap_holds_f_stg.hold_reason AS hold_reason, ct_ap_holds_f_stg.hold_dt AS hold_dt, ct_ap_holds_f_stg.hold_details AS hold_details, ct_ap_holds_f_stg.accounting_dt AS accounting_dt, ct_ap_holds_f_stg.invoice_dt AS invoice_dt, ct_ap_holds_f_stg.release_lookup_code AS release_lookup_code, ct_ap_holds_f_stg.release_reason AS release_reason, ct_ap_holds_f_stg.release_type AS release_type, ct_ap_holds_f_stg.identifying_po AS identifying_po, ct_ap_holds_f_stg.hold_type AS hold_type, ct_ap_holds_f_stg.invoice_source_name AS invoice_source_name, ct_ap_holds_f_stg.validation_status AS validation_status, ct_ap_holds_f_stg.inv_wfapproval_status AS inv_wfapproval_status, ct_ap_holds_f_stg.inv_curr_code AS inv_curr_code, ct_ap_holds_f_stg.ledger_curr_code AS ledger_curr_code, ct_ap_holds_f_stg.hold_name AS hold_name, ct_ap_holds_f_stg.hold_wfapproval_status AS hold_wfapproval_status, ct_ap_holds_f_stg.hold_release_name AS hold_release_name, CAST(ct_ap_holds_f_stg.hold_cnt AS NUMERIC) AS hold_cnt, ct_ap_holds_f_stg.invoice_amount AS invoice_amount, ct_ap_holds_f_stg.invoice_amount * COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS invoice_amount_usd, COALESCE(ct_gl_daily_rates_d.conversion_rate, 1) AS conv_rate_to_usd, COALESCE(ct_ap_holds_f_stg.conv_rate_type, 'Corporate') AS conv_rate_type, ct_ap_holds_f_stg.creation_dt AS creation_dt, ct_ap_holds_f_stg.last_update_dt AS last_update_dt, ct_ap_holds_f_stg.created_by AS created_by, ct_ap_holds_f_stg.last_updated_by AS last_updated_by, ct_ap_holds_f_stg.integration_id AS integration_id, ct_ap_holds_f_stg.datasource_num_id AS datasource_num_id, CURRENT_DATE AS w_insert_dt, CURRENT_DATE AS w_update_dt FROM ct_ap_holds_f_stg ct_ap_holds_f_stg LEFT OUTER JOIN ct_supplier_d ct_supplier_d ON ct_supplier_d.integration_id = ct_ap_holds_f_stg.supplier_id AND ct_supplier_d.datasource_num_id = ct_ap_holds_f_stg.datasource_num_id LEFT OUTER JOIN ct_business_unit_d ct_business_unit_d ON ct_business_unit_d.integration_id = ct_ap_holds_f_stg.bu_id AND ct_business_unit_d.datasource_num_id = ct_ap_holds_f_stg.datasource_num_id LEFT OUTER JOIN ct_gl_ledgers_d ct_gl_ledgers_d ON ct_gl_ledgers_d.integration_id = ct_ap_holds_f_stg.ledger_id AND ct_gl_ledgers_d.datasource_num_id = ct_ap_holds_f_stg.datasource_num_id LEFT OUTER JOIN ct_gl_account_d ct_gl_account_d ON ct_gl_account_d.integration_id = ct_ap_holds_f_stg.glcc_id AND ct_gl_account_d.datasource_num_id = ct_ap_holds_f_stg.datasource_num_id LEFT OUTER JOIN ct_product_d ct_product_d ON ct_product_d.integration_id = CAST(ct_ap_holds_f_stg.product_id AS VARCHAR) AND ct_product_d.datasource_num_id = ct_ap_holds_f_stg.datasource_num_id LEFT OUTER JOIN ct_org_d ct_org_d ON CAST(ct_org_d.integration_id AS VARCHAR) = CAST(ct_ap_holds_f_stg.org_id AS VARCHAR) AND ct_org_d.datasource_num_id = ct_ap_holds_f_stg.datasource_num_id LEFT OUTER JOIN ct_legal_entity_d ct_legal_entity_d ON ct_legal_entity_d.integration_id = ct_ap_holds_f_stg.legal_entity_id AND ct_legal_entity_d.datasource_num_id = ct_ap_holds_f_stg.datasource_num_id LEFT OUTER JOIN ct_gl_daily_rates_d ct_gl_daily_rates_d ON ct_ap_holds_f_stg.inv_curr_code = ct_gl_daily_rates_d.from_currency AND CAST(ct_gl_daily_rates_d.conversion_dt AS DATE) = CAST(ct_ap_holds_f_stg.hold_dt AS DATE) AND ct_gl_daily_rates_d.to_currency = 'USD' AND ct_gl_daily_rates_d.conversion_type = 'Corporate' WHERE (1 = 1)
)

        select *
        from ct_ap_holds_f;
