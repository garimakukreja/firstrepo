{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['xle_entity_profiles', 'xle_registrations', 'hz_location'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            xle_entity_profiles as (
    select * from {{ ref("xle_entity_profiles") }}
),
xle_registrations as (
    select * from {{ ref("xle_registrations") }}
),
hz_location as (
    select * from {{ ref("hz_location") }}
),
dim_legal_entity_stg as (
select xle_entity_profiles.legal_entity_id as legal_entity_id, xle_entity_profiles.legal_entity_identifier as legal_enity_num, xle_entity_profiles.name as legal_entity_name, hz_locations.location_id as location_id, hz_locations.country as country, hz_locations.address1 as address1, hz_locations.address2 as address2, hz_locations.address3 as address3, hz_locations.address4 as address4, hz_locations.city as city, hz_locations.postal_code as postal_code, hz_locations.state as state, hz_locations.province as province, hz_locations.county as county, xle_entity_profiles.last_updated_by as last_updated_by, xle_entity_profiles.creation_date as creation_dt, xle_entity_profiles.last_update_date as last_update_dt, xle_entity_profiles.created_by as created_by, cast(xle_entity_profiles.legal_entity_id as varchar) as integration_id, 1000 as datasource_num_id from staging.xle_entity_profiles xle_entity_profiles left join staging.xle_registrations xle_registrations on xle_entity_profiles.legal_entity_id = xle_registrations.source_id and xle_registrations.source_table = 'xle_entity_profiles' and xle_registrations.identifying_flag = 'y' left join staging.hz_locations hz_locations on xle_entity_profiles.geography_id = hz_locations.location_id where 1=1
)

        select *
        from dim_legal_entity_stg;
