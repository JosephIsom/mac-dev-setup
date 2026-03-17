#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

main() {
  load_local_edge_environment
  require_local_edge_setup "caddy validate"
  validate_managed_caddyfile
  log_success "Managed local-edge Caddy config is valid."
}

main "$@"
