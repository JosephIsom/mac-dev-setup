#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_FORMATTING_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/files/formatting/formatting-neovim.lua"
TARGET_FORMATTING_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/files_formatting.lua"
REPO_FORMATTING_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/files/formatting/formatting-vscode-settings.jsonc"
TARGET_FORMATTING_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/formatting-vscode-settings.jsonc"

install_formatting_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_FORMATTING_NVIM_PLUGIN" "$(basename "$TARGET_FORMATTING_NVIM_PLUGIN")" >/dev/null
}

install_formatting_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_FORMATTING_VSCODE_SETTINGS" "$(basename "$TARGET_FORMATTING_VSCODE_SETTINGS")" >/dev/null
}

main() {
  npm_install_global_package 'prettier@latest'

  log_info "Verifying formatting tooling in zsh..."
  run_in_login_zsh 'prettier --version'
  install_formatting_vscode_settings
  install_formatting_neovim_plugin
  [[ -f "$TARGET_FORMATTING_VSCODE_SETTINGS" ]] || die "Formatting VS Code settings fragment not found at $TARGET_FORMATTING_VSCODE_SETTINGS"
  [[ -f "$TARGET_FORMATTING_NVIM_PLUGIN" ]] || die "Formatting Neovim plugin spec not found at $TARGET_FORMATTING_NVIM_PLUGIN"

  log_success "Formatting tooling installation verified."
}

main "$@"
