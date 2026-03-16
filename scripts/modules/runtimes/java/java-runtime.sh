#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "java" "${JAVA_VERSION}"

  log_info "Verifying Java in zsh..."
  run_in_login_zsh 'java --version'
  run_in_login_zsh 'javac --version'

  log_success "Java runtime installation verified."
}

main "$@"
