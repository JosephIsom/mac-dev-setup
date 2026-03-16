#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_CUE_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/cue/cue-neovim.lua"
TARGET_CUE_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_cue.lua"

install_cue_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_CUE_NVIM_PLUGIN" "$(basename "$TARGET_CUE_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "cue" "cue" "CUE" version
  cue lsp serve -h >/dev/null 2>&1
  install_cue_neovim_plugin
  [[ -f "$TARGET_CUE_NVIM_PLUGIN" ]] || die "CUE Neovim plugin spec not found at $TARGET_CUE_NVIM_PLUGIN"
}

main "$@"
