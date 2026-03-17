#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

USE_SUDO_SERVICE=false

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --sudo-service)
        USE_SUDO_SERVICE=true
        ;;
      -h|--help)
        cat <<'EOF_HELP'
Usage:
  ./scripts/bootstrap-local-edge.sh caddy start [--sudo-service]
EOF_HELP
        exit 0
        ;;
      *)
        die "Unknown argument for caddy start: $1"
        ;;
    esac
    shift
  done
}

main() {
  parse_args "$@"
  load_local_edge_environment
  require_local_edge_setup "caddy start"
  validate_managed_caddyfile

  if caddy_service_running; then
    log_info "Caddy service is already started."
    return 0
  fi

  if [[ "$USE_SUDO_SERVICE" == "true" ]]; then
    log_warn "Starting the Homebrew Caddy service with sudo. This can help if your setup refuses privileged ports as a user service."
    sudo brew services start caddy
  else
    brew services start caddy
  fi

  log_success "Requested Homebrew to start Caddy."
  log_info "If you see privileged-port errors, retry with: ./scripts/bootstrap-local-edge.sh caddy start --sudo-service"
}

main "$@"
