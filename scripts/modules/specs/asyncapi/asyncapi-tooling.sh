#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_ASYNCAPI_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/specs/asyncapi/asyncapi-neovim.lua"
TARGET_ASYNCAPI_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/specs_asyncapi.lua"

install_asyncapi_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_ASYNCAPI_NVIM_PLUGIN" "$(basename "$TARGET_ASYNCAPI_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "asyncapi" "asyncapi" "AsyncAPI CLI" --version
  install_asyncapi_neovim_plugin
  [[ -f "$TARGET_ASYNCAPI_NVIM_PLUGIN" ]] || die "AsyncAPI Neovim plugin spec not found at $TARGET_ASYNCAPI_NVIM_PLUGIN"
}

main "$@"
