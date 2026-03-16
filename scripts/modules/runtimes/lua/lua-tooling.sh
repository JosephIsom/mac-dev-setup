#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_LUA_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/lua/lua-neovim.lua"
TARGET_LUA_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_lua.lua"
REPO_LUA_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/lua/lua-vscode-extensions.txt"
TARGET_LUA_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/lua-vscode-extensions.txt"

install_lua_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_LUA_NVIM_PLUGIN" "$(basename "$TARGET_LUA_NVIM_PLUGIN")" >/dev/null
}

install_lua_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_LUA_VSCODE_EXTENSIONS" "$(basename "$TARGET_LUA_VSCODE_EXTENSIONS")" >/dev/null
}

main() {
  brew_install_formula "lua-language-server"
  brew_install_formula "stylua"
  brew_install_formula "luacheck"

  command_exists lua-language-server || die "lua-language-server command not found after installation."
  command_exists stylua || die "stylua command not found after installation."
  command_exists luacheck || die "luacheck command not found after installation."

  log_info "Lua tooling versions:"
  lua-language-server --version
  stylua --version
  luacheck --version
  install_lua_vscode_extensions
  install_lua_neovim_plugin
  [[ -f "$TARGET_LUA_VSCODE_EXTENSIONS" ]] || die "Lua VS Code extensions manifest not found at $TARGET_LUA_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_LUA_NVIM_PLUGIN" ]] || die "Lua Neovim plugin spec not found at $TARGET_LUA_NVIM_PLUGIN"

  log_success "Lua tooling installation verified."
}

main "$@"
