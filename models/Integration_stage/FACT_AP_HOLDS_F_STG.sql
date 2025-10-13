{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ap_invoices_all', 'ap_holds_all', 'ap_invoice_lines_all', 'po_headers_all', 'HZ_PARTY', 'HZ_PARTY_SITE', 'ap_hold_codes', 'gl_ledger', 'ap_lookup_codes'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            ap_invoices_all as (
    select * from {{ ref("ap_invoices_all") }}
),
ap_holds_all as (
    select * from {{ ref("ap_holds_all") }}
),
ap_invoice_lines_all as (
    select * from {{ ref("ap_invoice_lines_all") }}
),
po_headers_all as (
    select * from {{ ref("po_headers_all") }}
),
hz_party as (
    select * from {{ ref("HZ_PARTY") }}
),
hz_party_site as (
    select * from {{ ref("HZ_PARTY_SITE") }}
),
ap_hold_codes as (
    select * from {{ ref("ap_hold_codes") }}
),
gl_ledger as (
    select * from {{ ref("gl_ledger") }}
),
ap_lookup_codes as (
    select * from {{ ref("ap_lookup_codes") }}
),
fact_ap_holds_f_stg as (
SELECT CONCAT(COALESCE(apholds_f_join_a.vendor_id, '0'), '~', COALESCE(apholds_f_join_a.vendor_site_id, '0')) AS supplier_id, apholds_f_join_a.set_of_books_id AS ledger_id, apholds_f_join_a.org_id_1 AS bu_id, apholds_f_join_a.legal_entity_id AS legal_entity_id, COALESCE(apholds_f_join_a.accts_pay_code_combination_id, 0) AS glcc_id, apholds_f_join_a.org_id AS org_id, CAST(TO_CHAR(apholds_f_join_a.invoice_date, 'YYYYMMDD') AS INT) AS invoice_dt_id, CAST(TO_CHAR(apholds_f_join_a.hold_date, 'YYYYMMDD') AS INT) AS hold_dt_id, CAST(TO_CHAR(apholds_f_join_a.gl_date, 'YYYYMMDD') AS INT) AS accounting_dt_id, COALESCE(apholds_f_join_a.inventory_item_id, 0) AS product_id, NULL AS supplier_contact, TO_CHAR(apholds_f_join_a.invoice_date, 'MON-YY') AS period_name, EXTRACT(YEAR FROM apholds_f_join_a.invoice_date) AS period_year, EXTRACT(MONTH FROM apholds_f_join_a.invoice_date) AS period_num, apholds_f_join_a.name AS ledger_name, apholds_f_join_a.invoice_id, apholds_f_join_a.invoice_num, apholds_f_join_a.description AS invoice_desc, apholds_f_join_a.line_number AS invoice_line_num, apholds_f_join_a.hold_lookup_code, apholds_f_join_a.hold_reason, apholds_f_join_a.hold_date AS hold_dt, apholds_f_join_a.hold_details, apholds_f_join_a.gl_date AS accounting_dt, apholds_f_join_a.invoice_date AS invoice_dt, apholds_f_join_a.release_lookup_code, apholds_f_join_a.release_reason, apholds_f_join_a.hold_type_1 AS release_type, apholds_f_join_a.segment1 AS identifying_po, apholds_f_join_a.hold_type, apholds_f_join_a.source AS invoice_source_name, apholds_f_join_a.approval_status AS validation_status, apholds_f_join_a.wfapproval_status AS inv_wfapproval_status, apholds_f_join_a.invoice_currency_code AS inv_curr_code, apholds_f_join_a.currency_code AS ledger_curr_code, apholds_f_join_a.displayed_field AS hold_name, apholds_f_join_a.requester_id AS requester_id, apholds_f_join_a.wf_status AS hold_wfapproval_status, apholds_f_join_a.displayed_field_1 AS hold_release_name, 1 AS hold_cnt, apholds_f_join_a.invoice_amount, apholds_f_join_a.invoice_amount AS invoice_amount_usd, 0 AS conv_rate_to_usd, NULL AS conv_rate_type, apholds_f_join_a.creation_date AS creation_dt, apholds_f_join_a.last_update_date AS last_update_dt, apholds_f_join_a.created_by, apholds_f_join_a.last_updated_by, CONCAT( apholds_f_join_a.invoice_id, '~', apholds_f_join_a.line_number, '~', apholds_f_join_a.hold_id, '~', COALESCE(apholds_f_join_a.hold_reason, '') ) AS integration_id, 1000 AS datasource_num_id, 'N' AS delete_flag FROM ( SELECT invoices_all.invoice_id, invoices_all.invoice_num, invoices_all.set_of_books_id, invoices_all.invoice_currency_code, invoices_all.invoice_amount, invoices_all.vendor_id, invoices_all.vendor_site_id, invoices_all.invoice_date, invoices_all.source, invoices_all.description, invoices_all.accts_pay_code_combination_id, invoices_all.approval_status, invoices_all.org_id, invoices_all.gl_date, invoices_all.wfapproval_status, invoices_all.requester_id, invoices_all.legal_entity_id, holds_all.hold_lookup_code, holds_all.last_update_date, holds_all.last_updated_by, holds_all.hold_date, holds_all.hold_reason, holds_all.release_lookup_code, holds_all.release_reason, holds_all.creation_date, holds_all.created_by, holds_all.org_id AS org_id_1, holds_all.hold_details, holds_all.hold_id, holds_all.wf_status, invoice_lines_all.line_number, invoice_lines_all.inventory_item_id, hold_codes.hold_type, lookup_codes.displayed_field, gl_ledgers.name, gl_ledgers.currency_code, po_headers_all.segment1, hold_codes1.hold_type AS hold_type_1, lookup_codes1.displayed_field AS displayed_field_1 FROM ap_invoices_all invoices_all JOIN ap_holds_all holds_all ON holds_all.invoice_id = invoices_all.invoice_id JOIN ap_invoice_lines_all invoice_lines_all ON invoice_lines_all.invoice_id = invoices_all.invoice_id LEFT JOIN po_headers_all po_headers_all ON invoices_all.po_header_id = po_headers_all.po_header_id LEFT JOIN hz_parties hz_parties ON invoices_all.party_id = hz_parties.party_id LEFT JOIN hz_party_sites hz_party_sites ON invoices_all.party_site_id = hz_party_sites.party_site_id JOIN ap_hold_codes hold_codes ON holds_all.hold_lookup_code = hold_codes.hold_lookup_code LEFT JOIN ap_hold_codes hold_codes1 ON holds_all.release_lookup_code = hold_codes1.hold_lookup_code JOIN gl_ledgers gl_ledgers ON gl_ledgers.ledger_id = invoices_all.set_of_books_id JOIN ap_lookup_codes lookup_codes ON holds_all.hold_lookup_code = lookup_codes.lookup_code AND lookup_codes.lookup_type = 'HOLD CODE' LEFT JOIN ap_lookup_codes lookup_codes1 ON holds_all.release_lookup_code = lookup_codes1.lookup_code AND lookup_codes1.lookup_type = 'HOLD CODE' --WHERE ( holds_all.last_update_date >= CAST('$LAST_RUN_DATE$' AS DATE) OR invoices_all.last_update_date >= CAST('$LAST_RUN_DATE$' AS DATE) OR invoice_lines_all.last_update_date >= CAST('$LAST_RUN_DATE$' AS DATE) ) ) apholds_f_join_a
)

        select *
        from fact_ap_holds_f_stg;
