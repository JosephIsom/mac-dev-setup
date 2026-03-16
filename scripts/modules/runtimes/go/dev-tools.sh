#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GO_NVIM_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/go/go-neovim.lua"
TARGET_GO_NVIM_PLUGIN="$HOME/.config/nvim/lua/mac_dev_setup/plugins/runtimes_go.lua"
REPO_GO_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/go/go-vscode-extensions.txt"
TARGET_GO_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/go-vscode-extensions.txt"
REPO_GO_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/runtimes/go/go-vscode-settings.jsonc"
TARGET_GO_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/go-vscode-settings.jsonc"
REPO_GO_VSCODE_TASKS_TEMPLATE="$REPO_ROOT/scripts/modules/runtimes/go/go-vscode-tasks.jsonc"
TARGET_GO_VSCODE_TASKS_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/tasks/go-vscode-tasks.jsonc"
REPO_GO_VSCODE_LAUNCH_TEMPLATE="$REPO_ROOT/scripts/modules/runtimes/go/go-vscode-launch.jsonc"
TARGET_GO_VSCODE_LAUNCH_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/launch/go-vscode-launch.jsonc"
REPO_GO_VSCODE_WORKSPACE_TEMPLATE="$REPO_ROOT/scripts/modules/runtimes/go/go-vscode-workspace.code-workspace"
TARGET_GO_VSCODE_WORKSPACE_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/workspace/go-vscode-workspace.code-workspace"

install_go_neovim_plugin() {
  install_managed_nvim_plugin "$REPO_GO_NVIM_PLUGIN" "$(basename "$TARGET_GO_NVIM_PLUGIN")" >/dev/null
}

install_go_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_GO_VSCODE_EXTENSIONS" "$(basename "$TARGET_GO_VSCODE_EXTENSIONS")" >/dev/null
}

install_go_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_GO_VSCODE_SETTINGS" "$(basename "$TARGET_GO_VSCODE_SETTINGS")" >/dev/null
}

install_go_vscode_templates() {
  install_managed_vscode_template "$REPO_GO_VSCODE_TASKS_TEMPLATE" "tasks" "$(basename "$TARGET_GO_VSCODE_TASKS_TEMPLATE")" >/dev/null
  install_managed_vscode_template "$REPO_GO_VSCODE_LAUNCH_TEMPLATE" "launch" "$(basename "$TARGET_GO_VSCODE_LAUNCH_TEMPLATE")" >/dev/null
  install_managed_vscode_template "$REPO_GO_VSCODE_WORKSPACE_TEMPLATE" "workspace" "$(basename "$TARGET_GO_VSCODE_WORKSPACE_TEMPLATE")" >/dev/null
}

main() {
  if ! command_exists_in_zsh go; then
    die "Go dev tools require go in zsh. Enable INSTALL_GO_RUNTIME or fix zsh runtime activation."
  fi

  go_install_global_package 'golang.org/x/tools/gopls@latest'
  go_install_global_package 'github.com/golangci/golangci-lint/cmd/golangci-lint@latest'
  go_install_global_package 'github.com/go-delve/delve/cmd/dlv@latest'
  go_install_global_package 'golang.org/x/tools/cmd/goimports@latest'
  go_install_global_package 'honnef.co/go/tools/cmd/staticcheck@latest'

  if ! run_in_login_zsh 'command -v gopls >/dev/null 2>&1'; then
    die "gopls was installed but is not available in zsh."
  fi

  if ! run_in_login_zsh 'command -v golangci-lint >/dev/null 2>&1'; then
    die "golangci-lint was installed but is not available in zsh."
  fi

  if ! run_in_login_zsh 'command -v dlv >/dev/null 2>&1'; then
    die "dlv was installed but is not available in zsh."
  fi

  if ! run_in_login_zsh 'command -v goimports >/dev/null 2>&1'; then
    die "goimports was installed but is not available in zsh."
  fi

  if ! run_in_login_zsh 'command -v staticcheck >/dev/null 2>&1'; then
    die "staticcheck was installed but is not available in zsh."
  fi

  log_info "Verifying Go dev tools in zsh..."
  run_in_login_zsh 'gopls version'
  run_in_login_zsh 'golangci-lint version'
  run_in_login_zsh 'dlv version | head -n 1'
  run_in_login_zsh 'goimports -help >/dev/null'
  run_in_login_zsh 'staticcheck -version'
  install_go_vscode_extensions
  install_go_vscode_settings
  install_go_vscode_templates
  install_go_neovim_plugin
  [[ -f "$TARGET_GO_VSCODE_EXTENSIONS" ]] || die "Go VS Code extensions manifest not found at $TARGET_GO_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_GO_VSCODE_SETTINGS" ]] || die "Go VS Code settings fragment not found at $TARGET_GO_VSCODE_SETTINGS"
  [[ -f "$TARGET_GO_VSCODE_TASKS_TEMPLATE" ]] || die "Go VS Code tasks template not found at $TARGET_GO_VSCODE_TASKS_TEMPLATE"
  [[ -f "$TARGET_GO_VSCODE_LAUNCH_TEMPLATE" ]] || die "Go VS Code launch template not found at $TARGET_GO_VSCODE_LAUNCH_TEMPLATE"
  [[ -f "$TARGET_GO_VSCODE_WORKSPACE_TEMPLATE" ]] || die "Go VS Code workspace template not found at $TARGET_GO_VSCODE_WORKSPACE_TEMPLATE"
  [[ -f "$TARGET_GO_NVIM_PLUGIN" ]] || die "Go Neovim plugin spec not found at $TARGET_GO_NVIM_PLUGIN"

  log_success "Go dev tools installation verified."
}

main "$@"
