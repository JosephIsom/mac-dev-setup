#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_LAZYGIT_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/lazygit/neovim-lazygit.lua"
TARGET_LAZYGIT_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/shell_cli_lazygit.lua"

install_lazygit_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_LAZYGIT_NVIM_PLUGIN" "$(basename "$TARGET_LAZYGIT_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "lazygit" "lazygit" "lazygit" --version
  install_lazygit_neovim_plugin
  [[ -f "$TARGET_LAZYGIT_NVIM_PLUGIN" ]] || die "lazygit Neovim plugin spec not found at $TARGET_LAZYGIT_NVIM_PLUGIN"
}

main "$@"
