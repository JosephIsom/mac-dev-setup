#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

main() {
  load_local_edge_environment
  require_bootstrap_command "kind" "scripts/modules/containers/kind/kind.sh"

  if kind_cluster_exists; then
    kind delete cluster --name "$LOCAL_EDGE_KIND_CLUSTER_NAME"
    log_success "Deleted kind cluster: $LOCAL_EDGE_KIND_CLUSTER_NAME"
  else
    log_info "kind cluster not present: $LOCAL_EDGE_KIND_CLUSTER_NAME"
  fi
}

main "$@"
