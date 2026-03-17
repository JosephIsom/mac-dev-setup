#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

PERSONAL_COMPOSE_FILE="$LOCAL_EDGE_EXAMPLES_DIR/personal-apps/compose.yaml"
KIND_WORKLOAD_FILE="$LOCAL_EDGE_EXAMPLES_DIR/kind-workload/demo-app.yaml"

main() {
  load_local_edge_environment
  require_local_edge_setup "examples up"
  require_bootstrap_command "docker" "scripts/modules/containers/docker/docker-cli.sh"

  docker_daemon_reachable || die "Docker is not reachable. Start Colima or your preferred runtime before bringing up the examples."

  docker compose -f "$PERSONAL_COMPOSE_FILE" up -d
  log_success "Started the personal app examples."

  if kind_cluster_exists; then
    kubectl apply --context "$(kind_context_name)" -f "$KIND_WORKLOAD_FILE"
    log_success "Applied the kind work-app example."
  else
    log_warn "kind cluster not found. Personal examples are up, but the work-app example was skipped."
    log_info "Run ./scripts/bootstrap-local-edge.sh kind create and then ./scripts/bootstrap-local-edge.sh examples up again."
  fi
}

main "$@"
