#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_CURL_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/curl/curl-path.zsh"
TARGET_CURL_PLUGIN="$HOME/.zsh/plugins/curl-path.zsh"

install_curl_plugin() {
  install_managed_zsh_plugin "$REPO_CURL_PLUGIN" "$(basename "$TARGET_CURL_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "curl"
  install_curl_plugin

  [[ -f "$TARGET_CURL_PLUGIN" ]] || die "curl path plugin file not found at $TARGET_CURL_PLUGIN"
  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/curl-path.zsh\" ]]"
  run_in_login_zsh 'command -v curl >/dev/null 2>&1'
  run_in_login_zsh "[[ \"\$(command -v curl)\" == \"/opt/homebrew/opt/curl/bin/curl\" || \"\$(command -v curl)\" == \"/usr/local/opt/curl/bin/curl\" ]]"
  run_in_login_zsh 'curl --version >/dev/null'

  log_success "Homebrew curl installation verified."
}

main "$@"
