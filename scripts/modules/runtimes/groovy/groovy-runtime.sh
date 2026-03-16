#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "groovy" "${GROOVY_VERSION}"

  log_info "Verifying Groovy in zsh..."
  run_in_login_zsh 'groovy --version'
  run_in_login_zsh 'groovyc --version'

  log_success "Groovy runtime installation verified."
}

main "$@"
