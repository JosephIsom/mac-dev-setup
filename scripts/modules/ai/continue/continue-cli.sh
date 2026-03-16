#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_CONTINUE_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/ai/continue/continue-vscode-extensions.txt"
TARGET_CONTINUE_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/continue-vscode-extensions.txt"
REPO_CONTINUE_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/ai/continue/continue-vscode-settings.jsonc"
TARGET_CONTINUE_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/continue-vscode-settings.jsonc"

install_continue_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_CONTINUE_VSCODE_EXTENSIONS" "$(basename "$TARGET_CONTINUE_VSCODE_EXTENSIONS")" >/dev/null
}

install_continue_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_CONTINUE_VSCODE_SETTINGS" "$(basename "$TARGET_CONTINUE_VSCODE_SETTINGS")" >/dev/null
}

main() {
  npm_install_global_package "@continuedev/cli@latest"

  if ! command_exists_in_zsh cn; then
    die "cn command not found in zsh after installation."
  fi

  log_info "Continue CLI version:"
  run_in_login_zsh 'cn --version || true'
  install_continue_vscode_extensions
  install_continue_vscode_settings
  [[ -f "$TARGET_CONTINUE_VSCODE_EXTENSIONS" ]] || die "Continue VS Code extensions manifest not found at $TARGET_CONTINUE_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_CONTINUE_VSCODE_SETTINGS" ]] || die "Continue VS Code settings fragment not found at $TARGET_CONTINUE_VSCODE_SETTINGS"
  log_success "Continue CLI installation verified."
}

main "$@"
