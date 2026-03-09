#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  if ! command_exists_in_zsh npm; then
    die "markdownlint requires Node/npm in zsh. Enable INSTALL_NODE_RUNTIME or fix zsh runtime activation."
  fi

  log_info "Installing markdownlint-cli globally with npm..."
  run_in_login_zsh 'npm install -g markdownlint-cli'

  if ! command_exists_in_zsh markdownlint; then
    die "markdownlint was installed but is not available in zsh."
  fi

  log_info "Verifying markdownlint in zsh..."
  run_in_login_zsh 'markdownlint --version'

  log_success "markdownlint installation verified."
}

main "$@"