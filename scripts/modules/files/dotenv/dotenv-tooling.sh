#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_DOTENV_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/files/dotenv/dotenv-neovim.lua"
TARGET_DOTENV_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/files_dotenv.lua"

install_dotenv_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_DOTENV_NVIM_PLUGIN" "$(basename "$TARGET_DOTENV_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "dotenv-linter" "dotenv-linter" "dotenv-linter" --version
  install_dotenv_neovim_plugin
  [[ -f "$TARGET_DOTENV_NVIM_PLUGIN" ]] || die "dotenv Neovim plugin spec not found at $TARGET_DOTENV_NVIM_PLUGIN"
}

main "$@"
