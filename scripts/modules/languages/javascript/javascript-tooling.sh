#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_JAVASCRIPT_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/languages/javascript/javascript-neovim.lua"
TARGET_JAVASCRIPT_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/languages_javascript.lua"
REPO_JAVASCRIPT_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/languages/javascript/javascript-vscode-extensions.txt"
TARGET_JAVASCRIPT_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/javascript-vscode-extensions.txt"
REPO_JAVASCRIPT_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/languages/javascript/javascript-vscode-settings.jsonc"
TARGET_JAVASCRIPT_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/javascript-vscode-settings.jsonc"
REPO_JAVASCRIPT_VSCODE_TASKS_TEMPLATE="$REPO_ROOT/scripts/modules/languages/javascript/javascript-vscode-tasks.jsonc"
TARGET_JAVASCRIPT_VSCODE_TASKS_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/tasks/javascript-vscode-tasks.jsonc"

install_javascript_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_JAVASCRIPT_NVIM_PLUGIN" "$(basename "$TARGET_JAVASCRIPT_NVIM_PLUGIN")" >/dev/null
}

install_javascript_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_JAVASCRIPT_VSCODE_EXTENSIONS" "$(basename "$TARGET_JAVASCRIPT_VSCODE_EXTENSIONS")" >/dev/null
}

install_javascript_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_JAVASCRIPT_VSCODE_SETTINGS" "$(basename "$TARGET_JAVASCRIPT_VSCODE_SETTINGS")" >/dev/null
}

install_javascript_vscode_templates() {
  install_managed_vscode_template "$REPO_JAVASCRIPT_VSCODE_TASKS_TEMPLATE" "tasks" "$(basename "$TARGET_JAVASCRIPT_VSCODE_TASKS_TEMPLATE")" >/dev/null
}

main() {
  npm_install_global_package 'eslint@latest'

  log_info "Verifying JavaScript tooling in zsh..."
  run_in_login_zsh 'eslint --version'
  install_javascript_vscode_extensions
  install_javascript_vscode_settings
  install_javascript_vscode_templates
  install_javascript_neovim_plugin
  [[ -f "$TARGET_JAVASCRIPT_VSCODE_EXTENSIONS" ]] || die "JavaScript VS Code extensions manifest not found at $TARGET_JAVASCRIPT_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_JAVASCRIPT_VSCODE_SETTINGS" ]] || die "JavaScript VS Code settings fragment not found at $TARGET_JAVASCRIPT_VSCODE_SETTINGS"
  [[ -f "$TARGET_JAVASCRIPT_VSCODE_TASKS_TEMPLATE" ]] || die "JavaScript VS Code tasks template not found at $TARGET_JAVASCRIPT_VSCODE_TASKS_TEMPLATE"
  [[ -f "$TARGET_JAVASCRIPT_NVIM_PLUGIN" ]] || die "JavaScript Neovim plugin spec not found at $TARGET_JAVASCRIPT_NVIM_PLUGIN"

  log_success "JavaScript tooling installation verified."
}

main "$@"
