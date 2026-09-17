# Submission evidence checklist

Fill this file only after deployment. Replace placeholders; do not commit credentials or sensitive project data.

## Live endpoints

| Cluster | Application | URL | HTTP status | Verified UTC |
|---|---|---|---:|---|
| Primary | App A | `TO_BE_ADDED` | | |
| Primary | App B | `TO_BE_ADDED` | | |
| Secondary | App A | `TO_BE_ADDED` | | |
| Secondary | App B | `TO_BE_ADDED` | | |

## Capture sequence

1. `01-clusters.png`: GKE cluster list showing both healthy clusters and regions/zones.
2. `02-app-a.png`: browser or `curl -i` response from App A.
3. `03-app-b.png`: browser or `curl -i` response from App B.
4. `04-workloads.png`: `kubectl -n sre-demo get deploy,pods,hpa` showing multiple Ready replicas.
5. `05-grafana-dashboard.png`: full dashboard with error rate, restarts, p50/p95/p99 latency, CPU and memory.
6. `06-bigquery-results.png`: at least one query plus returned rows and query timestamp.
7. `07-troubleshooting-before.png` and `08-troubleshooting-after.png`: failing readiness evidence and recovered endpoint.

Store images under `docs/screenshots/`. The directory ignores PNGs by default to prevent accidental evidence leakage; use `git add -f docs/screenshots/<file>.png` after reviewing each image.

## Validation commands

```bash
./scripts/validate.sh
gcloud logging read 'resource.type="k8s_container" AND resource.labels.namespace_name="sre-demo"' --limit=10
bq ls "${PROJECT_ID}:sre_observability"
```

## Final review

- [ ] No `terraform.tfvars`, state, keys, tokens or personal account email committed
- [ ] Endpoints work at submission time
- [ ] Screenshots are authentic, legible and redacted
- [ ] Dashboard time range contains generated traffic
- [ ] BigQuery query shows actual results
- [ ] `terraform validate` and manifest validation pass
- [ ] README links and repository name are correct

