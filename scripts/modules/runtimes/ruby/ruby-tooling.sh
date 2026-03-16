#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_RUBY_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/ruby/ruby-neovim.lua"
TARGET_RUBY_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_ruby.lua"
REPO_RUBY_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/ruby/ruby-vscode-extensions.txt"
TARGET_RUBY_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/ruby-vscode-extensions.txt"
REPO_RUBY_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/runtimes/ruby/ruby-vscode-settings.jsonc"
TARGET_RUBY_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/ruby-vscode-settings.jsonc"

install_ruby_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_RUBY_NVIM_PLUGIN" "$(basename "$TARGET_RUBY_NVIM_PLUGIN")" >/dev/null
}

install_ruby_vscode_assets() {
  install_managed_vscode_extensions_manifest "$REPO_RUBY_VSCODE_EXTENSIONS" "$(basename "$TARGET_RUBY_VSCODE_EXTENSIONS")" >/dev/null
  install_managed_vscode_settings_fragment "$REPO_RUBY_VSCODE_SETTINGS" "$(basename "$TARGET_RUBY_VSCODE_SETTINGS")" >/dev/null
}

main() {
  gem_install_global_package 'bundler'
  gem_install_global_package 'rubocop'
  gem_install_global_package 'ruby-lsp'

  log_info "Verifying Ruby tooling..."
  run_in_login_zsh 'bundle --version'
  run_in_login_zsh 'rubocop --version'
  run_in_login_zsh 'ruby-lsp --version'
  install_ruby_vscode_assets
  install_ruby_neovim_plugin
  [[ -f "$TARGET_RUBY_VSCODE_EXTENSIONS" ]] || die "Ruby VS Code extensions manifest not found at $TARGET_RUBY_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_RUBY_VSCODE_SETTINGS" ]] || die "Ruby VS Code settings fragment not found at $TARGET_RUBY_VSCODE_SETTINGS"
  [[ -f "$TARGET_RUBY_NVIM_PLUGIN" ]] || die "Ruby Neovim plugin spec not found at $TARGET_RUBY_NVIM_PLUGIN"

  log_success "Ruby tooling installation verified."
}

main "$@"
