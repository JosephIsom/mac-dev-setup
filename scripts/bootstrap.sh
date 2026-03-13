#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$REPO_ROOT/scripts/lib"
CONFIG_DIR="$REPO_ROOT/config"
MODULES_DIR="$REPO_ROOT/scripts/modules"

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"
# shellcheck disable=SC1091
source "$LIB_DIR/selection.sh"

export REPO_ROOT LIB_DIR CONFIG_DIR MODULES_DIR

main() {
  ensure_macos
  init_defaults
  parse_args "$@"
  resolve_selection
  export GIT_USER_NAME GIT_USER_EMAIL GITHUB_GIT_PROTOCOL
  export PYTHON_VERSION NODE_VERSION GO_VERSION JAVA_VERSION
  export COLIMA_CPU COLIMA_MEMORY COLIMA_DISK
  print_banner
  print_selection_summary

  run_selected_modules

  log_success "Bootstrap phase completed."
}

run_if_selected() {
  local selection_var="$1"
  local group="$2"
  local name="$3"
  local value="${!selection_var:-false}"

  if bool_is_true "$value"; then
    run_module "$group" "$name"
  else
    log_info "Skipping module: $group/$name ($selection_var=false)"
  fi
}

module_index_by_id() {
  local module_id="$1"
  local idx

  for idx in "${!REGISTRY_MODULE_IDS[@]}"; do
    if [[ "${REGISTRY_MODULE_IDS[$idx]}" == "$module_id" ]]; then
      printf '%s' "$idx"
      return 0
    fi
  done

  return 1
}

module_is_selected_by_index() {
  local idx="$1"
  local selection_var="${REGISTRY_MODULE_SELECTION_VARS[$idx]}"

  if [[ -z "$selection_var" ]]; then
    return 0
  fi

  bool_is_true "${!selection_var:-false}"
}

validate_selected_module_dependencies() {
  local idx dep_list dep dep_idx dep_selection_var dep_flag module_id

  for idx in "${!REGISTRY_MODULE_IDS[@]}"; do
    module_is_selected_by_index "$idx" || continue
    module_id="${REGISTRY_MODULE_IDS[$idx]}"
    dep_list="${REGISTRY_MODULE_DEPENDS_ON[$idx]}"
    [[ -n "$dep_list" ]] || continue

    IFS=',' read -r -a deps <<< "$dep_list"
    for dep in "${deps[@]}"; do
      [[ -n "$dep" ]] || continue
      dep_idx="$(module_index_by_id "$dep")" || die "Module $module_id depends on unknown module id: $dep"

      if ! module_is_selected_by_index "$dep_idx"; then
        dep_selection_var="${REGISTRY_MODULE_SELECTION_VARS[$dep_idx]}"
        if [[ -n "$dep_selection_var" ]]; then
          dep_flag="$(printf '%s' "${dep_selection_var#INSTALL_}" | tr '[:upper:]_' '[:lower:]-')"
          die "Module $module_id requires $dep. Enable dependency flag via --with-$dep_flag."
        fi
        die "Module $module_id requires always-on dependency $dep."
      fi
    done
  done
}

run_selected_modules() {
  local idx selection_var group script

  validate_selected_module_dependencies

  for idx in "${!REGISTRY_MODULE_IDS[@]}"; do
    selection_var="${REGISTRY_MODULE_SELECTION_VARS[$idx]}"
    group="${REGISTRY_MODULE_GROUPS[$idx]}"
    script="${REGISTRY_MODULE_SCRIPTS[$idx]}"

    if [[ -z "$selection_var" ]]; then
      run_module "$group" "$script"
      continue
    fi

    run_if_selected "$selection_var" "$group" "$script"
  done
}

main "$@"
