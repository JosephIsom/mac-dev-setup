#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "ruby" "${RUBY_VERSION}"

  log_info "Verifying Ruby in zsh..."
  run_in_login_zsh 'ruby --version'
  run_in_login_zsh 'gem --version'

  log_success "Ruby runtime installation verified."
}

main "$@"
