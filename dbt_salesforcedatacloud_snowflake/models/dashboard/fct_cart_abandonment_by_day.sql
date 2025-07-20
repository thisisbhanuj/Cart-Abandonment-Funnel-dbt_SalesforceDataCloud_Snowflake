WITH cart_activity AS (
  SELECT
    DATE("ssot__EngagementDateTm__c") AS cartDate,
    "ssot__SessionId__c",
    "ssot__WebCookieId__c"
  FROM {{ source('ssot', 'ssot__ShoppingCartEngagement__dlm') }}
)
SELECT
  cartDate,
  COUNT(DISTINCT "ssot__SessionId__c") AS totalSessions,
  COUNT(DISTINCT "ssot__WebCookieId__c") AS uniqueDevices
FROM cart_activity
GROUP BY cartDate
ORDER BY cartDate DESC
