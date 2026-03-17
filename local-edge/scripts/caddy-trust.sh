#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

main() {
  load_local_edge_environment
  require_local_edge_setup "caddy trust-certs"

  log_warn "Trusting the local Caddy CA modifies your macOS trust store."
  log_warn "You will be prompted for admin approval."

  if [[ ! -f "$CADDY_ROOT_CERT" ]]; then
    log_info "Root CA not found yet at $CADDY_ROOT_CERT. Generating it by hitting local-edge.localhost once."
    curl --silent --show-error --insecure https://local-edge.localhost/ >/dev/null || true
  fi

  [[ -f "$CADDY_ROOT_CERT" ]] || die "Caddy root certificate was not generated yet. Run ./scripts/bootstrap-local-edge.sh caddy start, visit https://local-edge.localhost once, and rerun this command."

  sudo env \
    PATH="$PATH" \
    XDG_DATA_HOME="$CADDY_DATA_HOME" \
    HOME="$CADDY_DATA_HOME" \
    "$CADDY_BIN" trust

  log_success "Requested trust for the Caddy local CA rooted at $CADDY_ROOT_CERT"
}

main "$@"
