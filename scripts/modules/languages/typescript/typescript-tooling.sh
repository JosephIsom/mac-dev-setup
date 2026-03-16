#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_TYPESCRIPT_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/languages/typescript/typescript-neovim.lua"
TARGET_TYPESCRIPT_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/languages_typescript.lua"
REPO_TYPESCRIPT_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/languages/typescript/typescript-vscode-settings.jsonc"
TARGET_TYPESCRIPT_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/typescript-vscode-settings.jsonc"
REPO_TYPESCRIPT_VSCODE_TASKS_TEMPLATE="$REPO_ROOT/scripts/modules/languages/typescript/typescript-vscode-tasks.jsonc"
TARGET_TYPESCRIPT_VSCODE_TASKS_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/tasks/typescript-vscode-tasks.jsonc"
REPO_TYPESCRIPT_VSCODE_LAUNCH_TEMPLATE="$REPO_ROOT/scripts/modules/languages/typescript/typescript-vscode-launch.jsonc"
TARGET_TYPESCRIPT_VSCODE_LAUNCH_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/launch/typescript-vscode-launch.jsonc"

install_typescript_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_TYPESCRIPT_NVIM_PLUGIN" "$(basename "$TARGET_TYPESCRIPT_NVIM_PLUGIN")" >/dev/null
}

install_typescript_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_TYPESCRIPT_VSCODE_SETTINGS" "$(basename "$TARGET_TYPESCRIPT_VSCODE_SETTINGS")" >/dev/null
}

install_typescript_vscode_templates() {
  install_managed_vscode_template "$REPO_TYPESCRIPT_VSCODE_TASKS_TEMPLATE" "tasks" "$(basename "$TARGET_TYPESCRIPT_VSCODE_TASKS_TEMPLATE")" >/dev/null
  install_managed_vscode_template "$REPO_TYPESCRIPT_VSCODE_LAUNCH_TEMPLATE" "launch" "$(basename "$TARGET_TYPESCRIPT_VSCODE_LAUNCH_TEMPLATE")" >/dev/null
}

main() {
  if ! command_exists_in_zsh npm; then
    die "TypeScript language tooling requires npm in zsh. Enable the Node runtime modules or fix zsh runtime activation."
  fi

  # typescript-language-server depends on tsserver from the TypeScript package.
  npm_install_global_package 'typescript@latest'
  npm_install_global_package 'typescript-language-server@latest'

  log_info "Verifying TypeScript tooling in zsh..."
  run_in_login_zsh 'tsc --version'
  run_in_login_zsh 'typescript-language-server --version'
  install_typescript_vscode_settings
  install_typescript_vscode_templates
  install_typescript_neovim_plugin
  [[ -f "$TARGET_TYPESCRIPT_VSCODE_SETTINGS" ]] || die "TypeScript VS Code settings fragment not found at $TARGET_TYPESCRIPT_VSCODE_SETTINGS"
  [[ -f "$TARGET_TYPESCRIPT_VSCODE_TASKS_TEMPLATE" ]] || die "TypeScript VS Code tasks template not found at $TARGET_TYPESCRIPT_VSCODE_TASKS_TEMPLATE"
  [[ -f "$TARGET_TYPESCRIPT_VSCODE_LAUNCH_TEMPLATE" ]] || die "TypeScript VS Code launch template not found at $TARGET_TYPESCRIPT_VSCODE_LAUNCH_TEMPLATE"
  [[ -f "$TARGET_TYPESCRIPT_NVIM_PLUGIN" ]] || die "TypeScript Neovim plugin spec not found at $TARGET_TYPESCRIPT_NVIM_PLUGIN"

  log_success "TypeScript tooling installation verified."
}

main "$@"
