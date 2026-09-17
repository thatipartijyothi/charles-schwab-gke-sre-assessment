-- Application errors by five-minute window.
-- Cloud Logging creates date-sharded tables; adjust the prefix if your log ID differs.
SELECT
  TIMESTAMP_TRUNC(timestamp, MINUTE, 5) AS window_start,
  resource.labels.container_name AS application,
  COUNTIF(severity IN ('ERROR', 'CRITICAL', 'ALERT', 'EMERGENCY')
          OR REGEXP_CONTAINS(COALESCE(textPayload, JSON_VALUE(jsonPayload, '$.message'), ''), r'status=5\d\d')) AS errors,
  COUNT(*) AS total_logs,
  SAFE_MULTIPLY(
    SAFE_DIVIDE(COUNTIF(severity IN ('ERROR', 'CRITICAL', 'ALERT', 'EMERGENCY')
      OR REGEXP_CONTAINS(COALESCE(textPayload, JSON_VALUE(jsonPayload, '$.message'), ''), r'status=5\d\d')), COUNT(*)),
    100
  ) AS error_percentage
FROM `YOUR_PROJECT_ID.sre_observability.stdout_*`
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY))
                        AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
  AND resource.labels.namespace_name = 'sre-demo'
GROUP BY window_start, application
ORDER BY window_start DESC, application;

