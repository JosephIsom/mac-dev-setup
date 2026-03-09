#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  command_exists mise || die "mise must be installed before java-runtime runs."

  log_info "Installing Java via mise: ${JAVA_VERSION}"
  mise use -g "java@${JAVA_VERSION}"

  log_info "Verifying Java in zsh..."
  run_in_login_zsh 'java --version'
  run_in_login_zsh 'javac --version'

  log_success "Java runtime installation verified."
}

main "$@"