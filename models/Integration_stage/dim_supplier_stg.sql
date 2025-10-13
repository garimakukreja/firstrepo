{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ap_supplier', 'ap_terms_tl', 'hz_party', 'hz_party_site', 'hz_location', 'hr_operating_units', 'ap_supplier_sites_all'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            ap_supplier as (
    select * from {{ ref("ap_supplier") }}
),
ap_terms_tl as (
    select * from {{ ref("ap_terms_tl") }}
),
hz_party as (
    select * from {{ ref("hz_party") }}
),
hz_party_site as (
    select * from {{ ref("hz_party_site") }}
),
hz_location as (
    select * from {{ ref("hz_location") }}
),
hr_operating_units as (
    select * from {{ ref("hr_operating_units") }}
),
ap_supplier_sites_all as (
    select * from {{ ref("ap_supplier_sites_all") }}
),
dim_supplier_stg as (
select ap_supplier_sites_all.vendor_id as supplier_id, ap_supplier_sites_all.vendor_site_id as supplier_site_num, ap_suppliers.segment1 as supplier_num, ap_suppliers.vendor_name as supplier_name, ap_supplier_sites_all.vendor_site_code as supplier_site_code, hz_party.party_id as sup_party_id, hz_party.party_number as party_num, hz_party.party_name as party_name, coalesce(hz_locations.address1, ap_supplier_sites_all.address_line1) as address1, coalesce(hz_locations.address2, ap_supplier_sites_all.address_line2) as address2, coalesce(hz_locations.address3, ap_supplier_sites_all.address_line3) as address3, coalesce(hz_locations.address4, ap_supplier_sites_all.address_line4) as address4, coalesce(hz_locations.postal_code, ap_supplier_sites_all.zip) as postal_code, coalesce(hz_locations.city, ap_supplier_sites_all.city) as city, coalesce(hz_locations.state, ap_supplier_sites_all.state) as state, coalesce(hz_locations.country, ap_supplier_sites_all.country) as country, ap_supplier_sites_all.email_address as email_address, to_char(ap_supplier_sites_all.inactive_date, 'dd-mon-yy') as site_inactive_dt, hz_party_site.party_site_number as party_site_num, hz_party_site.party_site_name as party_site_name, ap_supplier_sites_all.pay_group_lookup_code as pay_group_lookup_code, ap_suppliers.vendor_type_lookup_code as vendor_type_lookup_code, ap_suppliers.set_of_books_id as set_of_books_id, ap_suppliers.one_time_flag as one_time_flag, null as review_type, ap_suppliers.standard_industry_class as standard_industry_class, ap_suppliers.organization_type_lookup_code as organization_type_lookup_code, ap_suppliers.enabled_flag as enabled_flag, null as state_reportable_flag, null as federal_reportable_flag, ap_supplier_sites_all.invoice_currency_code as invoice_currency_code, ap_supplier_sites_all.payment_currency_code as payment_currency_code, ap_supplier_sites_all.vat_registration_num as vat_num, ap_terms_tl.name as payment_terms, ap_supplier_sites_all.creation_date as creation_dt, ap_supplier_sites_all.last_update_date as last_update_dt, ap_supplier_sites_all.created_by as created_by, ap_supplier_sites_all.last_updated_by as last_updated_by, coalesce(cast(ap_supplier_sites_all.vendor_id as varchar), '0') || '~' || coalesce(cast(ap_supplier_sites_all.vendor_site_id as varchar), '0') as integration_id, 1000 as datasource_num_id, case when ap_suppliers.enabled_flag = 'y' then 'active' else 'inactive' end as active_flag, 'n' as delete_flag, getdate() as w_insert_dt, getdate() as w_update_dt, hr_operating_units.name as operating_unit, ap_supplier_sites_all.payment_method_lookup_code as payment_method_lookup_code, ap_supplier_sites_all.terms_date_basis as terms_date_basis, ap_supplier_sites_all.purchasing_site_flag as purchasing_site_flag, ap_supplier_sites_all.rfq_only_site_flag as rfq_only_site_flag, ap_supplier_sites_all.pay_site_flag as pay_site_flag from staging.ap_supplier_sites_all ap_supplier_sites_all left join staging.ap_terms_tl ap_terms_tl on ap_terms_tl.term_id = ap_supplier_sites_all.terms_id and ap_terms_tl.language = 'us' inner join staging.ap_suppliers ap_suppliers on ap_supplier_sites_all.vendor_id = ap_suppliers.vendor_id inner join staging.hz_party hz_party on ap_suppliers.party_id = hz_party.party_id left join staging.hz_party_site hz_party_site on ap_supplier_sites_all.party_site_id = hz_party_site.party_site_id left join staging.hz_locations hz_locations on ap_supplier_sites_all.location_id = hz_locations.location_id left join staging.hr_operating_units hr_operating_units on ap_supplier_sites_all.org_id = hr_operating_units.organization_id union select sup.vendor_id as supplier_id, null as supplier_site_num, sup.segment1 as supplier_num, sup.vendor_name as supplier_name, null as supplier_site_code, party.party_id as sup_party_id, party.party_number as party_num, party.party_name as party_name, location.address1 as address1, location.address2 as address2, location.address3 as address3, location.address4 as address4, location.postal_code as postal_code, location.city as city, location.state as state, location.country as country, null as email_address, null as site_inactive_dt, null as party_site_num, null as party_site_name, sup.pay_group_lookup_code as pay_group_lookup_code, sup.vendor_type_lookup_code as vendor_type_lookup_code, sup.set_of_books_id as set_of_books_id, sup.one_time_flag as one_time_flag, null as review_type, sup.standard_industry_class as standard_industry_class, sup.organization_type_lookup_code as organization_type_lookup_code, sup.enabled_flag as enabled_flag, null as state_reportable_flag, null as federal_reportable_flag, sup.invoice_currency_code as invoice_currency_code, sup.payment_currency_code as payment_currency_code, sup.vat_registration_num as vat_num, apt.name as payment_terms, sup.creation_date as creation_dt, sup.last_update_date as last_update_dt, sup.created_by as created_by, sup.last_updated_by as last_updated_by, coalesce(cast(sup.vendor_id as varchar), '0') || '~0' as integration_id, 1000 as datasource_num_id, case when sup.enabled_flag = 'y' then 'active' else 'inactive' end as active_flag, 'n' as delete_flag, getdate() as w_insert_dt, getdate() as w_update_dt, null as operating_unit, null as payment_method_lookup_code, null as terms_date_basis, null as purchasing_site_flag, null as rfq_only_site_flag, null as pay_site_flag from staging.ap_suppliers sup left join staging.ap_terms_tl apt on apt.term_id = sup.terms_id and apt.language = 'us' inner join staging.hz_party party on sup.party_id = party.party_id left join staging.hz_locations location on sup.bill_to_location_id = location.location_id
)

        select *
        from dim_supplier_stg;
