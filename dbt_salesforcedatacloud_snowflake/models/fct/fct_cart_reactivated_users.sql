{{ 
    config(
        materialized='incremental',
        unique_key='session_id'
    ) 
}}

-- If incremental, consider full-refresh to reset schema, if schema changed

WITH sessions_with_lag AS (
  SELECT
    party_id,
    session_id,
    session_starts,
    last_session_activity,
    start_date,
    end_date,
    ROW_NUMBER() OVER (
      PARTITION BY party_id 
      ORDER BY session_starts
    ) AS session_number,
    LAG(last_session_activity) OVER (
      PARTITION BY party_id 
      ORDER BY session_starts
    ) AS previous_session_end
  FROM 
    {{ ref('stg_cart_sessions_from_seed') }} -- FROM {{ ref('snapshot_cart_sessions') }}
  WHERE 
    is_deleted = 'False'
),

reactivated_sessions AS (
  SELECT *,
    DATEDIFF(DAY, previous_session_end, session_starts) AS gap_days
  FROM sessions_with_lag
  WHERE 
    session_number > 1 AND 
    DATEDIFF(DAY, previous_session_end, session_starts) > 30
)

SELECT 
  party_id,
  session_id,
  session_starts,
  last_session_activity,
  start_date,
  end_date,
  session_number,
  previous_session_end,
  gap_days,
  'reactivated' AS reactivation_flag
FROM reactivated_sessions
