#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_FZF_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/fzf/fzf-plugin.zsh"
TARGET_ZSH_PLUGIN_DIR="$HOME/.zsh/plugins"
TARGET_FZF_PLUGIN="$TARGET_ZSH_PLUGIN_DIR/fzf-plugin.zsh"
REPO_FZF_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/fzf/neovim-fzf.lua"
TARGET_NVIM_PLUGIN_DIR="$HOME/.config/nvim/lua/mac_dev_setup/plugins"
TARGET_FZF_NVIM_PLUGIN="$TARGET_NVIM_PLUGIN_DIR/shell_cli_fzf.lua"

install_fzf_plugin() {
  install_managed_zsh_plugin "$REPO_FZF_PLUGIN" "$(basename "$TARGET_FZF_PLUGIN")" >/dev/null
}

install_fzf_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_FZF_NVIM_PLUGIN" "$(basename "$TARGET_FZF_NVIM_PLUGIN")" >/dev/null
}

verify_fzf() {
  brew_install_and_verify_command "fzf" "fzf" "fzf" --version

  [[ -f "$TARGET_FZF_PLUGIN" ]] || die "fzf plugin file not found at $TARGET_FZF_PLUGIN"
  [[ -f "$TARGET_FZF_NVIM_PLUGIN" ]] || die "fzf Neovim plugin spec not found at $TARGET_FZF_NVIM_PLUGIN"

  log_info "Verifying zsh fzf integration..."
  run_in_login_zsh 'command -v fzf >/dev/null 2>&1'
  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/fzf-plugin.zsh\" ]]"
  run_in_login_zsh '[[ -f /opt/homebrew/opt/fzf/shell/completion.zsh || -f /usr/local/opt/fzf/shell/completion.zsh ]]'

  log_success "fzf installation verified."
}

main() {
  install_fzf_plugin
  install_fzf_neovim_plugin
  verify_fzf
}

main "$@"
