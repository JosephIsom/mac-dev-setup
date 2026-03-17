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
  ./scripts/bootstrap-local-edge.sh caddy stop [--sudo-service]
EOF_HELP
        exit 0
        ;;
      *)
        die "Unknown argument for caddy stop: $1"
        ;;
    esac
    shift
  done
}

main() {
  parse_args "$@"
  load_local_edge_environment

  if ! caddy_service_running; then
    log_info "Caddy service is not running."
    return 0
  fi

  if [[ "$USE_SUDO_SERVICE" == "true" ]]; then
    sudo brew services stop caddy
  else
    brew services stop caddy
  fi

  log_success "Requested Homebrew to stop Caddy."
}

main "$@"
