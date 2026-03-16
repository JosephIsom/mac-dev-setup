#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_VSCODE_CORE_EXTENSIONS="$REPO_ROOT/scripts/modules/editors/vscode/vscode-core-vscode-extensions.txt"
TARGET_VSCODE_CORE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/vscode-core-vscode-extensions.txt"
VSCODE_EXTENSIONS_DIR="$HOME/.config/mac-dev-setup/vscode/extensions"

install_vscode_core_extensions_manifest() {
  install_managed_vscode_extensions_manifest "$REPO_VSCODE_CORE_EXTENSIONS" "$(basename "$TARGET_VSCODE_CORE_EXTENSIONS")" >/dev/null
}

warn_if_vscode_running() {
  if pgrep -x "Code" >/dev/null 2>&1; then
    log_warn "VS Code appears to be running."
    log_warn "Extension installation is more reliable with VS Code closed."
  fi
}

collect_extensions() {
  local manifest_path
  local extension_id
  local -a manifest_paths=()

  if [[ ! -d "$VSCODE_EXTENSIONS_DIR" ]]; then
    return 0
  fi

  while IFS= read -r manifest_path; do
    manifest_paths+=("$manifest_path")
  done < <(find "$VSCODE_EXTENSIONS_DIR" -type f -name '*-vscode-extensions.txt' | sort)

  for manifest_path in "${manifest_paths[@]}"; do
    while IFS= read -r extension_id; do
      if [[ -z "$extension_id" || "$extension_id" == \#* ]]; then
        continue
      fi

      printf '%s\n' "$extension_id"
    done < "$manifest_path"
  done | sort -u
}

install_extensions() {
  local ext

  log_info "Installing managed VS Code extensions..."
  while IFS= read -r ext; do
    [[ -n "$ext" ]] || continue
    run_in_login_zsh "code --install-extension $ext --force"
  done < <(collect_extensions)
}

verify_extensions() {
  local ext

  log_info "Verifying installed VS Code extensions..."
  while IFS= read -r ext; do
    [[ -n "$ext" ]] || continue
    if ! run_in_login_zsh "code --list-extensions | grep -Fx '$ext' >/dev/null"; then
      die "Expected VS Code extension not installed: $ext"
    fi
  done < <(collect_extensions)

  run_in_login_zsh 'code --list-extensions'
  log_success "Managed VS Code extensions installed."
}

main() {
  if ! run_in_login_zsh 'command -v code >/dev/null 2>&1'; then
    die "VS Code extensions require the code CLI. Enable INSTALL_EDITOR_VSCODE_CLI or fix code PATH setup."
  fi

  install_vscode_core_extensions_manifest
  warn_if_vscode_running
  install_extensions
  verify_extensions
}

main "$@"
