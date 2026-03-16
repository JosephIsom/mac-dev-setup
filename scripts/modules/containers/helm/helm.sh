#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_HELM_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/containers/helm/helm-completion.zsh"
TARGET_HELM_ZSH_PLUGIN="$HOME/.zsh/plugins/helm-completion.zsh"

install_helm_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_HELM_ZSH_PLUGIN" "$(basename "$TARGET_HELM_ZSH_PLUGIN")" >/dev/null
}

main() {
  brew_install_and_verify_command "helm" "helm" "Helm" version --short
  install_helm_zsh_plugin
  run_in_login_zsh 'helm completion zsh >/dev/null'
  [[ -f "$TARGET_HELM_ZSH_PLUGIN" ]] || die "Helm zsh completion plugin not found at $TARGET_HELM_ZSH_PLUGIN"
}

main "$@"
