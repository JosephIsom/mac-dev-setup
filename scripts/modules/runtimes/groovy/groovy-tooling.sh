#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GROOVY_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/groovy/groovy-neovim.lua"
TARGET_GROOVY_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_groovy.lua"

install_groovy_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_GROOVY_NVIM_PLUGIN" "$(basename "$TARGET_GROOVY_NVIM_PLUGIN")" >/dev/null
}

main() {
  npm_install_global_package 'npm-groovy-lint@latest'

  log_info "Verifying Groovy tooling in zsh..."
  run_in_login_zsh 'npm-groovy-lint --version'
  run_in_login_zsh 'npm-groovy-lint --help >/dev/null'
  install_groovy_neovim_plugin
  [[ -f "$TARGET_GROOVY_NVIM_PLUGIN" ]] || die "Groovy Neovim plugin spec not found at $TARGET_GROOVY_NVIM_PLUGIN"

  log_success "Groovy formatting and linting tooling verified."
}

main "$@"
