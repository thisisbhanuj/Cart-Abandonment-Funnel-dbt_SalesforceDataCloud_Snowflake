WITH cart_sessions AS (
  SELECT
    "ssot__IndividualId__c",
    MAX("ssot__EngagementDateTm__c") AS lastCartActivity,
    COUNT(*) AS cartEventCount
  FROM {{ source('ssot', 'ssot__ShoppingCartEngagement__dlm') }}
  GROUP BY "ssot__IndividualId__c"
)
SELECT * FROM cart_sessions