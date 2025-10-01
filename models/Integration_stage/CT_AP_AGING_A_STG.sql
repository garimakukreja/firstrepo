{{ config(materialized='table') }}

    with
    ap_payment_schedules_all as (
    select * from {{ ref("ap_payment_schedules_all") }}
),
ap_invoices_all as (
    select * from {{ ref("ap_invoices_all") }}
),
ap_terms_tl as (
    select * from {{ ref("ap_terms_tl") }}
),
gl_ledgers as (
    select * from {{ ref("gl_ledgers") }}
),
hr_operating_units as (
    select * from {{ ref("hr_operating_units") }}
),
xle_entity_profiles as (
    select * from {{ ref("xle_entity_profiles") }}
),
ap_suppliers as (
    select * from {{ ref("ap_suppliers") }}
),
ap_supplier_sites_all as (
    select * from {{ ref("ap_supplier_sites_all") }}
),
gl_daily_rates as (
    select * from {{ ref("gl_daily_rates") }}
),
ct_ap_aging_a_stg as (
    SELECT cast(to_char(current_date, 'YYYYMMDD') AS int) AS snapshot_dt_id, aia.set_of_books_id AS ledger_id, aia.org_id AS bu_id, aia.legal_entity_id AS legal_entity_id, concat( COALESCE(aia.vendor_id::varchar, '0'), '~', COALESCE(aia.vendor_site_id::varchar, '0') ) AS supplier_id, cast(to_char(apsa.due_date, 'YYYYMMDD') AS int) AS payment_due_dt_id, cast(to_char(aia.invoice_date, 'YYYYMMDD') AS int) AS invoice_dt_id, cast(to_char(aia.gl_date, 'YYYYMMDD') AS int) AS accounting_dt_id, aia.accts_pay_code_combination_id AS glcc_id, aia.org_id AS org_id, gl.name AS ledger_name, aia.org_id AS bu_num, hou.name AS bu_name, xep.legal_entity_identifier AS legal_entity_num, xep.name AS legal_entity_name, aps.segment1 AS supplier_num, aps.vendor_name AS supplier_name, apssa.vendor_site_code AS supplier_site_name, aia.org_id AS org_num, hou.name AS org_name, aia.invoice_id AS invoice_id, aia.invoice_num AS invoice_num, aia.description AS description, aia.invoice_currency_code AS inv_curr_code, gl.currency_code AS led_curr_code, apsa.due_date AS payment_due_dt, aia.invoice_date AS invoice_dt, aia.gl_date AS accounting_dt, apsa.payment_status_flag AS payment_status_flag, CASE WHEN (current_date > apsa.due_date) THEN 'Y' ELSE 'N' END AS over_due_flag, NULL::varchar AS active_flag, aia.wfapproval_status AS approval_status, aia.source AS source, aia.payment_method_lookup_code AS payment_type, CASE WHEN round(datediff(day, apsa.due_date, current_date), 2) > 0 AND round(datediff(day, apsa.due_date, current_date), 2) <= 30 THEN 1 WHEN round(datediff(day, apsa.due_date, current_date), 2) > 30 AND round(datediff(day, apsa.due_date, current_date), 2) <= 60 THEN 2 WHEN round(datediff(day, apsa.due_date, current_date), 2) >= 61 AND round(datediff(day, apsa.due_date, current_date), 2) <= 90 THEN 3 WHEN round(datediff(day, apsa.due_date, current_date), 2) > 90 THEN 4 END AS aging_bucket, CASE WHEN round(datediff(day, aia.invoice_date, current_date), 2) >= 0 AND round(datediff(day, aia.invoice_date, current_date), 2) <= 30 THEN 1 WHEN round(datediff(day, aia.invoice_date, current_date), 2) > 30 AND round(datediff(day, aia.invoice_date, current_date), 2) <= 60 THEN 2 WHEN round(datediff(day, aia.invoice_date, current_date), 2) >= 61 AND round(datediff(day, aia.invoice_date, current_date), 2) <= 90 THEN 3 WHEN round(datediff(day, aia.invoice_date, current_date), 2) > 90 THEN 4 END AS open_bucket, atl.name AS payment_terms, apsa.payment_method_code AS payment_method_code, round(datediff(day, apsa.due_date, current_date), 2) AS past_due_days, aia.invoice_amount AS invoice_amt, apsa.amount_remaining AS invoice_due_amt, COALESCE(gldr_ledger.conversion_rate, 1) * aia.invoice_amount AS inv_ledger_amt, aia.amount_paid AS inv_paid_amt, COALESCE(gldr.conversion_rate, 1) * aia.invoice_amount AS invoice_amt_usd, COALESCE(gldr.conversion_rate, 1) * apsa.amount_remaining AS invoice_due_amt_usd, COALESCE(gldr.conversion_rate, 1) * aia.invoice_amount AS inv_ledger_amt_usd, COALESCE(gldr.conversion_rate, 1) AS conv_rate_to_usd, 'Corporate' AS conv_rate_type, COALESCE(gldr_ledger.conversion_rate, 1) * apsa.amount_remaining AS inv_due_ledger_amt, aia.creation_date AS creation_dt, aia.last_update_date AS last_update_dt, aia.created_by AS created_by, aia.last_updated_by AS last_updated_by, concat(apsa.invoice_id::varchar, '~', apsa.payment_num::varchar) AS integration_id, 1000 AS datasource_num_id, 'N' AS delete_flag, current_date AS w_insert_dt, current_date AS w_update_dt FROM ap_payment_schedules_all apsa LEFT JOIN ap_invoices_all aia ON apsa.invoice_id = aia.invoice_id LEFT JOIN ap_terms_tl atl ON aia.terms_id = atl.term_id AND atl.language = 'US' LEFT JOIN gl_ledgers gl ON aia.set_of_books_id = gl.ledger_id LEFT JOIN hr_operating_units hou ON aia.org_id = hou.organization_id LEFT JOIN xle_entity_profiles xep ON aia.legal_entity_id = xep.legal_entity_id LEFT JOIN ap_suppliers aps ON aia.vendor_id = aps.vendor_id LEFT JOIN ap_supplier_sites_all apssa ON aia.vendor_site_id = apssa.vendor_site_id LEFT JOIN ( SELECT from_currency, conversion_rate, conversion_date FROM gl_daily_rates WHERE to_currency = 'USD' AND conversion_type = 'Corporate' ) gldr ON aia.invoice_date::date = gldr.conversion_date::date AND aia.invoice_currency_code = gldr.from_currency LEFT JOIN ( SELECT from_currency, conversion_rate, conversion_date, to_currency FROM gl_daily_rates WHERE conversion_type = 'Corporate' ) gldr_ledger ON aia.invoice_date::date = gldr_ledger.conversion_date::date AND aia.invoice_currency_code = gldr_ledger.from_currency AND gldr_ledger.to_currency = gl.currency_code WHERE aia.cancelled_date IS NULL AND (COALESCE(apsa.amount_remaining, 0) * COALESCE(aia.exchange_rate, 1)) <> 0 AND aia.payment_status_flag IN ('N', 'P')
)
    select * from ct_ap_aging_a_stg;
