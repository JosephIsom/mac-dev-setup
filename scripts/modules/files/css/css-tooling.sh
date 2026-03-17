#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_CSS_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/files/css/css-neovim.lua"
TARGET_CSS_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/files_css.lua"

install_css_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_CSS_NVIM_PLUGIN" "$(basename "$TARGET_CSS_NVIM_PLUGIN")" >/dev/null
}

main() {
  npm_install_global_package 'stylelint@latest'
  npm_install_global_package 'vscode-langservers-extracted@latest'

  log_info "Verifying CSS tooling in zsh..."
  run_in_login_zsh 'stylelint --version'
  log_info "vscode-css-language-server available: $(run_in_login_zsh 'command -v vscode-css-language-server')"
  install_css_neovim_plugin
  [[ -f "$TARGET_CSS_NVIM_PLUGIN" ]] || die "CSS Neovim plugin spec not found at $TARGET_CSS_NVIM_PLUGIN"

  log_success "CSS tooling installation verified."
}

main "$@"
