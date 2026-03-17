#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$REPO_ROOT/scripts/lib"
CONFIG_DIR="$REPO_ROOT/config"
MODULES_DIR="$REPO_ROOT/scripts/modules"
PREREQUISITES_DIR="$REPO_ROOT/scripts/prerequisites"
LOCAL_EDGE_SCRIPT_DIR="$REPO_ROOT/local-edge/scripts"

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

export REPO_ROOT LIB_DIR CONFIG_DIR MODULES_DIR PREREQUISITES_DIR LOCAL_EDGE_SCRIPT_DIR

print_help() {
  cat <<'EOF_HELP'
Usage:
  ./scripts/bootstrap-local-edge.sh setup [--trust-certs]
  ./scripts/bootstrap-local-edge.sh caddy <validate|start|reload|stop|trust-certs> [--sudo-service]
  ./scripts/bootstrap-local-edge.sh kind <create|delete|recreate|install-ingress-nginx>
  ./scripts/bootstrap-local-edge.sh examples <up|down>
  ./scripts/bootstrap-local-edge.sh smoke-test [--include-kind] [--insecure]
  ./scripts/bootstrap-local-edge.sh safe-reset

This entrypoint is intentionally separate from scripts/bootstrap.sh.
Run `./scripts/bootstrap-local-edge.sh setup` before any other local-edge subcommand.
EOF_HELP
}

run_local_edge_script() {
  local script_name="$1"
  shift

  local script_path="$LOCAL_EDGE_SCRIPT_DIR/$script_name"
  [[ -f "$script_path" ]] || die "Local edge script not found: $script_path"

  log_info "Running: local-edge/scripts/$script_name"
  bash "$script_path" "$@"
  log_success "Finished: local-edge/scripts/$script_name"
}

main() {
  local category="${1:-help}"
  shift || true

  case "$category" in
    help|-h|--help)
      print_help
      return 0
      ;;
  esac

  ensure_macos
  prepare_environment

  case "$category" in
    setup)
      run_local_edge_script "setup.sh" "$@"
      ;;
    caddy)
      local action="${1:-}"
      shift || true
      case "$action" in
        validate) run_local_edge_script "caddy-validate.sh" "$@" ;;
        start) run_local_edge_script "caddy-start.sh" "$@" ;;
        reload) run_local_edge_script "caddy-reload.sh" "$@" ;;
        stop) run_local_edge_script "caddy-stop.sh" "$@" ;;
        trust-certs) run_local_edge_script "caddy-trust.sh" "$@" ;;
        *) print_help; exit 1 ;;
      esac
      ;;
    kind)
      local action="${1:-}"
      shift || true
      case "$action" in
        create) run_local_edge_script "kind-create.sh" "$@" ;;
        delete) run_local_edge_script "kind-delete.sh" "$@" ;;
        recreate) run_local_edge_script "kind-recreate.sh" "$@" ;;
        install-ingress-nginx) run_local_edge_script "kind-install-ingress-nginx.sh" "$@" ;;
        *) print_help; exit 1 ;;
      esac
      ;;
    examples)
      local action="${1:-}"
      shift || true
      case "$action" in
        up) run_local_edge_script "examples-up.sh" "$@" ;;
        down) run_local_edge_script "examples-down.sh" "$@" ;;
        *) print_help; exit 1 ;;
      esac
      ;;
    smoke-test)
      run_local_edge_script "smoke-test.sh" "$@"
      ;;
    safe-reset)
      run_local_edge_script "safe-reset.sh" "$@"
      ;;
    *)
      print_help
      exit 1
      ;;
  esac
}

main "$@"
