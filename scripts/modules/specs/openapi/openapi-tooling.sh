#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_OPENAPI_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/openapi/openapi-neovim.lua"
TARGET_OPENAPI_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_openapi.lua"

install_openapi_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_OPENAPI_NVIM_PLUGIN" "$(basename "$TARGET_OPENAPI_NVIM_PLUGIN")" >/dev/null
}

main() {
  npm_install_global_package '@redocly/cli@latest'

  log_info "Verifying OpenAPI tooling..."
  run_in_login_zsh 'redocly --version'
  install_openapi_neovim_plugin
  [[ -f "$TARGET_OPENAPI_NVIM_PLUGIN" ]] || die "OpenAPI Neovim plugin spec not found at $TARGET_OPENAPI_NVIM_PLUGIN"

  log_success "OpenAPI tooling installation verified."
}

main "$@"
