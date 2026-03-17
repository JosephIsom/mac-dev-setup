#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_JSON_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/files/json/json-neovim.lua"
TARGET_JSON_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/files_json.lua"

install_json_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_JSON_NVIM_PLUGIN" "$(basename "$TARGET_JSON_NVIM_PLUGIN")" >/dev/null
}

main() {
  npm_install_global_package 'vscode-langservers-extracted@latest'

  log_info "Verifying JSON tooling in zsh..."
  log_info "vscode-json-language-server available: $(run_in_login_zsh 'command -v vscode-json-language-server')"
  install_json_neovim_plugin
  [[ -f "$TARGET_JSON_NVIM_PLUGIN" ]] || die "JSON Neovim plugin spec not found at $TARGET_JSON_NVIM_PLUGIN"

  log_success "JSON tooling installation verified."
}

main "$@"
