#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_FLYCTL_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/cloud/flyio/flyctl-plugin.zsh"
TARGET_FLYCTL_ZSH_PLUGIN="$HOME/.zsh/plugins/flyctl-plugin.zsh"

install_flyctl_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_FLYCTL_ZSH_PLUGIN" "$(basename "$TARGET_FLYCTL_ZSH_PLUGIN")" >/dev/null
}

verify_flyctl() {
  brew_install_formula "flyctl"

  if command_exists fly; then
    log_info "Fly.io CLI version:"
    fly version
  elif command_exists flyctl; then
    log_info "Fly.io CLI version:"
    flyctl version
  else
    die "Neither fly nor flyctl command was found after installation."
  fi

  [[ -f "$TARGET_FLYCTL_ZSH_PLUGIN" ]] || die "Fly.io zsh plugin not found at $TARGET_FLYCTL_ZSH_PLUGIN."

  log_info "Verifying Fly.io CLI zsh integration..."
  run_in_login_zsh 'command -v fly >/dev/null 2>&1 || command -v flyctl >/dev/null 2>&1'
  run_in_login_zsh 'if command -v fly >/dev/null 2>&1; then fly completion zsh >/dev/null 2>&1 || fly version -c zsh >/dev/null 2>&1; elif command -v flyctl >/dev/null 2>&1; then flyctl completion zsh >/dev/null 2>&1 || flyctl version -c zsh >/dev/null 2>&1; else exit 1; fi'

  log_success "Fly.io CLI installation verified."
}

main() {
  install_flyctl_zsh_plugin
  verify_flyctl
}

main "$@"
