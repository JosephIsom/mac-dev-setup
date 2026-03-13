#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$REPO_ROOT/scripts/lib"
CONFIG_DIR="$REPO_ROOT/config"
MODULES_DIR="$REPO_ROOT/scripts/modules"
export REPO_ROOT LIB_DIR CONFIG_DIR MODULES_DIR

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"
# shellcheck disable=SC1091
source "$LIB_DIR/selection.sh"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

print_help() {
  cat <<'EOF_HELP'
Usage:
  ./scripts/verify.sh [options]

Options:
  --profile <name>         Profile to verify against (default: base)
  --with-<module>          Force-enable a module selection for verification
  --without-<module>       Force-disable a module selection for verification
  -h, --help               Show help
EOF_HELP
}

parse_verify_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --profile)
        PROFILE="${2:-}"
        [[ -n "$PROFILE" ]] || die "Missing value for --profile"
        shift 2
        ;;
      --with-*)
        WITH_FLAGS+=("${1#--with-}")
        shift
        ;;
      --without-*)
        WITHOUT_FLAGS+=("${1#--without-}")
        shift
        ;;
      -h|--help)
        print_help
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done
}

resolve_verify_selection() {
  init_defaults
  apply_profile_defaults_from_registry
  load_profile
  load_optional_user_config
  normalize_all_selection_vars
  normalize_user_config
  apply_flag_overrides
  normalize_all_selection_vars
}

pass() {
  printf '[PASS] %s\n' "$1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

warn() {
  printf '[WARN] %s\n' "$1"
  WARN_COUNT=$((WARN_COUNT + 1))
}

fail() {
  printf '[FAIL] %s\n' "$1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

skip() {
  printf '[SKIP] %s\n' "$1"
  SKIP_COUNT=$((SKIP_COUNT + 1))
}

is_selected() {
  local selection_var="$1"
  bool_is_true "${!selection_var:-false}"
}

record_by_severity() {
  local severity="$1"
  local label="$2"

  if [[ "$severity" == "warn" ]]; then
    warn "$label"
  else
    fail "$label"
  fi
}

command_available_in_zsh() {
  local cmd="$1"
  zsh -i -c "command -v $cmd >/dev/null 2>&1"
}

expand_home_path() {
  local path="$1"
  printf '%s' "${path//\$HOME/$HOME}"
}

run_check_cmd() {
  local cmd="$1"
  local label="$2"
  local severity="$3"

  if command_available_in_zsh "$cmd"; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_file() {
  local path="$1"
  local label="$2"
  local severity="$3"
  local expanded

  expanded="$(expand_home_path "$path")"

  if [[ -e "$expanded" ]]; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_dir() {
  local path="$1"
  local label="$2"
  local severity="$3"
  local expanded

  expanded="$(expand_home_path "$path")"

  if [[ -d "$expanded" ]]; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_colima_running() {
  local label="$1"
  local severity="$2"

  if zsh -i -c 'colima status 2>&1 | grep -qi running'; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_docker_reachable() {
  local label="$1"
  local severity="$2"

  if zsh -i -c 'docker info >/dev/null 2>&1'; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_cursor_cli() {
  local label="$1"
  local severity="$2"

  if zsh -i -c 'command -v cursor-agent >/dev/null 2>&1 || command -v cursor >/dev/null 2>&1'; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_registry_check() {
  local selection_var="$1"
  local kind="$2"
  local arg="$3"
  local label="$4"
  local severity="$5"

  if ! is_selected "$selection_var"; then
    skip "$label (not selected)"
    return 0
  fi

  case "$kind" in
    cmd)
      run_check_cmd "$arg" "$label" "$severity"
      ;;
    file)
      run_check_file "$arg" "$label" "$severity"
      ;;
    dir)
      run_check_dir "$arg" "$label" "$severity"
      ;;
    colima_running)
      run_check_colima_running "$label" "$severity"
      ;;
    docker_reachable)
      run_check_docker_reachable "$label" "$severity"
      ;;
    cursor_cli)
      run_check_cursor_cli "$label" "$severity"
      ;;
    *)
      fail "$label (unknown verify kind: $kind)"
      ;;
  esac
}

main() {
  local idx

  parse_verify_args "$@"
  resolve_verify_selection

  printf '\n'
  printf '========================================\n'
  printf 'mac-dev-setup verify\n'
  printf '========================================\n'
  printf '\n'

  for idx in "${!REGISTRY_VERIFY_LABELS[@]}"; do
    run_registry_check \
      "${REGISTRY_VERIFY_SELECTION_VARS[$idx]}" \
      "${REGISTRY_VERIFY_KINDS[$idx]}" \
      "${REGISTRY_VERIFY_ARGS[$idx]}" \
      "${REGISTRY_VERIFY_LABELS[$idx]}" \
      "${REGISTRY_VERIFY_SEVERITIES[$idx]}"
  done

  printf '\n'
  printf 'Summary: %s pass, %s warn, %s fail, %s skip\n' "$PASS_COUNT" "$WARN_COUNT" "$FAIL_COUNT" "$SKIP_COUNT"

  if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
