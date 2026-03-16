#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_PROTOBUF_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/languages/protobuf/protobuf-neovim.lua"
TARGET_PROTOBUF_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/languages_protobuf.lua"

install_protobuf_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_PROTOBUF_NVIM_PLUGIN" "$(basename "$TARGET_PROTOBUF_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "protobuf"
  brew_install_formula "buf"

  command_exists protoc || die "protoc command not found after installation."
  command_exists buf || die "buf command not found after installation."

  log_info "Verifying Protobuf tooling..."
  protoc --version
  buf --version
  install_protobuf_neovim_plugin
  [[ -f "$TARGET_PROTOBUF_NVIM_PLUGIN" ]] || die "Protobuf Neovim plugin spec not found at $TARGET_PROTOBUF_NVIM_PLUGIN"

  log_success "Protobuf tooling installation verified."
}

main "$@"
