#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GRAPHQL_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/languages/graphql/graphql-neovim.lua"
TARGET_GRAPHQL_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/languages_graphql.lua"
REPO_GRAPHQL_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/languages/graphql/graphql-vscode-extensions.txt"
TARGET_GRAPHQL_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/graphql-vscode-extensions.txt"
REPO_GRAPHQL_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/languages/graphql/graphql-vscode-settings.jsonc"
TARGET_GRAPHQL_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/graphql-vscode-settings.jsonc"

install_graphql_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_GRAPHQL_NVIM_PLUGIN" "$(basename "$TARGET_GRAPHQL_NVIM_PLUGIN")" >/dev/null
}

install_graphql_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_GRAPHQL_VSCODE_EXTENSIONS" "$(basename "$TARGET_GRAPHQL_VSCODE_EXTENSIONS")" >/dev/null
}

install_graphql_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_GRAPHQL_VSCODE_SETTINGS" "$(basename "$TARGET_GRAPHQL_VSCODE_SETTINGS")" >/dev/null
}

main() {
  npm_install_global_package 'graphql-language-service-cli@latest'

  log_info "Verifying GraphQL tooling..."
  run_in_login_zsh 'command -v graphql-lsp >/dev/null 2>&1 || command -v graphql-language-service-cli >/dev/null 2>&1'
  install_graphql_vscode_extensions
  install_graphql_vscode_settings
  install_graphql_neovim_plugin
  [[ -f "$TARGET_GRAPHQL_VSCODE_EXTENSIONS" ]] || die "GraphQL VS Code extensions manifest not found at $TARGET_GRAPHQL_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_GRAPHQL_VSCODE_SETTINGS" ]] || die "GraphQL VS Code settings fragment not found at $TARGET_GRAPHQL_VSCODE_SETTINGS"
  [[ -f "$TARGET_GRAPHQL_NVIM_PLUGIN" ]] || die "GraphQL Neovim plugin spec not found at $TARGET_GRAPHQL_NVIM_PLUGIN"

  log_success "GraphQL tooling installation verified."
}

main "$@"
