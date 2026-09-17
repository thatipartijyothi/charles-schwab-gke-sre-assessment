#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${BASE_DIR}/terraform"

echo "This removes all infrastructure managed by this Terraform state."
terraform plan -destroy -out=destroy.tfplan
terraform apply destroy.tfplan

