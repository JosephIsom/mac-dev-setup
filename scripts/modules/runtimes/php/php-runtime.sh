#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "php" "${PHP_VERSION}"

  log_info "Verifying PHP in zsh..."
  run_in_login_zsh 'php --version'

  log_success "PHP runtime installation verified."
}

main "$@"
