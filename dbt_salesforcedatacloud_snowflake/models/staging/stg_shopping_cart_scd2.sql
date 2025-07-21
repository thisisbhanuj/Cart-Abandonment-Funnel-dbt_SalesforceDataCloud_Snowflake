-- dbt_salesforcedatacloud_snowflake\models\staging\stg_shopping_cart_scd2.sql
{{ 
    config(
        materialized='table'
    ) 
}}

WITH cart_sessions_scd AS (
  SELECT
    "ssot__IndividualId__c" AS SESSION_ID,
    MAX("ssot__EngagementDateTm__c") AS LAST_SESSION_ACTIVITY,
    MIN("ssot__EngagementDateTm__c") AS SESSION_STARTS,
    COUNT(*) AS EVENTS_COUNT
  FROM 
    {{ source('ssot', 'ssot__ShoppingCartEngagement__dlm') }}
  GROUP BY
    session_id
)
SELECT
    cart_sessions_scd.SESSION_ID,
    cart_sessions_scd.SESSION_STARTS,
    cart_sessions_scd.LAST_SESSION_ACTIVITY,
    INDIVIDUAL_DMO."ssot__ExternalRecordId__c" AS EMAIL,
    INDIVIDUAL_DMO."ssot__PartyId__c" AS PARTY_ID
FROM 
   cart_sessions_scd
LEFT JOIN 
    {{ source('ssot', 'ssot__Individual__dlm') }} AS INDIVIDUAL_DMO
    ON cart_sessions_scd.SESSION_ID = INDIVIDUAL_DMO."ssot__PartyId__c"
WHERE 
    INDIVIDUAL_DMO."ssot__ExternalRecordId__c" IS NOT NULL and 
    INDIVIDUAL_DMO."ssot__ExternalRecordId__c" <> ''
