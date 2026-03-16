#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GITHUB_ACTIONS_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/github-actions/github-actions-neovim.lua"
TARGET_GITHUB_ACTIONS_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_github_actions.lua"
REPO_GITHUB_ACTIONS_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/specs/github-actions/github-actions-vscode-extensions.txt"
TARGET_GITHUB_ACTIONS_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/github-actions-vscode-extensions.txt"
REPO_GITHUB_ACTIONS_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/specs/github-actions/github-actions-vscode-settings.jsonc"
TARGET_GITHUB_ACTIONS_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/github-actions-vscode-settings.jsonc"

install_github_actions_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_GITHUB_ACTIONS_NVIM_PLUGIN" "$(basename "$TARGET_GITHUB_ACTIONS_NVIM_PLUGIN")" >/dev/null
}

install_github_actions_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_GITHUB_ACTIONS_VSCODE_EXTENSIONS" "$(basename "$TARGET_GITHUB_ACTIONS_VSCODE_EXTENSIONS")" >/dev/null
}

install_github_actions_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_GITHUB_ACTIONS_VSCODE_SETTINGS" "$(basename "$TARGET_GITHUB_ACTIONS_VSCODE_SETTINGS")" >/dev/null
}

main() {
  brew_install_and_verify_command "actionlint" "actionlint" "GitHub Actions linting" -version
  install_github_actions_vscode_extensions
  install_github_actions_vscode_settings
  install_github_actions_neovim_plugin
  [[ -f "$TARGET_GITHUB_ACTIONS_VSCODE_EXTENSIONS" ]] || die "GitHub Actions VS Code extensions manifest not found at $TARGET_GITHUB_ACTIONS_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_GITHUB_ACTIONS_VSCODE_SETTINGS" ]] || die "GitHub Actions VS Code settings fragment not found at $TARGET_GITHUB_ACTIONS_VSCODE_SETTINGS"
  [[ -f "$TARGET_GITHUB_ACTIONS_NVIM_PLUGIN" ]] || die "GitHub Actions Neovim plugin spec not found at $TARGET_GITHUB_ACTIONS_NVIM_PLUGIN"
}

main "$@"
