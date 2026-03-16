#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_WRANGLER_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/cloud/cloudflare/wrangler-plugin.zsh"
TARGET_WRANGLER_ZSH_PLUGIN="$HOME/.zsh/plugins/wrangler-plugin.zsh"

install_wrangler_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_WRANGLER_ZSH_PLUGIN" "$(basename "$TARGET_WRANGLER_ZSH_PLUGIN")" >/dev/null
}

verify_wrangler() {
  brew_install_and_verify_command "cloudflare-wrangler" "wrangler" "Cloudflare Wrangler" --version

  [[ -f "$TARGET_WRANGLER_ZSH_PLUGIN" ]] || die "Wrangler zsh plugin not found at $TARGET_WRANGLER_ZSH_PLUGIN."

  log_info "Verifying Wrangler zsh integration..."
  run_in_login_zsh 'command -v wrangler >/dev/null 2>&1'
  run_in_login_zsh 'wrangler complete zsh >/dev/null 2>&1'

  log_success "Cloudflare Wrangler installation verified."
}

main() {
  install_wrangler_zsh_plugin
  verify_wrangler
}

main "$@"
