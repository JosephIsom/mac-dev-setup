#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
SETTINGS_FILE="$VSCODE_USER_DIR/settings.json"
MANAGED_MARKER='"mac-dev-setup.managed": true'
REPO_VSCODE_CORE_SETTINGS="$REPO_ROOT/scripts/modules/editors/vscode/vscode-core-vscode-settings.jsonc"
TARGET_VSCODE_CORE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/vscode-core-vscode-settings.jsonc"
VSCODE_SETTINGS_DIR="$HOME/.config/mac-dev-setup/vscode/settings"

backup_if_unmanaged() {
  local backup_file="$SETTINGS_FILE.pre-mac-dev-setup.bak"

  [[ -f "$SETTINGS_FILE" ]] || return 0
  grep -Fq "$MANAGED_MARKER" "$SETTINGS_FILE" && return 0

  if [[ -f "$backup_file" ]]; then
    log_warn "VS Code settings are already backed up at $backup_file"
    return 0
  fi

  cp "$SETTINGS_FILE" "$backup_file"
  log_warn "Backed up existing unmanaged VS Code settings to $backup_file"
}

install_vscode_core_settings_fragment() {
  install_managed_vscode_settings_fragment "$REPO_VSCODE_CORE_SETTINGS" "$(basename "$TARGET_VSCODE_CORE_SETTINGS")" >/dev/null
}

collect_settings_fragments() {
  local fragment_path
  local -a fragment_paths=()

  [[ -f "$TARGET_VSCODE_CORE_SETTINGS" ]] && printf '%s\n' "$TARGET_VSCODE_CORE_SETTINGS"

  if [[ ! -d "$VSCODE_SETTINGS_DIR" ]]; then
    return 0
  fi

  while IFS= read -r fragment_path; do
    if [[ "$fragment_path" == "$TARGET_VSCODE_CORE_SETTINGS" ]]; then
      continue
    fi

    fragment_paths+=("$fragment_path")
  done < <(find "$VSCODE_SETTINGS_DIR" -type f -name '*-vscode-settings.jsonc' | sort)

  for fragment_path in "${fragment_paths[@]}"; do
    printf '%s\n' "$fragment_path"
  done
}

write_settings_file() {
  local -a fragment_paths=()
  local fragment_path

  command_exists jq || die "jq is required to merge managed VS Code settings."

  while IFS= read -r fragment_path; do
    [[ -n "$fragment_path" ]] || continue
    fragment_paths+=("$fragment_path")
  done < <(collect_settings_fragments)

  ((${#fragment_paths[@]} > 0)) || die "No managed VS Code settings fragments were found."

  jq -s 'reduce .[] as $item ({}; . * $item)' "${fragment_paths[@]}" > "$SETTINGS_FILE"
}

main() {
  mkdir -p "$VSCODE_USER_DIR"
  backup_if_unmanaged
  install_vscode_core_settings_fragment
  write_settings_file

  [[ -f "$SETTINGS_FILE" ]] || die "VS Code settings file was not created."

  log_success "Managed VS Code settings installed."
}

main "$@"
