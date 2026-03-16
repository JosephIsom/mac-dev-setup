#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_TILT_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/containers/tilt/tilt-vscode-extensions.txt"
TARGET_TILT_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/tilt-vscode-extensions.txt"
REPO_TILT_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/containers/tilt/tilt-vscode-settings.jsonc"
TARGET_TILT_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/tilt-vscode-settings.jsonc"
REPO_TILT_VSCODE_TASKS_TEMPLATE="$REPO_ROOT/scripts/modules/containers/tilt/tilt-vscode-tasks.jsonc"
TARGET_TILT_VSCODE_TASKS_TEMPLATE="$HOME/.config/mac-dev-setup/vscode/templates/tasks/tilt-vscode-tasks.jsonc"

install_tilt_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_TILT_VSCODE_EXTENSIONS" "$(basename "$TARGET_TILT_VSCODE_EXTENSIONS")" >/dev/null
}

install_tilt_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_TILT_VSCODE_SETTINGS" "$(basename "$TARGET_TILT_VSCODE_SETTINGS")" >/dev/null
}

install_tilt_vscode_templates() {
  install_managed_vscode_template "$REPO_TILT_VSCODE_TASKS_TEMPLATE" "tasks" "$(basename "$TARGET_TILT_VSCODE_TASKS_TEMPLATE")" >/dev/null
}

main() {
  brew_install_and_verify_command "tilt" "tilt" "Tilt" version
  install_tilt_vscode_extensions
  install_tilt_vscode_settings
  install_tilt_vscode_templates
  [[ -f "$TARGET_TILT_VSCODE_EXTENSIONS" ]] || die "Tilt VS Code extensions manifest not found at $TARGET_TILT_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_TILT_VSCODE_SETTINGS" ]] || die "Tilt VS Code settings fragment not found at $TARGET_TILT_VSCODE_SETTINGS"
  [[ -f "$TARGET_TILT_VSCODE_TASKS_TEMPLATE" ]] || die "Tilt VS Code tasks template not found at $TARGET_TILT_VSCODE_TASKS_TEMPLATE"
}

main "$@"
