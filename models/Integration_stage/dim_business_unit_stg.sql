{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['organization_unit', 'gl_ledger', 'organization_information', 'organization_unit_translation'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            organization_unit as (
    select * from {{ ref("organization_unit") }}
),
gl_ledger as (
    select * from {{ ref("gl_ledger") }}
),
organization_information as (
    select * from {{ ref("organization_information") }}
),
organization_unit_translation as (
    select * from {{ ref("organization_unit_translation") }}
),
dim_business_unit_stg as (
select haou.organization_id as bu_id, haou.name as bu_name, hoi.org_information_id as org_information_id, gl.name, haou.date_from as effective_start_dt, haou.date_to as effective_end_dt, haout.language, haou.creation_date as creation_dt, haou.last_update_date as last_update_dt, haou.created_by as created_by, haou.last_updated_by as last_updated_by, cast(haou.organization_id as varchar) as integration_id, 1000 as datasource_num_id from hr_all_organization_units as haou left join hr_organization_information as hoi on haou.organization_id = hoi.organization_id and hoi.org_information_context = 'operating unit information' left join gl_ledger as gl on hoi.org_information3 = gl.ledger_id inner join hr_all_organization_units_tl as haout on haou.organization_id = haout.organization_id and haout.language = 'us'
)

        select *
        from dim_business_unit_stg;
