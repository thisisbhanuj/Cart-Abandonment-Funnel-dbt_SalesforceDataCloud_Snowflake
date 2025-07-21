-- Purpose: Use seed table like a snapshot for downstream processing
{{ config(materialized='view') }}

-- Execution Flow ->
-- dbt seed --select cart_sessions_snapshot_seed
-- dbt run --select fct_cart_reactivated_users

SELECT
    party_id,
    session_id,
    CAST(session_starts AS TIMESTAMP_LTZ) AS session_starts,
    CAST(last_session_activity AS TIMESTAMP_LTZ) AS last_session_activity,
    CAST(start_date AS TIMESTAMP_LTZ) AS start_date,
    CAST(end_date AS TIMESTAMP_LTZ) AS end_date,
    ROW_NUMBER() OVER (PARTITION BY party_id ORDER BY session_starts) AS session_number,
    CAST(
        (LAG(last_session_activity) OVER (PARTITION BY party_id ORDER BY session_starts)) AS TIMESTAMP_LTZ
    ) AS previous_session_end
FROM {{ ref('cart_sessions_snapshot_seed') }}
WHERE is_deleted = 'False'
