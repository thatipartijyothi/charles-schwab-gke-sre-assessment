# Logging pipeline

1. GKE workload logging collects container `stdout`/`stderr`.
2. The application emits JSON-formatted records with severity, app, cluster, timestamp and message.
3. `google_logging_project_sink.bigquery` selects only namespace `sre-demo` and routes records to `sre_observability`.
4. The sink's generated writer identity receives dataset-level `roles/bigquery.dataEditor`; it does not receive project-wide write permission.
5. Dataset table expiration defaults to 30 days to constrain assessment cost.

Verify routing:

```bash
gcloud logging read 'resource.type="k8s_container" AND resource.labels.namespace_name="sre-demo"' --limit=10 --format=json
bq ls "${PROJECT_ID}:sre_observability"
```

