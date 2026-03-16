#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_SHELL_SCRIPTS_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/files/shell-scripts/shell-scripts-neovim.lua"
TARGET_SHELL_SCRIPTS_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/files_shell_scripts.lua"

install_shell_scripts_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_SHELL_SCRIPTS_NVIM_PLUGIN" "$(basename "$TARGET_SHELL_SCRIPTS_NVIM_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "shellcheck"
  brew_install_formula "shfmt"
  brew_install_formula "bash-language-server"

  command_exists shellcheck || die "shellcheck command not found after installation."
  command_exists shfmt || die "shfmt command not found after installation."
  command_exists bash-language-server || die "bash-language-server command not found after installation."

  log_info "Verifying shell script tooling..."
  shellcheck --version
  shfmt --version
  bash-language-server --version
  install_shell_scripts_neovim_plugin
  [[ -f "$TARGET_SHELL_SCRIPTS_NVIM_PLUGIN" ]] || die "Shell script Neovim plugin spec not found at $TARGET_SHELL_SCRIPTS_NVIM_PLUGIN"

  log_success "Shell script tooling installation verified."
}

main "$@"
