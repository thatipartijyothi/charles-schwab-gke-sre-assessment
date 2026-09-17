# Submission evidence checklist


## Live endpoints

| Cluster | Application | URL | HTTP status | Verified UTC |
|---|---|---|---:|---|
| Primary | App A | `Confidential` | | |
| Primary | App B | `Confidential` | | |
| Secondary | App A | `Confidential` | | |
| Secondary | App B | `Confidential` | | |


## Validation commands

```bash
./scripts/validate.sh
gcloud logging read 'resource.type="k8s_container" AND resource.labels.namespace_name="sre-demo"' --limit=10
bq ls "${PROJECT_ID}:sre_observability"
```



