#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

main() {
  load_local_edge_environment

  if ! bash "$SCRIPT_DIR/examples-down.sh"; then
    log_warn "Could not fully tear down the local-edge examples automatically."
  fi

  if ! bash "$SCRIPT_DIR/kind-delete.sh"; then
    log_warn "Could not delete the local-edge kind cluster automatically."
  fi

  if ! bash "$SCRIPT_DIR/caddy-stop.sh"; then
    log_warn "Could not stop the Caddy service automatically. If you started it with sudo, rerun ./scripts/bootstrap-local-edge.sh caddy stop --sudo-service after reset."
  fi

  restore_managed_caddy_link
  clear_local_edge_setup_state

  if [[ -d "$LOCAL_EDGE_STATE_DIR" ]]; then
    mkdir -p "$LOCAL_EDGE_ARCHIVE_ROOT"
    local archive_path="$LOCAL_EDGE_ARCHIVE_ROOT/$(date +%Y%m%d%H%M%S)"
    mv "$LOCAL_EDGE_STATE_DIR" "$archive_path"
    log_success "Archived managed local-edge state to $archive_path"
  else
    log_info "No managed local-edge state directory found at $LOCAL_EDGE_STATE_DIR"
  fi
}

main "$@"
