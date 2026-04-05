#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"
# shellcheck disable=SC1091
source "$REPO_ROOT/scripts/modules/runtimes/python/python-tooling-common.sh"

main() {
  PYTHON_NVIM_PLUGIN_SRC="$REPO_ROOT/scripts/modules/runtimes/python/python-neovim.lua"
  PYTHON_VSCODE_EXTENSIONS_SRC="$REPO_ROOT/scripts/modules/runtimes/python/python-vscode-extensions.txt"
  PYTHON_VSCODE_SETTINGS_SRC="$REPO_ROOT/scripts/modules/runtimes/python/python-vscode-settings.jsonc"
  PYTHON_VSCODE_WORKSPACE_TEMPLATE_SRC="$REPO_ROOT/scripts/modules/runtimes/python/python-vscode-workspace.code-workspace"

  install_python_common_tools
  brew_install_formula "pyright"

  command_exists pyright || die "pyright command not found after installation."
  command_exists pyright-langserver || die "pyright-langserver command not found after installation."

  log_info "Verifying Python tooling in zsh..."
  pyright --version
  log_info "Pyright language server available: $(command -v pyright-langserver)"
  verify_python_common_tools
  install_python_editor_assets
  verify_python_editor_assets

  log_success "Python linters installation verified."
}

main "$@"
