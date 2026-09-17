#!/usr/bin/env bash
set -euo pipefail

: "${PROJECT_ID:?Set PROJECT_ID to the target GCP project}"
PRIMARY_ZONE="${PRIMARY_ZONE:-us-central1-a}"
SECONDARY_ZONE="${SECONDARY_ZONE:-us-east1-b}"
REGISTRY_REGION="${REGISTRY_REGION:-us-central1}"
IMAGE_TAG="${IMAGE_TAG:-1.0.0}"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

deploy_cluster() {
  local cluster="$1"
  local zone="$2"
  local temp_dir
  temp_dir="$(mktemp -d)"
  trap 'rm -rf "${temp_dir}"' RETURN

  gcloud container clusters get-credentials "${cluster}" --zone "${zone}" --project "${PROJECT_ID}"
  cp -R "${BASE_DIR}/kubernetes/base/." "${temp_dir}/"
  find "${temp_dir}" -type f -name '*.yaml' -exec sed -i.bak \
    -e "s|PROJECT_ID|${PROJECT_ID}|g" \
    -e "s|APP_A_IMAGE|${REGISTRY_REGION}-docker.pkg.dev/${PROJECT_ID}/sre-apps/app-a:${IMAGE_TAG}|g" \
    -e "s|APP_B_IMAGE|${REGISTRY_REGION}-docker.pkg.dev/${PROJECT_ID}/sre-apps/app-b:${IMAGE_TAG}|g" \
    -e "s|CLUSTER_NAME_VALUE|${cluster}|g" {} +
  find "${temp_dir}" -type f -name '*.bak' -delete
  kubectl apply -k "${temp_dir}"
  kubectl -n sre-demo rollout status deployment/app-a --timeout=5m
  kubectl -n sre-demo rollout status deployment/app-b --timeout=5m
}

deploy_cluster "sre-primary" "${PRIMARY_ZONE}"
deploy_cluster "sre-secondary" "${SECONDARY_ZONE}"

echo "Deployment completed in both clusters. Run scripts/validate.sh."

