#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_REGO_OPA_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/rego-opa/rego-opa-neovim.lua"
TARGET_REGO_OPA_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_rego_opa.lua"

install_rego_opa_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_REGO_OPA_NVIM_PLUGIN" "$(basename "$TARGET_REGO_OPA_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "opa"
  brew_install_formula "regal"

  command_exists opa || die "opa command not found after installation."
  command_exists regal || die "regal command not found after installation."

  log_info "Verifying Rego / OPA tooling..."
  opa version
  regal version
  install_rego_opa_neovim_plugin
  [[ -f "$TARGET_REGO_OPA_NVIM_PLUGIN" ]] || die "Rego / OPA Neovim plugin spec not found at $TARGET_REGO_OPA_NVIM_PLUGIN"

  log_success "Rego / OPA tooling installation verified."
}

main "$@"
