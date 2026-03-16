#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_LAZYGIT_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/lazygit/neovim-lazygit.lua"
TARGET_LAZYGIT_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/shell_cli_lazygit.lua"
REPO_LAZYGIT_CONFIG="$REPO_ROOT/scripts/modules/shell/cli/lazygit/assets/config.yml"
TARGET_LAZYGIT_CONFIG_DIR="$HOME/.config/lazygit"
TARGET_LAZYGIT_CONFIG="$TARGET_LAZYGIT_CONFIG_DIR/config.yml"

install_lazygit_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_LAZYGIT_NVIM_PLUGIN" "$(basename "$TARGET_LAZYGIT_NVIM_PLUGIN")" >/dev/null
}

install_lazygit_config() {
  [[ -f "$REPO_LAZYGIT_CONFIG" ]] || die "Missing repo-managed lazygit config: $REPO_LAZYGIT_CONFIG"
  mkdir -p "$TARGET_LAZYGIT_CONFIG_DIR"
  cp "$REPO_LAZYGIT_CONFIG" "$TARGET_LAZYGIT_CONFIG"
}

main() {
  brew_install_and_verify_command "lazygit" "lazygit" "lazygit" --version
  install_lazygit_neovim_plugin
  install_lazygit_config
  [[ -f "$TARGET_LAZYGIT_NVIM_PLUGIN" ]] || die "lazygit Neovim plugin spec not found at $TARGET_LAZYGIT_NVIM_PLUGIN"
  [[ -f "$TARGET_LAZYGIT_CONFIG" ]] || die "lazygit config not found at $TARGET_LAZYGIT_CONFIG"
}

main "$@"
