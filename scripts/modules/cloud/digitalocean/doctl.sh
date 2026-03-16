#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_DOCTL_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/cloud/digitalocean/doctl-plugin.zsh"
TARGET_DOCTL_ZSH_PLUGIN="$HOME/.zsh/plugins/doctl-plugin.zsh"

install_doctl_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_DOCTL_ZSH_PLUGIN" "$(basename "$TARGET_DOCTL_ZSH_PLUGIN")" >/dev/null
}

verify_doctl() {
  brew_install_and_verify_command "doctl" "doctl" "doctl" version

  [[ -f "$TARGET_DOCTL_ZSH_PLUGIN" ]] || die "doctl zsh plugin not found at $TARGET_DOCTL_ZSH_PLUGIN."

  log_info "Verifying doctl zsh integration..."
  run_in_login_zsh 'command -v doctl >/dev/null 2>&1'
  run_in_login_zsh 'doctl completion zsh >/dev/null 2>&1'

  log_success "doctl installation verified."
}

main() {
  install_doctl_zsh_plugin
  verify_doctl
}

main "$@"
