-- ******************************************************************************************
-- What We Implemented?
-- ********************
-- A cohort-based fact model that tracks reactivated users on a monthly basis.
-- Specifically, we:
--  -   Pulled users from a reactivated_user_sessions_snapshot table (i.e., users who came back after a break).
--  -   Bucketed their session into a cohort month (2025-07-01, etc.) using DATE_TRUNC('month', session_starts).
--  -   Captured relevant fields: party_id, session_id, session_start, gap_days (i.e., number of days they were inactive before this session).
--  -   (Optionally) enriched it with dim_users to bring in metadata like region, channel, etc.

-- Real-Life Use Case
-- ******************
-- Imagine marketing runs a campaign in July targeting users dormant for 30+ days.
-- We can now:
--  -   See how many returned in July (cohort_month)
--  -   Filter by gap_days to segment short vs long reactivation windows
--  -   Slice by region, channel or campaign_id if joined

-- What You Can Build on Top
-- *************************
--  -   Heatmaps of reactivations by month & region
--  -   Alerting if certain segments stop reactivating
--  -   LTV by reactivation cohort
-- ******************************************************************************************
{{ 
    config(
        materialized = 'table',
        tags = ['cohort', 'reactivation', 'monthly']
    ) 
}}

{% set cohort_month_start = "date_trunc('month', current_timestamp())" %}
{% set cohort_month_end = "dateadd('month', 1, " ~ cohort_month_start ~ ")" %}

WITH reactivations AS (
  SELECT
    party_id,
    session_id,
    session_starts,
    date_trunc('month', session_starts) AS cohort_month,
    gap_days
  FROM {{ ref('reactivated_user_sessions_snapshot') }}
  WHERE session_starts >= {{ cohort_month_start }}
    AND session_starts < {{ cohort_month_end }}
)

SELECT
  r.party_id,
  r.session_id,
  r.session_starts,
  r.cohort_month,
  r.gap_days
FROM reactivations r
