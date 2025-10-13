{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['organization_information', 'hz_party', 'org_organization_definitions', 'organization_unit', 'xle_entity_profiles', 'gl_ledger', 'gl_code_combination', 'hr_locations_all', 'fnd_lookup_value'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            organization_information as (
    select * from {{ ref("organization_information") }}
),
hz_party as (
    select * from {{ ref("hz_party") }}
),
org_organization_definitions as (
    select * from {{ ref("org_organization_definitions") }}
),
organization_unit as (
    select * from {{ ref("organization_unit") }}
),
xle_entity_profiles as (
    select * from {{ ref("xle_entity_profiles") }}
),
gl_ledger as (
    select * from {{ ref("gl_ledger") }}
),
gl_code_combination as (
    select * from {{ ref("gl_code_combination") }}
),
hr_locations_all as (
    select * from {{ ref("hr_locations_all") }}
),
fnd_lookup_value as (
    select * from {{ ref("fnd_lookup_value") }}
),
dim_org_stg as (
select ood.organization_id as org_id, ood.organization_name as org_name, ood.organization_code as org_num, hl.description as org_desc, hl.address_line_1 as st_address1, hl.address_line_2 as st_address2, hl.town_or_city as city, hl.country as county, hl.postal_code as postal_code, hl.region_1 as state_code, hl.region_2 as state_name, hl.region_3 as state_region, hl.country as country_code, flv_country.meaning as country_name, hl.attribute10 as country_region, hp.url as web_address, hl.telephone_number_1 as phone_num, hp.email_address as email_address, case when haou.type = 'div' then 'y' else 'n' end as divn_flag, case when haou.type = 'bu' then 'y' else 'n' end as bu_flag, case when haou.type = 'ou' then 'y' else 'n' end as operating_unit_flag, xep.name as legal_entity, case when ood.disable_date is null then 'active' else 'inactive' end as status, gcc.segment1 as cost_center_code, haou.date_from as effective_start_dt, haou.date_to as effective_end_dt, 'y' as current_flag, haou.creation_date as creation_dt, haou.last_update_date as last_update_dt, haou.created_by as created_by, haou.last_updated_by as last_updated_by, cast(ood.organization_id as varchar) as integration_id, 1000 as datasource_num_id from staging.org_organization_definitions ood inner join staging.hr_all_organization_units haou on haou.organization_id = ood.operating_unit inner join staging.xle_entity_profiles xep on xep.legal_entity_id = ood.legal_entity inner join staging.gl_ledgers gle on gle.ledger_id = ood.set_of_books_id inner join staging.gl_code_combinations gcc on gle.ret_earn_code_combination_id = gcc.code_combination_id left join staging.hr_locations_all hl on haou.location_id = hl.location_id left join staging.fnd_lookup_values flv_country on hl.country = flv_country.lookup_code and flv_country.lookup_type = 'ghr_us_postal_country_code' left join ( staging.hr_organization_information hoi inner join staging.hz_parties hp on hoi.party_id = hp.party_id and hoi.org_information_context = 'operating unit information' ) on hoi.organization_id = ood.organization_id
)

        select *
        from dim_org_stg;
