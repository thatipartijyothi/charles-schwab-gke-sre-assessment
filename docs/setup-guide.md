# Step-by-step setup guide

## 1. Access and prerequisites

Use a dedicated sandbox project with billing and quotas. For a least-privilege team model, separate deployer roles from runtime identity. Typical provisioning permissions include Compute Network Admin, Kubernetes Engine Admin, Service Account Admin/User, Artifact Registry Admin, Logs Configuration Writer, Monitoring Admin and BigQuery Admin. Narrow these further through custom roles in a governed organization.

Install and authenticate `gcloud`, `terraform`, `kubectl` and Docker. Never place service-account keys in this repository; use user ADC locally or Workload Identity Federation in CI.

## 2. Configure and provision

```bash
gcloud auth application-default login
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

If an organization policy blocks external IPs, public services or API enablement, document the constraint and use the approved equivalent rather than weakening the policy.

## 3. Build images

Run the image commands in the root README. Both containers run as UID 10001, use a read-only root filesystem in Kubernetes and expose health, readiness and metrics endpoints.

## 4. Deploy

```bash
export PROJECT_ID="YOUR_PROJECT_ID"
./scripts/deploy.sh
./scripts/validate.sh
```

The deploy script renders placeholders into a temporary directory; credentials and project-specific manifests are not committed.

## 5. Observability

Generate traffic:

```bash
APP_URL="http://EXTERNAL_IP" REQUESTS=200 ./scripts/generate-traffic.sh
```

Verify logs in Logs Explorer, wait for BigQuery tables, run the SQL under `observability/bigquery`, then import `observability/grafana/sre-dashboard.json`. Configure Grafana's Google Cloud Monitoring/Prometheus data source using an identity with monitoring read access.

## 6. Capture and clean up

Use `docs/evidence.md`. Redact project numbers, account emails, tokens and any organization-sensitive identifiers. After review:

```bash
./scripts/destroy.sh
```

