#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"
# shellcheck disable=SC1091
source "$REPO_ROOT/scripts/modules/runtimes/python/python-tooling-common.sh"

main() {
  PYTHON_NVIM_PLUGIN_SRC="$REPO_ROOT/scripts/modules/runtimes/python/python-ty-neovim.lua"
  PYTHON_VSCODE_EXTENSIONS_SRC="$REPO_ROOT/scripts/modules/runtimes/python/python-ty-vscode-extensions.txt"
  PYTHON_VSCODE_SETTINGS_SRC="$REPO_ROOT/scripts/modules/runtimes/python/python-ty-vscode-settings.jsonc"
  PYTHON_VSCODE_WORKSPACE_TEMPLATE_SRC="$REPO_ROOT/scripts/modules/runtimes/python/python-ty-vscode-workspace.code-workspace"

  install_python_common_tools
  uv_install_global_tool 'ty@latest'

  if ! command_exists_in_zsh ty; then
    die "ty was installed but is not available in zsh."
  fi

  log_info "Verifying Python tooling in zsh..."
  run_in_login_zsh 'ty version'
  verify_python_common_tools
  install_python_editor_assets
  verify_python_editor_assets

  log_success "Python ty tooling installation verified."
}

main "$@"
