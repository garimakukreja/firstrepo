{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ap_invoices_all', 'ap_holds_all', 'ap_invoice_lines_all', 'po_headers_all', 'hz_party', 'hz_party_site', 'ap_hold_codes', 'gl_ledger', 'ap_lookup_codes'] %}
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
    select * from {{ ref("hz_party") }}
),
hz_party_site as (
    select * from {{ ref("hz_party_site") }}
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
select concat(coalesce(apholds_f_join_a.vendor_id, '0'), '~', coalesce(apholds_f_join_a.vendor_site_id, '0')) as supplier_id, apholds_f_join_a.set_of_books_id as ledger_id, apholds_f_join_a.org_id_1 as bu_id, apholds_f_join_a.legal_entity_id as legal_entity_id, coalesce(apholds_f_join_a.accts_pay_code_combination_id, 0) as glcc_id, apholds_f_join_a.org_id as org_id, cast(to_char(apholds_f_join_a.invoice_date, 'yyyymmdd') as int) as invoice_dt_id, cast(to_char(apholds_f_join_a.hold_date, 'yyyymmdd') as int) as hold_dt_id, cast(to_char(apholds_f_join_a.gl_date, 'yyyymmdd') as int) as accounting_dt_id, coalesce(apholds_f_join_a.inventory_item_id, 0) as product_id, null as supplier_contact, to_char(apholds_f_join_a.invoice_date, 'mon-yy') as period_name, extract(year from apholds_f_join_a.invoice_date) as period_year, extract(month from apholds_f_join_a.invoice_date) as period_num, apholds_f_join_a.name as ledger_name, apholds_f_join_a.invoice_id, apholds_f_join_a.invoice_num, apholds_f_join_a.description as invoice_desc, apholds_f_join_a.line_number as invoice_line_num, apholds_f_join_a.hold_lookup_code, apholds_f_join_a.hold_reason, apholds_f_join_a.hold_date as hold_dt, apholds_f_join_a.hold_details, apholds_f_join_a.gl_date as accounting_dt, apholds_f_join_a.invoice_date as invoice_dt, apholds_f_join_a.release_lookup_code, apholds_f_join_a.release_reason, apholds_f_join_a.hold_type_1 as release_type, apholds_f_join_a.segment1 as identifying_po, apholds_f_join_a.hold_type, apholds_f_join_a.source as invoice_source_name, apholds_f_join_a.approval_status as validation_status, apholds_f_join_a.wfapproval_status as inv_wfapproval_status, apholds_f_join_a.invoice_currency_code as inv_curr_code, apholds_f_join_a.currency_code as ledger_curr_code, apholds_f_join_a.displayed_field as hold_name, apholds_f_join_a.requester_id as requester_id, apholds_f_join_a.wf_status as hold_wfapproval_status, apholds_f_join_a.displayed_field_1 as hold_release_name, 1 as hold_cnt, apholds_f_join_a.invoice_amount, apholds_f_join_a.invoice_amount as invoice_amount_usd, 0 as conv_rate_to_usd, null as conv_rate_type, apholds_f_join_a.creation_date as creation_dt, apholds_f_join_a.last_update_date as last_update_dt, apholds_f_join_a.created_by, apholds_f_join_a.last_updated_by, concat( apholds_f_join_a.invoice_id, '~', apholds_f_join_a.line_number, '~', apholds_f_join_a.hold_id, '~', coalesce(apholds_f_join_a.hold_reason, '') ) as integration_id, 1000 as datasource_num_id, 'n' as delete_flag from ( select invoices_all.invoice_id, invoices_all.invoice_num, invoices_all.set_of_books_id, invoices_all.invoice_currency_code, invoices_all.invoice_amount, invoices_all.vendor_id, invoices_all.vendor_site_id, invoices_all.invoice_date, invoices_all.source, invoices_all.description, invoices_all.accts_pay_code_combination_id, invoices_all.approval_status, invoices_all.org_id, invoices_all.gl_date, invoices_all.wfapproval_status, invoices_all.requester_id, invoices_all.legal_entity_id, holds_all.hold_lookup_code, holds_all.last_update_date, holds_all.last_updated_by, holds_all.hold_date, holds_all.hold_reason, holds_all.release_lookup_code, holds_all.release_reason, holds_all.creation_date, holds_all.created_by, holds_all.org_id as org_id_1, holds_all.hold_details, holds_all.hold_id, holds_all.wf_status, invoice_lines_all.line_number, invoice_lines_all.inventory_item_id, hold_codes.hold_type, lookup_codes.displayed_field, gl_ledger.name, gl_ledger.currency_code, po_headers_all.segment1, hold_codes1.hold_type as hold_type_1, lookup_codes1.displayed_field as displayed_field_1 from ap_invoices_all invoices_all join ap_holds_all holds_all on holds_all.invoice_id = invoices_all.invoice_id join ap_invoice_lines_all invoice_lines_all on invoice_lines_all.invoice_id = invoices_all.invoice_id left join po_headers_all po_headers_all on invoices_all.po_header_id = po_headers_all.po_header_id left join hz_party hz_party on invoices_all.party_id = hz_party.party_id left join hz_party_site hz_party_site on invoices_all.party_site_id = hz_party_site.party_site_id join ap_hold_codes hold_codes on holds_all.hold_lookup_code = hold_codes.hold_lookup_code left join ap_hold_codes hold_codes1 on holds_all.release_lookup_code = hold_codes1.hold_lookup_code join gl_ledger gl_ledger on gl_ledger.ledger_id = invoices_all.set_of_books_id join ap_lookup_codes lookup_codes on holds_all.hold_lookup_code = lookup_codes.lookup_code and lookup_codes.lookup_type = 'hold code' left join ap_lookup_codes lookup_codes1 on holds_all.release_lookup_code = lookup_codes1.lookup_code and lookup_codes1.lookup_type = 'hold code' --where ( holds_all.last_update_date >= cast('$last_run_date$' as date) or invoices_all.last_update_date >= cast('$last_run_date$' as date) or invoice_lines_all.last_update_date >= cast('$last_run_date$' as date) ) ) apholds_f_join_a
)

        select *
        from fact_ap_holds_f_stg;
