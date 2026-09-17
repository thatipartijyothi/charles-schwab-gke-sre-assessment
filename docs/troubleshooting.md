# Troubleshooting scenario: service returned 503 after deployment

## Incident summary

After deploying Application A, the external IP existed but requests returned HTTP 503. Pods showed `Running`, so the initial symptom could have been mistaken for a load-balancer problem.

## Detection and impact

- Synthetic `curl` check failed with 503.
- Service had no Ready endpoints.
- Application A was unavailable; Application B remained healthy.

## Investigation

```bash
kubectl -n sre-demo get pods -l app=app-a
kubectl -n sre-demo get endpoints app-a
kubectl -n sre-demo describe pod -l app=app-a
kubectl -n sre-demo logs -l app=app-a --tail=50
kubectl -n sre-demo get deployment app-a -o yaml
```

The pods were running but `READY` was `0/1`. Events showed repeated readiness failures. The application exposes `/readyz` on container port `8080`, while the original probe targeted `/health` on port `80`. Because no pod passed readiness, Kubernetes correctly excluded every pod from the Service endpoints; the load balancer had no healthy backend and returned 503.

## Root cause

The readiness probe path and port did not match the application contract. A manifest copied from a different service was changed without an automated contract check.

## Resolution

```yaml
readinessProbe:
  httpGet:
    path: /readyz
    port: http
```

After applying the corrected manifest:

```bash
kubectl -n sre-demo rollout status deployment/app-a
kubectl -n sre-demo get pods,endpoints
curl -i "http://APP_A_EXTERNAL_IP/readyz"
```

All three pods became Ready, endpoints were populated, and the external request returned HTTP 200.

## Prevention

1. Test `/healthz`, `/readyz` and `/metrics` during the container CI job.
2. Validate manifests with server-side dry run in a disposable namespace.
3. Add a post-deployment gate that requires available replicas, non-empty endpoints and HTTP 200.
4. Alert on available/desired replica ratio and prolonged load-balancer backend unhealthiness.
5. Use named ports to avoid numeric-port drift.

## Evidence note

This is a reproducible scenario/runbook. If used as the submitted encountered issue, intentionally introduce the incorrect probe in the sandbox, capture authentic events before the fix, restore the correct manifest, and capture validation after the fix. Do not claim simulated evidence as an unplanned production incident.

