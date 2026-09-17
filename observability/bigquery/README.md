# BigQuery log analysis

Cloud Logging creates tables based on the routed log ID and uses date suffixes. First inspect the actual table names:

```bash
bq ls YOUR_PROJECT_ID:sre_observability
```

Replace `YOUR_PROJECT_ID` and, if necessary, the `stdout_*` or `events_*` prefixes in each query. The queries restrict `_TABLE_SUFFIX` to control scanned bytes and cost. Use the BigQuery console validator to preview estimated bytes before running.

Prometheus/Cloud Monitoring is the authoritative source for pod restarts and CPU/memory. BigQuery queries intentionally focus on log analysis; the restart query is useful only when matching Kubernetes event logs are routed.

