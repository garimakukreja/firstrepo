{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ap_payment_schedules_all', 'ap_invoices_all', 'ap_terms_tl', 'gl_ledger', 'hr_operating_units', 'xle_entity_profiles', 'ap_suppliers', 'ap_supplier_sites_all', 'gl_daily_rate'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

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
gl_ledger as (
    select * from {{ ref("gl_ledger") }}
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
gl_daily_rate as (
    select * from {{ ref("gl_daily_rate") }}
),
fact_ap_aging_a_stg as (
select cast(to_char(current_date, 'yyyymmdd') as int) as snapshot_dt_id, aia.set_of_books_id as ledger_id, aia.org_id as bu_id, aia.legal_entity_id as legal_entity_id, concat( coalesce(aia.vendor_id::varchar, '0'), '~', coalesce(aia.vendor_site_id::varchar, '0') ) as supplier_id, cast(to_char(apsa.due_date, 'yyyymmdd') as int) as payment_due_dt_id, cast(to_char(aia.invoice_date, 'yyyymmdd') as int) as invoice_dt_id, cast(to_char(aia.gl_date, 'yyyymmdd') as int) as accounting_dt_id, aia.accts_pay_code_combination_id as glcc_id, aia.org_id as org_id, gl.name as ledger_name, aia.org_id as bu_num, hou.name as bu_name, xep.legal_entity_identifier as legal_entity_num, xep.name as legal_entity_name, aps.segment1 as supplier_num, aps.vendor_name as supplier_name, apssa.vendor_site_code as supplier_site_name, aia.org_id as org_num, hou.name as org_name, aia.invoice_id as invoice_id, aia.invoice_num as invoice_num, aia.description as description, aia.invoice_currency_code as inv_curr_code, gl.currency_code as led_curr_code, apsa.due_date as payment_due_dt, aia.invoice_date as invoice_dt, aia.gl_date as accounting_dt, apsa.payment_status_flag as payment_status_flag, case when (current_date > apsa.due_date) then 'y' else 'n' end as over_due_flag, null::varchar as active_flag, aia.wfapproval_status as approval_status, aia.source as source, aia.payment_method_lookup_code as payment_type, case when round(datediff(day, apsa.due_date, current_date), 2) > 0 and round(datediff(day, apsa.due_date, current_date), 2) <= 30 then 1 when round(datediff(day, apsa.due_date, current_date), 2) > 30 and round(datediff(day, apsa.due_date, current_date), 2) <= 60 then 2 when round(datediff(day, apsa.due_date, current_date), 2) >= 61 and round(datediff(day, apsa.due_date, current_date), 2) <= 90 then 3 when round(datediff(day, apsa.due_date, current_date), 2) > 90 then 4 end as aging_bucket, case when round(datediff(day, aia.invoice_date, current_date), 2) >= 0 and round(datediff(day, aia.invoice_date, current_date), 2) <= 30 then 1 when round(datediff(day, aia.invoice_date, current_date), 2) > 30 and round(datediff(day, aia.invoice_date, current_date), 2) <= 60 then 2 when round(datediff(day, aia.invoice_date, current_date), 2) >= 61 and round(datediff(day, aia.invoice_date, current_date), 2) <= 90 then 3 when round(datediff(day, aia.invoice_date, current_date), 2) > 90 then 4 end as open_bucket, atl.name as payment_terms, apsa.payment_method_code as payment_method_code, round(datediff(day, apsa.due_date, current_date), 2) as past_due_days, aia.invoice_amount as invoice_amt, apsa.amount_remaining as invoice_due_amt, coalesce(gldr_ledger.conversion_rate, 1) * aia.invoice_amount as inv_ledger_amt, aia.amount_paid as inv_paid_amt, coalesce(gldr.conversion_rate, 1) * aia.invoice_amount as invoice_amt_usd, coalesce(gldr.conversion_rate, 1) * apsa.amount_remaining as invoice_due_amt_usd, coalesce(gldr.conversion_rate, 1) * aia.invoice_amount as inv_ledger_amt_usd, coalesce(gldr.conversion_rate, 1) as conv_rate_to_usd, 'corporate' as conv_rate_type, coalesce(gldr_ledger.conversion_rate, 1) * apsa.amount_remaining as inv_due_ledger_amt, aia.creation_date as creation_dt, aia.last_update_date as last_update_dt, aia.created_by as created_by, aia.last_updated_by as last_updated_by, concat(apsa.invoice_id::varchar, '~', apsa.payment_num::varchar) as integration_id, 1000 as datasource_num_id, 'n' as delete_flag, current_date as w_insert_dt, current_date as w_update_dt from ap_payment_schedules_all apsa left join ap_invoices_all aia on apsa.invoice_id = aia.invoice_id left join ap_terms_tl atl on aia.terms_id = atl.term_id and atl.language = 'us' left join gl_ledger gl on aia.set_of_books_id = gl.ledger_id left join hr_operating_units hou on aia.org_id = hou.organization_id left join xle_entity_profiles xep on aia.legal_entity_id = xep.legal_entity_id left join ap_suppliers aps on aia.vendor_id = aps.vendor_id left join ap_supplier_sites_all apssa on aia.vendor_site_id = apssa.vendor_site_id left join ( select from_currency, conversion_rate, conversion_date from gl_daily_rate where to_currency = 'usd' and conversion_type = 'corporate' ) gldr on aia.invoice_date::date = gldr.conversion_date::date and aia.invoice_currency_code = gldr.from_currency left join ( select from_currency, conversion_rate, conversion_date, to_currency from gl_daily_rate where conversion_type = 'corporate' ) gldr_ledger on aia.invoice_date::date = gldr_ledger.conversion_date::date and aia.invoice_currency_code = gldr_ledger.from_currency and gldr_ledger.to_currency = gl.currency_code where aia.cancelled_date is null and (coalesce(apsa.amount_remaining, 0) * coalesce(aia.exchange_rate, 1)) <> 0 and aia.payment_status_flag in ('n', 'p')
)

        select *
        from fact_ap_aging_a_stg;
