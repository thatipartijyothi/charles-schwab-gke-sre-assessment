-- Percentiles when structured application logs include latency_ms.
-- The sample app exposes Prometheus histograms; this query demonstrates the equivalent log analysis.
WITH latency AS (
  SELECT
    timestamp,
    resource.labels.container_name AS application,
    SAFE_CAST(JSON_VALUE(jsonPayload, '$.latency_ms') AS FLOAT64) AS latency_ms
  FROM `YOUR_PROJECT_ID.sre_observability.stdout_*`
  WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY))
                          AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
)
SELECT
  TIMESTAMP_TRUNC(timestamp, MINUTE, 5) AS window_start,
  application,
  APPROX_QUANTILES(latency_ms, 100)[OFFSET(50)] AS p50_ms,
  APPROX_QUANTILES(latency_ms, 100)[OFFSET(95)] AS p95_ms,
  APPROX_QUANTILES(latency_ms, 100)[OFFSET(99)] AS p99_ms
FROM latency
WHERE latency_ms IS NOT NULL
GROUP BY window_start, application
ORDER BY window_start DESC;

