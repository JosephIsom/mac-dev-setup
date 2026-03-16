#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GITHUB_COPILOT_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/ai/github-copilot/github-copilot-vscode-extensions.txt"
TARGET_GITHUB_COPILOT_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/github-copilot-vscode-extensions.txt"
REPO_GITHUB_COPILOT_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/ai/github-copilot/github-copilot-vscode-settings.jsonc"
TARGET_GITHUB_COPILOT_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/github-copilot-vscode-settings.jsonc"

install_github_copilot_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_GITHUB_COPILOT_VSCODE_EXTENSIONS" "$(basename "$TARGET_GITHUB_COPILOT_VSCODE_EXTENSIONS")" >/dev/null
}

install_github_copilot_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_GITHUB_COPILOT_VSCODE_SETTINGS" "$(basename "$TARGET_GITHUB_COPILOT_VSCODE_SETTINGS")" >/dev/null
}

main() {
  brew_install_and_verify_command "copilot-cli" "copilot" "GitHub Copilot CLI" --version
  install_github_copilot_vscode_extensions
  install_github_copilot_vscode_settings
  [[ -f "$TARGET_GITHUB_COPILOT_VSCODE_EXTENSIONS" ]] || die "GitHub Copilot VS Code extensions manifest not found at $TARGET_GITHUB_COPILOT_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_GITHUB_COPILOT_VSCODE_SETTINGS" ]] || die "GitHub Copilot VS Code settings fragment not found at $TARGET_GITHUB_COPILOT_VSCODE_SETTINGS"
}

main "$@"
