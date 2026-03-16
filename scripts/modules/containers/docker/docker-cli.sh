#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_DOCKER_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/containers/docker/docker-completion.zsh"
TARGET_DOCKER_ZSH_PLUGIN="$HOME/.zsh/plugins/docker-completion.zsh"
REPO_DOCKER_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/containers/docker/docker-vscode-extensions.txt"
TARGET_DOCKER_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/docker-vscode-extensions.txt"
REPO_DOCKER_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/containers/docker/docker-vscode-settings.jsonc"
TARGET_DOCKER_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/docker-vscode-settings.jsonc"
REPO_DOCKER_VSCODE_TASKS_TEMPLATE="$REPO_ROOT/scripts/modules/containers/docker/docker-vscode-tasks.jsonc"
TARGET_DOCKER_VSCODE_TASKS_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/tasks/docker-vscode-tasks.jsonc"

install_docker_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_DOCKER_ZSH_PLUGIN" "$(basename "$TARGET_DOCKER_ZSH_PLUGIN")" >/dev/null
}

install_docker_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_DOCKER_VSCODE_EXTENSIONS" "$(basename "$TARGET_DOCKER_VSCODE_EXTENSIONS")" >/dev/null
}

install_docker_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_DOCKER_VSCODE_SETTINGS" "$(basename "$TARGET_DOCKER_VSCODE_SETTINGS")" >/dev/null
}

install_docker_vscode_templates() {
  install_managed_vscode_template "$REPO_DOCKER_VSCODE_TASKS_TEMPLATE" "tasks" "$(basename "$TARGET_DOCKER_VSCODE_TASKS_TEMPLATE")" >/dev/null
}

main() {
  brew_install_and_verify_command "docker" "docker" "Docker CLI" --version
  install_docker_zsh_plugin
  install_docker_vscode_extensions
  install_docker_vscode_settings
  install_docker_vscode_templates
  run_in_login_zsh 'docker completion zsh >/dev/null 2>&1'
  [[ -f "$TARGET_DOCKER_ZSH_PLUGIN" ]] || die "Docker zsh completion plugin not found at $TARGET_DOCKER_ZSH_PLUGIN"
  [[ -f "$TARGET_DOCKER_VSCODE_EXTENSIONS" ]] || die "Docker VS Code extensions manifest not found at $TARGET_DOCKER_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_DOCKER_VSCODE_SETTINGS" ]] || die "Docker VS Code settings fragment not found at $TARGET_DOCKER_VSCODE_SETTINGS"
  [[ -f "$TARGET_DOCKER_VSCODE_TASKS_TEMPLATE" ]] || die "Docker VS Code tasks template not found at $TARGET_DOCKER_VSCODE_TASKS_TEMPLATE"
}

main "$@"
