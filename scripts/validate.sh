#!/usr/bin/env bash
set -euo pipefail

: "${PROJECT_ID:?Set PROJECT_ID to the target GCP project}"
PRIMARY_ZONE="${PRIMARY_ZONE:-us-central1-a}"
SECONDARY_ZONE="${SECONDARY_ZONE:-us-east1-b}"

validate_cluster() {
  local cluster="$1"
  local zone="$2"
  echo "Validating ${cluster}"
  gcloud container clusters get-credentials "${cluster}" --zone "${zone}" --project "${PROJECT_ID}" >/dev/null
  kubectl get nodes
  kubectl -n sre-demo get deployments,pods,services,hpa,podmonitoring
  kubectl -n sre-demo wait --for=condition=available deployment/app-a deployment/app-b --timeout=180s

  for service in app-a app-b; do
    local ip
    ip="$(kubectl -n sre-demo get service "${service}" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
    if [[ -z "${ip}" ]]; then
      echo "${service}: external IP is still pending"
      continue
    fi
    echo "${service}: http://${ip}"
    curl --fail --silent --show-error --max-time 10 "http://${ip}/"
    echo
  done
}

validate_cluster "sre-primary" "${PRIMARY_ZONE}"
validate_cluster "sre-secondary" "${SECONDARY_ZONE}"

