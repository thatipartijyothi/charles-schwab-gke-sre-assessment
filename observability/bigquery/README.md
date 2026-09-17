# BigQuery log analysis

Cloud Logging creates tables based on the routed log ID and uses date suffixes. First inspect the actual table names:

```bash
bq ls SRE_Assessment:sre_observability
```

Prometheus/Cloud Monitoring is the authoritative source for pod restarts and CPU/memory. BigQuery queries intentionally focus on log analysis; the restart query is useful only when matching Kubernetes event logs are routed.

