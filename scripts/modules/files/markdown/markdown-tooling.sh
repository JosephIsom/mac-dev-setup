#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_MARKDOWN_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/files/markdown/markdown-neovim.lua"
TARGET_MARKDOWN_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/files_markdown.lua"
REPO_MARKDOWN_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/files/markdown/markdown-vscode-extensions.txt"
TARGET_MARKDOWN_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/markdown-vscode-extensions.txt"

install_markdown_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_MARKDOWN_NVIM_PLUGIN" "$(basename "$TARGET_MARKDOWN_NVIM_PLUGIN")" >/dev/null
}

install_markdown_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_MARKDOWN_VSCODE_EXTENSIONS" "$(basename "$TARGET_MARKDOWN_VSCODE_EXTENSIONS")" >/dev/null
}

main() {
  brew_install_formula "marksman"

  command_exists marksman || die "marksman command not found after installation."

  if ! command_exists_in_zsh npm; then
    die "markdownlint requires Node/npm in zsh. Enable the Node runtime modules or fix zsh runtime activation."
  fi

  npm_install_global_package 'markdownlint-cli@latest'
  command_exists_in_zsh markdownlint || die "markdownlint was installed but is not available in zsh."

  log_info "Verifying Markdown tooling..."
  marksman --version
  run_in_login_zsh 'markdownlint --version'
  install_markdown_vscode_extensions
  install_markdown_neovim_plugin
  [[ -f "$TARGET_MARKDOWN_VSCODE_EXTENSIONS" ]] || die "Markdown VS Code extensions manifest not found at $TARGET_MARKDOWN_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_MARKDOWN_NVIM_PLUGIN" ]] || die "Markdown Neovim plugin spec not found at $TARGET_MARKDOWN_NVIM_PLUGIN"

  log_success "Markdown tooling installation verified."
}

main "$@"
