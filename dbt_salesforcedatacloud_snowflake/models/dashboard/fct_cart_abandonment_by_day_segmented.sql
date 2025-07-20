WITH cart_sessions AS (
  SELECT
    "ssot__IndividualId__c",
    MAX("ssot__EngagementDateTm__c") AS lastCartActivity,
    COUNT(*) AS cartEventCount
  FROM {{ source('ssot', 'ssot__ShoppingCartEngagement__dlm') }}
  GROUP BY "ssot__IndividualId__c"
),
stale_sessions AS (
  SELECT
    cs."ssot__IndividualId__c" AS CART_SESSIONID,
    i."ssot__ExternalRecordId__c" AS EMAIL,
    i."ssot__PartyId__c" AS USER_SESSIONID,
    DATEDIFF(DAY, cs.lastCartActivity, CURRENT_DATE) AS daysSinceLastCart
  FROM cart_sessions cs
  LEFT JOIN {{ ref('stg_individual') }} i
    ON cs."ssot__IndividualId__c" = i."ssot__PartyId__c"
  WHERE i."ssot__ExternalRecordId__c" IS NOT NULL
    AND i."ssot__ExternalRecordId__c" <> ''
    AND DATEDIFF(MINUTE, cs.lastCartActivity, CURRENT_TIMESTAMP) > 7
)
SELECT
  *,
  {{ segment_cart_days('daysSinceLastCart') }} AS segmentLabel
FROM stale_sessions
WHERE daysSinceLastCart >= 1
ORDER BY daysSinceLastCart DESC
