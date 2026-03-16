#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_PYTHON_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/python/python-neovim.lua"
TARGET_PYTHON_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_python.lua"
REPO_PYTHON_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/python/python-vscode-extensions.txt"
TARGET_PYTHON_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/python-vscode-extensions.txt"
REPO_PYTHON_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/runtimes/python/python-vscode-settings.jsonc"
TARGET_PYTHON_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/python-vscode-settings.jsonc"
REPO_PYTHON_VSCODE_TASKS_TEMPLATE="$REPO_ROOT/scripts/modules/runtimes/python/python-vscode-tasks.jsonc"
TARGET_PYTHON_VSCODE_TASKS_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/tasks/python-vscode-tasks.jsonc"
REPO_PYTHON_VSCODE_LAUNCH_TEMPLATE="$REPO_ROOT/scripts/modules/runtimes/python/python-vscode-launch.jsonc"
TARGET_PYTHON_VSCODE_LAUNCH_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/launch/python-vscode-launch.jsonc"
REPO_PYTHON_VSCODE_WORKSPACE_TEMPLATE="$REPO_ROOT/scripts/modules/runtimes/python/python-vscode-workspace.code-workspace"
TARGET_PYTHON_VSCODE_WORKSPACE_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/workspace/python-vscode-workspace.code-workspace"

install_python_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_PYTHON_NVIM_PLUGIN" "$(basename "$TARGET_PYTHON_NVIM_PLUGIN")" >/dev/null
}

install_python_vscode_assets() {
  install_managed_vscode_extensions_manifest "$REPO_PYTHON_VSCODE_EXTENSIONS" "$(basename "$TARGET_PYTHON_VSCODE_EXTENSIONS")" >/dev/null
  install_managed_vscode_settings_fragment "$REPO_PYTHON_VSCODE_SETTINGS" "$(basename "$TARGET_PYTHON_VSCODE_SETTINGS")" >/dev/null
  install_managed_vscode_template "$REPO_PYTHON_VSCODE_TASKS_TEMPLATE" "tasks" "$(basename "$TARGET_PYTHON_VSCODE_TASKS_TEMPLATE")" >/dev/null
  install_managed_vscode_template "$REPO_PYTHON_VSCODE_LAUNCH_TEMPLATE" "launch" "$(basename "$TARGET_PYTHON_VSCODE_LAUNCH_TEMPLATE")" >/dev/null
  install_managed_vscode_template "$REPO_PYTHON_VSCODE_WORKSPACE_TEMPLATE" "workspace" "$(basename "$TARGET_PYTHON_VSCODE_WORKSPACE_TEMPLATE")" >/dev/null
}

main() {
  if ! command_exists_in_zsh uv; then
    die "Python linters require uv in zsh. Enable INSTALL_PYTHON_UV or fix zsh runtime activation."
  fi

  brew_install_formula "pyright"
  uv_install_global_tool 'ruff@latest'
  uv_install_global_tool 'mypy@latest'
  uv_install_global_tool 'pytest@latest'
  uv_install_global_tool 'debugpy@latest'

  command_exists pyright || die "pyright command not found after installation."
  command_exists pyright-langserver || die "pyright-langserver command not found after installation."

  if ! command_exists_in_zsh ruff; then
    die "ruff was installed but is not available in zsh."
  fi

  if ! command_exists_in_zsh mypy; then
    die "mypy was installed but is not available in zsh."
  fi

  if ! command_exists_in_zsh pytest; then
    die "pytest was installed but is not available in zsh."
  fi

  log_info "Verifying Ruff in zsh..."
  pyright --version
  pyright-langserver --version
  run_in_login_zsh 'ruff --version'
  run_in_login_zsh 'mypy --version'
  run_in_login_zsh 'pytest --version'
  run_in_login_zsh 'python -m debugpy --version'
  install_python_vscode_assets
  install_python_neovim_plugin
  [[ -f "$TARGET_PYTHON_VSCODE_EXTENSIONS" ]] || die "Python VS Code extensions manifest not found at $TARGET_PYTHON_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_PYTHON_VSCODE_SETTINGS" ]] || die "Python VS Code settings fragment not found at $TARGET_PYTHON_VSCODE_SETTINGS"
  [[ -f "$TARGET_PYTHON_VSCODE_TASKS_TEMPLATE" ]] || die "Python VS Code tasks template not found at $TARGET_PYTHON_VSCODE_TASKS_TEMPLATE"
  [[ -f "$TARGET_PYTHON_VSCODE_LAUNCH_TEMPLATE" ]] || die "Python VS Code launch template not found at $TARGET_PYTHON_VSCODE_LAUNCH_TEMPLATE"
  [[ -f "$TARGET_PYTHON_VSCODE_WORKSPACE_TEMPLATE" ]] || die "Python VS Code workspace template not found at $TARGET_PYTHON_VSCODE_WORKSPACE_TEMPLATE"
  [[ -f "$TARGET_PYTHON_NVIM_PLUGIN" ]] || die "Python Neovim plugin spec not found at $TARGET_PYTHON_NVIM_PLUGIN"

  log_success "Python linters installation verified."
}

main "$@"
