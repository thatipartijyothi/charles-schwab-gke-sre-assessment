-- Detect Kubernetes container restarts recorded in GKE event/audit logs.
SELECT
  TIMESTAMP_TRUNC(timestamp, HOUR) AS hour,
  resource.labels.namespace_name AS namespace,
  resource.labels.pod_name AS pod,
  COUNT(*) AS restart_related_events
FROM `YOUR_PROJECT_ID.sre_observability.events_*`
WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY))
                        AND FORMAT_DATE('%Y%m%d', CURRENT_DATE())
  AND resource.labels.namespace_name = 'sre-demo'
  AND REGEXP_CONTAINS(LOWER(COALESCE(textPayload, JSON_VALUE(jsonPayload, '$.message'), '')), r'restart|back-off|crashloop')
GROUP BY hour, namespace, pod
ORDER BY hour DESC, restart_related_events DESC;

