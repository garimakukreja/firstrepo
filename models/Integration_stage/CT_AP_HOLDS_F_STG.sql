{{ config(materialized = 'table') }} with 
ap_invoices_all as (
  select 
    * 
  from 
    {{ ref("ap_invoices_all") }}
), 
ap_holds_all as (
  select 
    * 
  from 
    {{ ref("ap_holds_all") }}
), 
ap_invoice_lines_all as (
  select 
    * 
  from 
    {{ ref("ap_invoice_lines_all") }}
), 
po_headers_all as (
  select 
    * 
  from 
    {{ ref("po_headers_all") }}
), 
hz_parties as (
  select 
    * 
  from 
    {{ ref("hz_parties") }}
), 
hz_party_sites as (
  select 
    * 
  from 
    {{ ref("hz_party_sites") }}
), 
ap_hold_codes as (
  select 
    * 
  from 
    {{ ref("ap_hold_codes") }}
), 
gl_ledgers as (
  select 
    * 
  from 
    {{ ref("gl_ledgers") }}
), 
ap_lookup_codes as (
  select 
    * 
  from 
    {{ ref("ap_lookup_codes") }}
), 
ct_ap_holds_f_stg as (
<<<<<<< HEAD
  SELECT 
    COALESCE(
      CAST(
        APHOLDS_F_JOIN_A.VENDOR_ID AS VARCHAR
      ), 
      '0'
    ) || '~' || COALESCE(
      CAST(
        APHOLDS_F_JOIN_A.VENDOR_SITE_ID AS VARCHAR
      ), 
      '0'
    ) AS supplier_id, 
    CAST(
      APHOLDS_F_JOIN_A.SET_OF_BOOKS_ID AS VARCHAR
    ) AS ledger_id, 
    CAST(
      APHOLDS_F_JOIN_A.ORG_ID_1 AS VARCHAR
    ) AS bu_id, 
    CAST(
      APHOLDS_F_JOIN_A.LEGAL_ENTITY_ID AS VARCHAR
    ) AS legal_entity_id, 
    CAST(
      COALESCE(
        APHOLDS_F_JOIN_A.ACCTS_PAY_CODE_COMBINATION_ID, 
        0
      ) AS VARCHAR
    ) AS glcc_id, 
    CAST(
      APHOLDS_F_JOIN_A.ORG_ID AS VARCHAR
    ) AS org_id, 
    CAST(
      TO_CHAR(
        APHOLDS_F_JOIN_A.INVOICE_DATE, 'YYYYMMDD'
      ) AS INT
    ) AS invoice_dt_id, 
    CAST(
      TO_CHAR(
        APHOLDS_F_JOIN_A.HOLD_DATE, 'YYYYMMDD'
      ) AS INT
    ) AS hold_dt_id, 
    CAST(
      TO_CHAR(
        APHOLDS_F_JOIN_A.GL_DATE, 'YYYYMMDD'
      ) AS INT
    ) AS accounting_dt_id, 
    CAST(
      COALESCE(
        APHOLDS_F_JOIN_A.INVENTORY_ITEM_ID, 
        0
      ) AS VARCHAR
    ) AS product_id, 
    NULL AS supplier_contact, 
    TO_CHAR(
      APHOLDS_F_JOIN_A.INVOICE_DATE, 'MON-YY'
    ) AS period_name, 
    EXTRACT(
      YEAR 
      FROM 
        invoice_date
    ) AS period_year, 
    EXTRACT(
      MONTH 
      FROM 
        invoice_date
    ) AS period_num, 
    APHOLDS_F_JOIN_A.NAME AS ledger_name, 
    APHOLDS_F_JOIN_A.INVOICE_ID, 
    APHOLDS_F_JOIN_A.INVOICE_NUM, 
    APHOLDS_F_JOIN_A.DESCRIPTION AS invoice_desc, 
    APHOLDS_F_JOIN_A.LINE_NUMBER AS invoice_line_num, 
    APHOLDS_F_JOIN_A.HOLD_LOOKUP_CODE, 
    APHOLDS_F_JOIN_A.HOLD_REASON, 
    APHOLDS_F_JOIN_A.HOLD_DATE AS hold_dt, 
    APHOLDS_F_JOIN_A.HOLD_DETAILS, 
    APHOLDS_F_JOIN_A.GL_DATE AS accounting_dt, 
    APHOLDS_F_JOIN_A.INVOICE_DATE AS invoice_dt, 
    APHOLDS_F_JOIN_A.RELEASE_LOOKUP_CODE, 
    APHOLDS_F_JOIN_A.RELEASE_REASON, 
    APHOLDS_F_JOIN_A.HOLD_TYPE_1 AS release_type, 
    APHOLDS_F_JOIN_A.SEGMENT1 AS identifying_po, 
    APHOLDS_F_JOIN_A.HOLD_TYPE, 
    APHOLDS_F_JOIN_A.SOURCE AS invoice_source_name, 
    APHOLDS_F_JOIN_A.APPROVAL_STATUS AS validation_status, 
    APHOLDS_F_JOIN_A.WFAPPROVAL_STATUS AS inv_wfapproval_status, 
    APHOLDS_F_JOIN_A.INVOICE_CURRENCY_CODE AS inv_curr_code, 
    APHOLDS_F_JOIN_A.CURRENCY_CODE AS ledger_curr_code, 
    APHOLDS_F_JOIN_A.DISPLAYED_FIELD AS hold_name, 
    APHOLDS_F_JOIN_A.REQUESTER_ID, 
    APHOLDS_F_JOIN_A.WF_STATUS AS hold_wfapproval_status, 
    APHOLDS_F_JOIN_A.DISPLAYED_FIELD_1 AS hold_release_name, 
    NULL AS hold_cnt, 
    APHOLDS_F_JOIN_A.INVOICE_AMOUNT, 
    APHOLDS_F_JOIN_A.INVOICE_AMOUNT AS invoice_amount_usd, 
    0 AS conv_rate_to_usd, 
    NULL AS conv_rate_type, 
    APHOLDS_F_JOIN_A.CREATION_DATE AS creation_dt, 
    APHOLDS_F_JOIN_A.LAST_UPDATE_DATE AS last_update_dt, 
    APHOLDS_F_JOIN_A.CREATED_BY, 
    APHOLDS_F_JOIN_A.LAST_UPDATED_BY, 
    CAST(
      APHOLDS_F_JOIN_A.INVOICE_ID AS VARCHAR
    ) || '~' || CAST(
      APHOLDS_F_JOIN_A.LINE_NUMBER AS VARCHAR
    ) || '~' || CAST(
      APHOLDS_F_JOIN_A.HOLD_ID AS VARCHAR
    ) || '~' || CAST(
      APHOLDS_F_JOIN_A.HOLD_REASON AS VARCHAR
    ) AS integration_id, 
    1000 AS datasource_num_id, 
    'N' AS delete_flag 
  FROM 
    (
      SELECT 
        INVOICES_ALL.INVOICE_ID, 
        INVOICES_ALL.INVOICE_NUM, 
        INVOICES_ALL.SET_OF_BOOKS_ID, 
        INVOICES_ALL.INVOICE_CURRENCY_CODE, 
        INVOICES_ALL.INVOICE_AMOUNT, 
        INVOICES_ALL.VENDOR_ID, 
        INVOICES_ALL.VENDOR_SITE_ID, 
        INVOICES_ALL.INVOICE_DATE, 
        INVOICES_ALL.SOURCE, 
        INVOICES_ALL.DESCRIPTION, 
        INVOICES_ALL.ACCTS_PAY_CODE_COMBINATION_ID, 
        INVOICES_ALL.APPROVAL_STATUS, 
        INVOICES_ALL.ORG_ID, 
        INVOICES_ALL.GL_DATE, 
        INVOICES_ALL.WFAPPROVAL_STATUS, 
        INVOICES_ALL.REQUESTER_ID, 
        INVOICES_ALL.LEGAL_ENTITY_ID, 
        HOLDS_ALL.HOLD_LOOKUP_CODE, 
        HOLDS_ALL.LAST_UPDATE_DATE, 
        HOLDS_ALL.LAST_UPDATED_BY, 
        HOLDS_ALL.HOLD_DATE, 
        HOLDS_ALL.HOLD_REASON, 
        HOLDS_ALL.RELEASE_LOOKUP_CODE, 
        HOLDS_ALL.RELEASE_REASON, 
        HOLDS_ALL.CREATION_DATE, 
        HOLDS_ALL.CREATED_BY, 
        HOLDS_ALL.ORG_ID AS ORG_ID_1, 
        HOLDS_ALL.HOLD_DETAILS, 
        HOLDS_ALL.HOLD_ID, 
        HOLDS_ALL.WF_STATUS, 
        INVOICE_LINES_ALL.LINE_NUMBER, 
        INVOICE_LINES_ALL.INVENTORY_ITEM_ID, 
        HOLD_CODES.HOLD_TYPE, 
        LOOKUP_CODES.DISPLAYED_FIELD, 
        GL_LEDGERS.NAME, 
        GL_LEDGERS.CURRENCY_CODE, 
        PO_HEADERS_ALL.SEGMENT1, 
        HOLD_CODES1.HOLD_TYPE AS HOLD_TYPE_1, 
        LOOKUP_CODES1.DISPLAYED_FIELD AS DISPLAYED_FIELD_1 
      FROM 
        ap_invoices_all INVOICES_ALL 
        JOIN ap_holds_all HOLDS_ALL ON HOLDS_ALL.INVOICE_ID = INVOICES_ALL.INVOICE_ID 
        JOIN ap_invoice_lines_all INVOICE_LINES_ALL ON INVOICE_LINES_ALL.INVOICE_ID = INVOICES_ALL.INVOICE_ID 
        LEFT JOIN po_headers_all PO_HEADERS_ALL ON INVOICES_ALL.PO_HEADER_ID = PO_HEADERS_ALL.PO_HEADER_ID 
        LEFT JOIN hz_parties HZ_PARTIES ON INVOICES_ALL.PARTY_ID = HZ_PARTIES.PARTY_ID 
        LEFT JOIN hz_party_sites HZ_PARTY_SITES ON INVOICES_ALL.PARTY_SITE_ID = HZ_PARTY_SITES.PARTY_SITE_ID 
        JOIN ap_hold_codes HOLD_CODES ON HOLDS_ALL.HOLD_LOOKUP_CODE = HOLD_CODES.HOLD_LOOKUP_CODE 
        LEFT JOIN ap_hold_codes HOLD_CODES1 ON HOLDS_ALL.RELEASE_LOOKUP_CODE = HOLD_CODES1.HOLD_LOOKUP_CODE 
        JOIN gl_ledgers GL_LEDGERS ON GL_LEDGERS.LEDGER_ID = INVOICES_ALL.SET_OF_BOOKS_ID 
        JOIN ap_lookup_codes LOOKUP_CODES ON HOLDS_ALL.HOLD_LOOKUP_CODE = LOOKUP_CODES.LOOKUP_CODE 
        AND LOOKUP_CODES.LOOKUP_TYPE = 'HOLD CODE' 
        LEFT JOIN ap_lookup_codes LOOKUP_CODES1 ON HOLDS_ALL.RELEASE_LOOKUP_CODE = LOOKUP_CODES1.LOOKUP_CODE 
        AND LOOKUP_CODES1.LOOKUP_TYPE = 'HOLD CODE' 
      WHERE 
        HOLDS_ALL.last_update_date >= CAST('$LAST_RUN_DATE$' AS DATE) 
        OR INVOICES_ALL.last_update_date >= CAST('$LAST_RUN_DATE$' AS DATE) 
        OR INVOICE_LINES_ALL.last_update_date >= CAST('$LAST_RUN_DATE$' AS DATE)
    ) APHOLDS_F_JOIN_A
) 
select 
  * 
