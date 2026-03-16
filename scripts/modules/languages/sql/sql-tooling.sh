#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_SQL_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/languages/sql/sql-neovim.lua"
TARGET_SQL_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/languages_sql.lua"
REPO_SQL_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/languages/sql/sql-vscode-extensions.txt"
TARGET_SQL_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/sql-vscode-extensions.txt"
REPO_SQL_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/languages/sql/sql-vscode-settings.jsonc"
TARGET_SQL_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/sql-vscode-settings.jsonc"

install_sql_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_SQL_NVIM_PLUGIN" "$(basename "$TARGET_SQL_NVIM_PLUGIN")" >/dev/null
}

install_sql_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_SQL_VSCODE_EXTENSIONS" "$(basename "$TARGET_SQL_VSCODE_EXTENSIONS")" >/dev/null
}

install_sql_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_SQL_VSCODE_SETTINGS" "$(basename "$TARGET_SQL_VSCODE_SETTINGS")" >/dev/null
}

main() {
  uv_install_global_tool 'sqlfluff@latest'
  npm_install_global_package 'sql-language-server@latest'

  log_info "Verifying SQL tooling in zsh..."
  run_in_login_zsh 'sqlfluff --version'
  run_in_login_zsh 'sql-language-server --help >/dev/null'
  install_sql_vscode_extensions
  install_sql_vscode_settings
  install_sql_neovim_plugin
  [[ -f "$TARGET_SQL_VSCODE_EXTENSIONS" ]] || die "SQL VS Code extensions manifest not found at $TARGET_SQL_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_SQL_VSCODE_SETTINGS" ]] || die "SQL VS Code settings fragment not found at $TARGET_SQL_VSCODE_SETTINGS"
  [[ -f "$TARGET_SQL_NVIM_PLUGIN" ]] || die "SQL Neovim plugin spec not found at $TARGET_SQL_NVIM_PLUGIN"

  log_success "SQL tooling installation verified."
}

main "$@"
