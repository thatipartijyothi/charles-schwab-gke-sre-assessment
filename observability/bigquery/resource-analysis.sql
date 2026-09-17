-- Log-volume trend by application and severity. CPU/memory are metrics and are queried in Grafana via PromQL.
SELECT
  TIMESTAMP_TRUNC(timestamp, HOUR) AS hour,
  resource.labels.container_name AS application,
  severity,
  COUNT(*) AS log_entries,
  ROUND(SUM(BYTE_LENGTH(COALESCE(textPayload, TO_JSON_STRING(jsonPayload)))) / 1024 / 1024, 2) AS approximate_mib
FROM `YOUR_PROJECT_ID.sre_observability.stdout_*`
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY))
                        AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
  AND resource.labels.namespace_name = 'sre-demo'
GROUP BY hour, application, severity
ORDER BY hour DESC, application;

