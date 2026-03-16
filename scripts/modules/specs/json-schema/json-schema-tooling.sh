#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_JSON_SCHEMA_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/json-schema/json-schema-neovim.lua"
TARGET_JSON_SCHEMA_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_json_schema.lua"

install_json_schema_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_JSON_SCHEMA_NVIM_PLUGIN" "$(basename "$TARGET_JSON_SCHEMA_NVIM_PLUGIN")" >/dev/null
}

main() {
  npm_install_global_package 'ajv-cli@latest'

  log_info "Verifying JSON Schema tooling..."
  run_in_login_zsh 'ajv help >/dev/null'
  install_json_schema_neovim_plugin
  [[ -f "$TARGET_JSON_SCHEMA_NVIM_PLUGIN" ]] || die "JSON Schema Neovim plugin spec not found at $TARGET_JSON_SCHEMA_NVIM_PLUGIN"

  log_success "JSON Schema tooling installation verified."
}

main "$@"
