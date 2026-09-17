# Terraform layer

This root module creates two VPC-native GKE Standard clusters, dedicated subnets and secondary ranges, Cloud NAT, Artifact Registry, Managed Prometheus, a BigQuery dataset and a filtered Cloud Logging sink.

## Why zonal clusters by default?

The assessment asks for two clusters but allows unavailable or costly features to be skipped. Zonal control planes keep the demonstration smaller. Set `primary_zone`/`secondary_zone` to regional architecture through a production module before enterprise use; regional clusters have a different node-count cost profile.

## Safe workflow

```bash
cp terraform.tfvars.example terraform.tfvars
terraform fmt -check -recursive
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Never commit `terraform.tfvars`, state, credentials, or plan files. A remote state backend with locking and versioning is recommended for team use.

