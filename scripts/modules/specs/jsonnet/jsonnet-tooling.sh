#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_JSONNET_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/jsonnet/jsonnet-neovim.lua"
TARGET_JSONNET_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_jsonnet.lua"

install_jsonnet_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_JSONNET_NVIM_PLUGIN" "$(basename "$TARGET_JSONNET_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "jsonnet"
  go_install_global_package 'github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest'

  command_exists jsonnet || die "jsonnet command not found after installation."

  log_info "Verifying Jsonnet tooling..."
  jsonnet --version
  run_in_login_zsh 'jb --version'
  install_jsonnet_neovim_plugin
  [[ -f "$TARGET_JSONNET_NVIM_PLUGIN" ]] || die "Jsonnet Neovim plugin spec not found at $TARGET_JSONNET_NVIM_PLUGIN"

  log_success "Jsonnet tooling installation verified."
}

main "$@"
