#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

main() {
  load_local_edge_environment
  require_local_edge_setup "kind create"
  ensure_kind_ready_prereqs

  docker_daemon_reachable || die "Docker is not reachable. Start Colima or your preferred runtime before creating the kind cluster."

  if kind_cluster_exists; then
    log_info "kind cluster already exists: $LOCAL_EDGE_KIND_CLUSTER_NAME"
  else
    kind create cluster --name "$LOCAL_EDGE_KIND_CLUSTER_NAME" --config "$LOCAL_EDGE_MANAGED_KIND_CONFIG"
    log_success "Created kind cluster: $LOCAL_EDGE_KIND_CLUSTER_NAME"
  fi
  log_success "kind cluster is ready for local-edge workloads."
  log_info "Install an ingress controller next, for example:"
  log_info "  ./scripts/bootstrap-local-edge.sh kind install-ingress-nginx"
  log_info "The alternate ingress host ports are 127.0.0.1:$LOCAL_EDGE_KIND_INGRESS_HTTP_PORT and 127.0.0.1:$LOCAL_EDGE_KIND_INGRESS_HTTPS_PORT"
}

main "$@"
