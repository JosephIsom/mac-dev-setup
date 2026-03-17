#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

PERSONAL_COMPOSE_FILE="$LOCAL_EDGE_EXAMPLES_DIR/personal-apps/compose.yaml"
KIND_WORKLOAD_FILE="$LOCAL_EDGE_EXAMPLES_DIR/kind-workload/demo-app.yaml"

main() {
  load_local_edge_environment
  require_bootstrap_command "docker" "scripts/modules/containers/docker/docker-cli.sh"

  if docker_daemon_reachable; then
    docker compose -f "$PERSONAL_COMPOSE_FILE" down --remove-orphans
    log_success "Stopped the personal app examples."
  else
    log_warn "Docker is not reachable, so personal examples could not be stopped automatically."
  fi

  if kind_cluster_exists; then
    kubectl delete --context "$(kind_context_name)" --ignore-not-found -f "$KIND_WORKLOAD_FILE"
    log_success "Removed the kind work-app example."
  else
    log_info "kind cluster not present; no work-app example to remove."
  fi
}

main "$@"
