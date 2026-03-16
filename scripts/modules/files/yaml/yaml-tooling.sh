#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_YAML_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/files/yaml/yaml-neovim.lua"
TARGET_YAML_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/files_yaml.lua"
REPO_YAML_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/files/yaml/yaml-vscode-extensions.txt"
TARGET_YAML_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/yaml-vscode-extensions.txt"
REPO_YAML_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/files/yaml/yaml-vscode-settings.jsonc"
TARGET_YAML_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/yaml-vscode-settings.jsonc"

install_yaml_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_YAML_NVIM_PLUGIN" "$(basename "$TARGET_YAML_NVIM_PLUGIN")" >/dev/null
}

install_yaml_vscode_assets() {
  install_managed_vscode_extensions_manifest "$REPO_YAML_VSCODE_EXTENSIONS" "$(basename "$TARGET_YAML_VSCODE_EXTENSIONS")" >/dev/null
  install_managed_vscode_settings_fragment "$REPO_YAML_VSCODE_SETTINGS" "$(basename "$TARGET_YAML_VSCODE_SETTINGS")" >/dev/null
}

main() {
  brew_install_formula "yamllint"
  brew_install_formula "yaml-language-server"

  command_exists yamllint || die "yamllint command not found after installation."
  command_exists yaml-language-server || die "yaml-language-server command not found after installation."

  log_info "Verifying YAML tooling..."
  yamllint --version
  yaml-language-server --version
  install_yaml_vscode_assets
  install_yaml_neovim_plugin
  [[ -f "$TARGET_YAML_VSCODE_EXTENSIONS" ]] || die "YAML VS Code extensions manifest not found at $TARGET_YAML_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_YAML_VSCODE_SETTINGS" ]] || die "YAML VS Code settings fragment not found at $TARGET_YAML_VSCODE_SETTINGS"
  [[ -f "$TARGET_YAML_NVIM_PLUGIN" ]] || die "YAML Neovim plugin spec not found at $TARGET_YAML_NVIM_PLUGIN"

  log_success "YAML tooling installation verified."
}

main "$@"
