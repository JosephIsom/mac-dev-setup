#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "kotlin" "${KOTLIN_VERSION}"

  log_info "Verifying Kotlin in zsh..."
  run_in_login_zsh 'kotlin -version'
  run_in_login_zsh 'kotlinc -version'

  log_success "Kotlin runtime installation verified."
}

main "$@"
