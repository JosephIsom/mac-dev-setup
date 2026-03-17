#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

main() {
  load_local_edge_environment
  require_local_edge_setup "caddy reload"
  validate_managed_caddyfile
  caddy_service_running || die "Caddy is not running. Start it first with ./scripts/bootstrap-local-edge.sh caddy start."
  run_managed_caddy reload --config "$LOCAL_EDGE_MANAGED_CADDYFILE"
  log_success "Reloaded the running Caddy process with the managed local-edge config."
}

main "$@"
