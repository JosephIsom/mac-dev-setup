#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_DOTNET_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/runtimes/dotnet/dotnet-completion.zsh"
TARGET_DOTNET_ZSH_PLUGIN="$HOME/.zsh/plugins/dotnet-completion.zsh"
REPO_DOTNET_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/runtimes/dotnet/dotnet-vscode-extensions.txt"
TARGET_DOTNET_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/dotnet-vscode-extensions.txt"
REPO_DOTNET_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/runtimes/dotnet/dotnet-vscode-settings.jsonc"
TARGET_DOTNET_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/dotnet-vscode-settings.jsonc"

install_dotnet_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_DOTNET_ZSH_PLUGIN" "$(basename "$TARGET_DOTNET_ZSH_PLUGIN")" >/dev/null
}

install_dotnet_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_DOTNET_VSCODE_EXTENSIONS" "$(basename "$TARGET_DOTNET_VSCODE_EXTENSIONS")" >/dev/null
}

install_dotnet_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_DOTNET_VSCODE_SETTINGS" "$(basename "$TARGET_DOTNET_VSCODE_SETTINGS")" >/dev/null
}

main() {
  mise_use_global "dotnet" "${DOTNET_VERSION}"
  install_dotnet_zsh_plugin
  install_dotnet_vscode_extensions
  install_dotnet_vscode_settings

  log_info "Verifying .NET in zsh..."
  run_in_login_zsh 'dotnet --version'
  run_in_login_zsh 'dotnet format --version >/dev/null'
  run_in_login_zsh 'dotnet completions script zsh >/dev/null'
  [[ -f "$TARGET_DOTNET_ZSH_PLUGIN" ]] || die ".NET zsh completion plugin not found at $TARGET_DOTNET_ZSH_PLUGIN"
  [[ -f "$TARGET_DOTNET_VSCODE_EXTENSIONS" ]] || die ".NET VS Code extensions manifest not found at $TARGET_DOTNET_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_DOTNET_VSCODE_SETTINGS" ]] || die ".NET VS Code settings fragment not found at $TARGET_DOTNET_VSCODE_SETTINGS"

  log_success ".NET runtime installation verified."
}

main "$@"
