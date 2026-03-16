#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_NOTEBOOK_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/python/python-notebook-neovim.lua"
TARGET_NOTEBOOK_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_python_notebooks.lua"
REPO_NOTEBOOK_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/python/python-notebook-vscode-extensions.txt"
TARGET_NOTEBOOK_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/python-notebook-vscode-extensions.txt"

install_notebook_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_NOTEBOOK_NVIM_PLUGIN" "$(basename "$TARGET_NOTEBOOK_NVIM_PLUGIN")" >/dev/null
}

install_notebook_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_NOTEBOOK_VSCODE_EXTENSIONS" "$(basename "$TARGET_NOTEBOOK_VSCODE_EXTENSIONS")" >/dev/null
}

main() {
  uv_install_global_tool 'jupyterlab@latest'
  uv_install_global_tool 'nbqa@latest'
  uv_install_global_tool 'jupytext@latest'

  log_info "Verifying notebook tooling in zsh..."
  run_in_login_zsh 'jupyter lab --version'
  run_in_login_zsh 'nbqa --version'
  run_in_login_zsh 'jupytext --version'
  install_notebook_vscode_extensions
  install_notebook_neovim_plugin
  [[ -f "$TARGET_NOTEBOOK_VSCODE_EXTENSIONS" ]] || die "Notebook VS Code extensions manifest not found at $TARGET_NOTEBOOK_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_NOTEBOOK_NVIM_PLUGIN" ]] || die "Notebook Neovim plugin spec not found at $TARGET_NOTEBOOK_NVIM_PLUGIN"

  log_success "Notebook tooling installation verified."
}

main "$@"