from 
  ct_ap_holds_f_stg
=======
    SELECT CONCAT(COALESCE(apholds_f_join_a.vendor_id, '0'), '~', COALESCE(apholds_f_join_a.vendor_site_id, '0')) AS supplier_id, apholds_f_join_a.set_of_books_id AS ledger_id, apholds_f_join_a.org_id_1 AS bu_id, apholds_f_join_a.legal_entity_id AS legal_entity_id, COALESCE(apholds_f_join_a.accts_pay_code_combination_id, 0) AS glcc_id, apholds_f_join_a.org_id AS org_id, CAST(TO_CHAR(apholds_f_join_a.invoice_date, 'YYYYMMDD') AS INT) AS invoice_dt_id, CAST(TO_CHAR(apholds_f_join_a.hold_date, 'YYYYMMDD') AS INT) AS hold_dt_id, CAST(TO_CHAR(apholds_f_join_a.gl_date, 'YYYYMMDD') AS INT) AS accounting_dt_id, COALESCE(apholds_f_join_a.inventory_item_id, 0) AS product_id, NULL AS supplier_contact, TO_CHAR(apholds_f_join_a.invoice_date, 'MON-YY') AS period_name, EXTRACT(YEAR FROM invoice_date) AS period_year, EXTRACT(MONTH FROM invoice_date) AS period_num, apholds_f_join_a.name AS ledger_name, apholds_f_join_a.invoice_id, apholds_f_join_a.invoice_num, apholds_f_join_a.description AS invoice_desc, apholds_f_join_a.line_number AS invoice_line_num, apholds_f_join_a.hold_lookup_code, apholds_f_join_a.hold_reason, apholds_f_join_a.hold_date AS hold_dt, apholds_f_join_a.hold_details, apholds_f_join_a.gl_date AS accounting_dt, apholds_f_join_a.invoice_date AS invoice_dt, apholds_f_join_a.release_lookup_code, apholds_f_join_a.release_reason, apholds_f_join_a.hold_type_1 AS release_type, apholds_f_join_a.segment1 AS identifying_po, apholds_f_join_a.hold_type, apholds_f_join_a.source AS invoice_source_name, apholds_f_join_a.approval_status AS validation_status, apholds_f_join_a.wfapproval_status AS inv_wfapproval_status, apholds_f_join_a.invoice_currency_code AS inv_curr_code, apholds_f_join_a.currency_code AS ledger_curr_code, apholds_f_join_a.displayed_field AS hold_name, apholds_f_join_a.requester_id AS requester_id, apholds_f_join_a.wf_status AS hold_wfapproval_status, apholds_f_join_a.displayed_field_1 AS hold_release_name, 1 AS hold_cnt, apholds_f_join_a.invoice_amount, apholds_f_join_a.invoice_amount AS invoice_amount_usd, 0 AS conv_rate_to_usd, NULL AS conv_rate_type, apholds_f_join_a.creation_date AS creation_dt, apholds_f_join_a.last_update_date AS last_update_dt, apholds_f_join_a.created_by, apholds_f_join_a.last_updated_by, CONCAT( apholds_f_join_a.invoice_id, '~', apholds_f_join_a.line_number, '~', apholds_f_join_a.hold_id, '~', COALESCE(apholds_f_join_a.hold_reason, '') ) AS integration_id, 1000 AS datasource_num_id, 'N' AS delete_flag FROM ( SELECT invoices_all.invoice_id, invoices_all.invoice_num, invoices_all.set_of_books_id, invoices_all.invoice_currency_code, invoices_all.invoice_amount, invoices_all.vendor_id, invoices_all.vendor_site_id, invoices_all.invoice_date, invoices_all.source, invoices_all.description, invoices_all.accts_pay_code_combination_id, invoices_all.approval_status, invoices_all.org_id, invoices_all.gl_date, invoices_all.wfapproval_status, invoices_all.requester_id, invoices_all.legal_entity_id, holds_all.hold_lookup_code, holds_all.last_update_date, holds_all.last_updated_by, holds_all.hold_date, holds_all.hold_reason, holds_all.release_lookup_code, holds_all.release_reason, holds_all.creation_date, holds_all.created_by, holds_all.org_id AS org_id_1, holds_all.hold_details, holds_all.hold_id, holds_all.wf_status, invoice_lines_all.line_number, invoice_lines_all.inventory_item_id, hold_codes.hold_type, lookup_codes.displayed_field, gl_ledgers.name, gl_ledgers.currency_code, po_headers_all.segment1, hold_codes1.hold_type AS hold_type_1, lookup_codes1.displayed_field AS displayed_field_1 FROM ap_invoices_all invoices_all JOIN ap_holds_all holds_all ON holds_all.invoice_id = invoices_all.invoice_id JOIN ap_invoice_lines_all invoice_lines_all ON invoice_lines_all.invoice_id = invoices_all.invoice_id LEFT JOIN po_headers_all po_headers_all ON invoices_all.po_header_id = po_headers_all.po_header_id LEFT JOIN hz_parties hz_parties ON invoices_all.party_id = hz_parties.party_id LEFT JOIN hz_party_sites hz_party_sites ON invoices_all.party_site_id = hz_party_sites.party_site_id JOIN ap_hold_codes hold_codes ON holds_all.hold_lookup_code = hold_codes.hold_lookup_code LEFT JOIN ap_hold_codes hold_codes1 ON holds_all.release_lookup_code = hold_codes1.hold_lookup_code JOIN gl_ledgers gl_ledgers ON gl_ledgers.ledger_id = invoices_all.set_of_books_id JOIN ap_lookup_codes lookup_codes ON holds_all.hold_lookup_code = lookup_codes.lookup_code AND lookup_codes.lookup_type = 'HOLD CODE' LEFT JOIN ap_lookup_codes lookup_codes1 ON holds_all.release_lookup_code = lookup_codes1.lookup_code AND lookup_codes1.lookup_type = 'HOLD CODE' --WHERE ( holds_all.last_update_date >= CAST('$LAST_RUN_DATE$' AS DATE) OR invoices_all.last_update_date >= CAST('$LAST_RUN_DATE$' AS DATE) OR invoice_lines_all.last_update_date >= CAST('$LAST_RUN_DATE$' AS DATE) ) ) apholds_f_join_a
)
    select * from ct_ap_holds_f_stg;
>>>>>>> ee045b83bd6fdabc7688ce2a75b656969626f8d5
