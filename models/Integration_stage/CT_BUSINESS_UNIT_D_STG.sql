{{ config(materialized='table') }}

    with
    hr_all_organization_units as (
    select * from {{ ref("hr_all_organization_units") }}
),
hr_organization_information as (
    select * from {{ ref("hr_organization_information") }}
),
gl_ledgers as (
    select * from {{ ref("gl_ledgers") }}
),
hr_all_organization_units_tl as (
    select * from {{ ref("hr_all_organization_units_tl") }}
),
ct_business_unit_d_stg as (
    SELECT HAOU.ORGANIZATION_ID AS bu_id, HAOU.NAME AS bu_name, HOI.ORG_INFORMATION_ID AS org_information_id, GL.NAME AS ledger_name, HAOU.DATE_FROM AS effective_start_dt, HAOU.DATE_TO AS effective_end_dt, HAOUT.LANGUAGE AS language, HAOU.CREATION_DATE AS creation_dt, HAOU.LAST_UPDATE_DATE AS last_update_dt, HAOU.CREATED_BY AS created_by, HAOU.LAST_UPDATED_BY AS last_updated_by, CAST(HAOU.ORGANIZATION_ID AS VARCHAR) AS integration_id, 1000 AS datasource_num_id FROM hr_all_organization_units AS HAOU LEFT JOIN hr_organization_information AS HOI ON HAOU.ORGANIZATION_ID = HOI.ORGANIZATION_ID AND HOI.ORG_INFORMATION_CONTEXT = 'Operating Unit Information' LEFT JOIN gl_ledgers AS GL ON HOI.ORG_INFORMATION3 = GL.LEDGER_ID INNER JOIN hr_all_organization_units_tl AS HAOUT ON HAOU.ORGANIZATION_ID = HAOUT.ORGANIZATION_ID AND HAOUT.LANGUAGE = 'US';
)
    select * from ct_business_unit_d_stg
