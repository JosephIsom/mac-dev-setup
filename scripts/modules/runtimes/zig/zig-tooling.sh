#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_ZIG_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/zig/zig-neovim.lua"
TARGET_ZIG_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_zig.lua"

install_zig_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_ZIG_NVIM_PLUGIN" "$(basename "$TARGET_ZIG_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "zls"

  command_exists zls || die "zls command not found after installation."

  log_info "Verifying Zig tooling..."
  zls --version
  install_zig_neovim_plugin
  [[ -f "$TARGET_ZIG_NVIM_PLUGIN" ]] || die "Zig Neovim plugin spec not found at $TARGET_ZIG_NVIM_PLUGIN"

  log_success "Zig tooling verified."
}

main "$@"
