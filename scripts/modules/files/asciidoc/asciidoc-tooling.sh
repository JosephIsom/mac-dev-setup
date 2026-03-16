#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_ASCIIDOC_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/files/asciidoc/asciidoc-neovim.lua"
TARGET_ASCIIDOC_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/files_asciidoc.lua"

install_asciidoc_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_ASCIIDOC_NVIM_PLUGIN" "$(basename "$TARGET_ASCIIDOC_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "asciidoctor"
  brew_install_formula "vale"

  command_exists asciidoctor || die "asciidoctor command not found after installation."
  command_exists vale || die "vale command not found after installation."

  log_info "Verifying AsciiDoc tooling..."
  asciidoctor --version
  vale --version
  install_asciidoc_neovim_plugin
  [[ -f "$TARGET_ASCIIDOC_NVIM_PLUGIN" ]] || die "AsciiDoc Neovim plugin spec not found at $TARGET_ASCIIDOC_NVIM_PLUGIN"

  log_success "AsciiDoc tooling installation verified."
}

main "$@"
