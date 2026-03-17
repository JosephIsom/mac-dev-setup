#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

TRUST_CERTS=false

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --trust-certs)
        TRUST_CERTS=true
        ;;
      -h|--help)
        cat <<'EOF_HELP'
Usage:
  ./scripts/bootstrap-local-edge.sh setup [--trust-certs]
EOF_HELP
        exit 0
        ;;
      *)
        die "Unknown argument for local-edge setup: $1"
        ;;
    esac
    shift
  done
}

main() {
  parse_args "$@"
  load_local_edge_environment

  require_bootstrap_command "caddy" "scripts/modules/containers/caddy/caddy.sh"
  require_bootstrap_command "kind" "scripts/modules/containers/kind/kind.sh"
  require_bootstrap_command "kubectl" "scripts/modules/containers/kubectl/kubectl.sh"
  require_bootstrap_command "helm" "scripts/modules/containers/helm/helm.sh"
  require_bootstrap_command "docker" "scripts/modules/containers/docker/docker-cli.sh"

  ensure_managed_local_edge_files
  validate_managed_caddyfile
  mark_local_edge_setup_complete

  if [[ "$TRUST_CERTS" == "true" ]]; then
    bash "$SCRIPT_DIR/caddy-trust.sh"
  else
    log_info "Skipping local certificate trust. Run ./scripts/bootstrap-local-edge.sh caddy trust-certs when you want to trust the local CA."
  fi

  print_operator_next_steps
}

main "$@"
