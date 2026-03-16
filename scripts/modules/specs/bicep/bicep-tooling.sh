#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_BICEP_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/bicep/bicep-neovim.lua"
TARGET_BICEP_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_bicep.lua"

install_bicep_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_BICEP_NVIM_PLUGIN" "$(basename "$TARGET_BICEP_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "bicep" "bicep" "Bicep" --version
  install_bicep_neovim_plugin
  [[ -f "$TARGET_BICEP_NVIM_PLUGIN" ]] || die "Bicep Neovim plugin spec not found at $TARGET_BICEP_NVIM_PLUGIN"
}

main "$@"
