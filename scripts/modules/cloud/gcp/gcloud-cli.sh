#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GCLOUD_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/cloud/gcp/gcloud-plugin.zsh"
TARGET_GCLOUD_ZSH_PLUGIN="$HOME/.zsh/plugins/gcloud-plugin.zsh"

install_gcloud_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_GCLOUD_ZSH_PLUGIN" "$(basename "$TARGET_GCLOUD_ZSH_PLUGIN")" >/dev/null
}

verify_gcloud() {
  brew_install_cask "gcloud-cli"

  command_exists gcloud || die "gcloud command not found after installation."
  [[ -f "$TARGET_GCLOUD_ZSH_PLUGIN" ]] || die "gcloud zsh plugin not found at $TARGET_GCLOUD_ZSH_PLUGIN."

  log_info "Google Cloud CLI version:"
  gcloud version

  log_info "Verifying Google Cloud CLI zsh integration..."
  run_in_login_zsh 'command -v gcloud >/dev/null 2>&1'
  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/gcloud-plugin.zsh\" ]]"

  log_success "Google Cloud CLI installation verified."
}

main() {
  install_gcloud_zsh_plugin
  verify_gcloud
}

main "$@"
