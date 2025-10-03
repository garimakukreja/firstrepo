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
    SELECT HAOU.ORGANIZATION_ID AS BU_ID, HAOU.NAME AS BU_NAME, HOI.ORG_INFORMATION_ID AS ORG_INFORMATION_ID, GL.NAME, HAOU.DATE_FROM AS EFFECTIVE_START_DT, HAOU.DATE_TO AS EFFECTIVE_END_DT, HAOUT.LANGUAGE, HAOU.CREATION_DATE AS CREATION_DT, HAOU.LAST_UPDATE_DATE AS LAST_UPDATE_DT, HAOU.CREATED_BY AS CREATED_BY, HAOU.LAST_UPDATED_BY AS LAST_UPDATED_BY, to_char(HAOU.ORGANIZATION_ID) AS INTEGRATION_ID, 1000 AS DATASOURCE_NUM_ID FROM hr_all_organization_units HAOU LEFT JOIN hr_organization_information HOI ON ( HAOU.ORGANIZATION_ID = HOI.ORGANIZATION_ID AND HOI.ORG_INFORMATION_CONTEXT = 'Operating Unit Information' ) LEFT JOIN gl_ledgers GL ON ( HOI.ORG_INFORMATION3 = GL.LEDGER_ID ) INNER JOIN hr_all_organization_units_tl HAOUT ON ( HAOU.ORGANIZATION_ID = HAOUT.ORGANIZATION_ID AND HAOUT.LANGUAGE = 'US' )
)
    select * from ct_business_unit_d_stg
