#!/usr/bin/env bash

PYTHON_MODULES_DIR="$REPO_ROOT/scripts/modules/runtimes/python"

TARGET_PYTHON_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_python.lua"
TARGET_PYTHON_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/python-vscode-extensions.txt"
TARGET_PYTHON_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/python-vscode-settings.jsonc"
TARGET_PYTHON_VSCODE_TASKS_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/tasks/python-vscode-tasks.jsonc"
TARGET_PYTHON_VSCODE_LAUNCH_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/launch/python-vscode-launch.jsonc"
TARGET_PYTHON_VSCODE_WORKSPACE_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/workspace/python-vscode-workspace.code-workspace"

REPO_PYTHON_VSCODE_TASKS_TEMPLATE="$PYTHON_MODULES_DIR/python-vscode-tasks.jsonc"
REPO_PYTHON_VSCODE_LAUNCH_TEMPLATE="$PYTHON_MODULES_DIR/python-vscode-launch.jsonc"

require_python_tooling_variant_assets() {
  [[ -n "${PYTHON_NVIM_PLUGIN_SRC:-}" ]] || die "PYTHON_NVIM_PLUGIN_SRC must be set."
  [[ -n "${PYTHON_VSCODE_EXTENSIONS_SRC:-}" ]] || die "PYTHON_VSCODE_EXTENSIONS_SRC must be set."
  [[ -n "${PYTHON_VSCODE_SETTINGS_SRC:-}" ]] || die "PYTHON_VSCODE_SETTINGS_SRC must be set."
  [[ -n "${PYTHON_VSCODE_WORKSPACE_TEMPLATE_SRC:-}" ]] || die "PYTHON_VSCODE_WORKSPACE_TEMPLATE_SRC must be set."
}

install_python_common_tools() {
  ensure_local_bin_in_path

  if ! command_exists_in_zsh uv; then
    die "Python tooling requires uv in zsh. Enable INSTALL_PYTHON_UV or fix zsh runtime activation."
  fi

  uv_install_global_tool 'ruff@latest'
  uv_install_global_tool 'mypy@latest'
  uv_install_global_tool 'pytest@latest'
  uv_install_global_tool 'debugpy@latest'

  if ! command_exists_in_zsh ruff; then
    die "ruff was installed but is not available in zsh."
  fi

  if ! command_exists_in_zsh mypy; then
    die "mypy was installed but is not available in zsh."
  fi

  if ! command_exists_in_zsh pytest; then
    die "pytest was installed but is not available in zsh."
  fi

  if ! command_exists_in_zsh debugpy; then
    die "debugpy was installed but is not available in zsh."
  fi
}

verify_python_common_tools() {
  run_in_login_zsh 'ruff --version'
  run_in_login_zsh 'mypy --version'
  run_in_login_zsh 'pytest --version'
  run_in_login_zsh 'debugpy --version'
}

install_python_editor_assets() {
  require_python_tooling_variant_assets

  install_managed_vscode_extensions_manifest "$PYTHON_VSCODE_EXTENSIONS_SRC" "$(basename "$TARGET_PYTHON_VSCODE_EXTENSIONS")" >/dev/null
  install_managed_vscode_settings_fragment "$PYTHON_VSCODE_SETTINGS_SRC" "$(basename "$TARGET_PYTHON_VSCODE_SETTINGS")" >/dev/null
  install_managed_vscode_template "$REPO_PYTHON_VSCODE_TASKS_TEMPLATE" "tasks" "$(basename "$TARGET_PYTHON_VSCODE_TASKS_TEMPLATE")" >/dev/null
  install_managed_vscode_template "$REPO_PYTHON_VSCODE_LAUNCH_TEMPLATE" "launch" "$(basename "$TARGET_PYTHON_VSCODE_LAUNCH_TEMPLATE")" >/dev/null
  install_managed_vscode_template "$PYTHON_VSCODE_WORKSPACE_TEMPLATE_SRC" "workspace" "$(basename "$TARGET_PYTHON_VSCODE_WORKSPACE_TEMPLATE")" >/dev/null
  install_managed_nvim_plugin "$PYTHON_NVIM_PLUGIN_SRC" "$(basename "$TARGET_PYTHON_NVIM_PLUGIN")" >/dev/null
}

verify_python_editor_assets() {
  [[ -f "$TARGET_PYTHON_VSCODE_EXTENSIONS" ]] || die "Python VS Code extensions manifest not found at $TARGET_PYTHON_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_PYTHON_VSCODE_SETTINGS" ]] || die "Python VS Code settings fragment not found at $TARGET_PYTHON_VSCODE_SETTINGS"
  [[ -f "$TARGET_PYTHON_VSCODE_TASKS_TEMPLATE" ]] || die "Python VS Code tasks template not found at $TARGET_PYTHON_VSCODE_TASKS_TEMPLATE"
  [[ -f "$TARGET_PYTHON_VSCODE_LAUNCH_TEMPLATE" ]] || die "Python VS Code launch template not found at $TARGET_PYTHON_VSCODE_LAUNCH_TEMPLATE"
  [[ -f "$TARGET_PYTHON_VSCODE_WORKSPACE_TEMPLATE" ]] || die "Python VS Code workspace template not found at $TARGET_PYTHON_VSCODE_WORKSPACE_TEMPLATE"
  [[ -f "$TARGET_PYTHON_NVIM_PLUGIN" ]] || die "Python Neovim plugin spec not found at $TARGET_PYTHON_NVIM_PLUGIN"
}
