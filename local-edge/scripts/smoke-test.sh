#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

INCLUDE_KIND=false
INSECURE=false

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --include-kind)
        INCLUDE_KIND=true
        ;;
      --insecure)
        INSECURE=true
        ;;
      -h|--help)
        cat <<'EOF_HELP'
Usage:
  ./scripts/bootstrap-local-edge.sh smoke-test [--include-kind] [--insecure]
EOF_HELP
        exit 0
        ;;
      *)
        die "Unknown argument for smoke-test: $1"
        ;;
    esac
    shift
  done
}

curl_check() {
  local url="$1"
  local label="$2"

  if [[ "$INSECURE" == "true" ]]; then
    curl --fail --silent --show-error --insecure "$url" >/dev/null
  else
    curl --fail --silent --show-error "$url" >/dev/null
  fi

  log_success "$label"
}

main() {
  parse_args "$@"
  load_local_edge_environment
  require_local_edge_setup "smoke-test"

  validate_managed_caddyfile
  curl_check "https://local-edge.localhost/" "Caddy status site responds"

  if docker_daemon_reachable && docker compose -f "$LOCAL_EDGE_EXAMPLES_DIR/personal-apps/compose.yaml" ps --services --status running 2>/dev/null | grep -Fx "journal" >/dev/null; then
    curl_check "https://journal.localhost/" "Personal example journal.localhost responds"
    curl_check "https://notes.localhost/" "Personal example notes.localhost responds"
  else
    log_info "Personal examples are not running; skipping example hostname checks."
  fi

  if [[ "$INCLUDE_KIND" == "true" ]]; then
    kind_cluster_exists || die "The --include-kind smoke test requires the kind cluster."
    curl_check "https://work-demo.localhost/" "kind work-demo.localhost responds through Caddy"
  fi
}

main "$@"
