#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_KUBECTL_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/containers/kubectl/kubectl-completion.zsh"
TARGET_KUBECTL_ZSH_PLUGIN="$HOME/.zsh/plugins/kubectl-completion.zsh"
REPO_KUBECTL_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/containers/kubectl/kubectl-vscode-extensions.txt"
TARGET_KUBECTL_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/kubectl-vscode-extensions.txt"
REPO_KUBECTL_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/containers/kubectl/kubectl-vscode-settings.jsonc"
TARGET_KUBECTL_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/kubectl-vscode-settings.jsonc"

install_kubectl_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_KUBECTL_ZSH_PLUGIN" "$(basename "$TARGET_KUBECTL_ZSH_PLUGIN")" >/dev/null
}

install_kubectl_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_KUBECTL_VSCODE_EXTENSIONS" "$(basename "$TARGET_KUBECTL_VSCODE_EXTENSIONS")" >/dev/null
}

install_kubectl_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_KUBECTL_VSCODE_SETTINGS" "$(basename "$TARGET_KUBECTL_VSCODE_SETTINGS")" >/dev/null
}

main() {
  brew_install_and_verify_command "kubectl" "kubectl" "kubectl" version --client=true
  install_kubectl_zsh_plugin
  install_kubectl_vscode_extensions
  install_kubectl_vscode_settings
  run_in_login_zsh 'kubectl completion zsh >/dev/null 2>&1'
  [[ -f "$TARGET_KUBECTL_ZSH_PLUGIN" ]] || die "kubectl zsh completion plugin not found at $TARGET_KUBECTL_ZSH_PLUGIN"
  [[ -f "$TARGET_KUBECTL_VSCODE_EXTENSIONS" ]] || die "kubectl VS Code extensions manifest not found at $TARGET_KUBECTL_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_KUBECTL_VSCODE_SETTINGS" ]] || die "kubectl VS Code settings fragment not found at $TARGET_KUBECTL_VSCODE_SETTINGS"
}

main "$@"
