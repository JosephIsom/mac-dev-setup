#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GEMINI_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/ai/gemini/gemini-vscode-extensions.txt"
TARGET_GEMINI_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/gemini-vscode-extensions.txt"
REPO_GEMINI_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/ai/gemini/gemini-vscode-settings.jsonc"
TARGET_GEMINI_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/gemini-vscode-settings.jsonc"

install_gemini_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_GEMINI_VSCODE_EXTENSIONS" "$(basename "$TARGET_GEMINI_VSCODE_EXTENSIONS")" >/dev/null
}

install_gemini_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_GEMINI_VSCODE_SETTINGS" "$(basename "$TARGET_GEMINI_VSCODE_SETTINGS")" >/dev/null
}

main() {
  brew_install_and_verify_command "gemini-cli" "gemini" "Gemini CLI" --version
  install_gemini_vscode_extensions
  install_gemini_vscode_settings
  [[ -f "$TARGET_GEMINI_VSCODE_EXTENSIONS" ]] || die "Gemini VS Code extensions manifest not found at $TARGET_GEMINI_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_GEMINI_VSCODE_SETTINGS" ]] || die "Gemini VS Code settings fragment not found at $TARGET_GEMINI_VSCODE_SETTINGS"
}

main "$@"
