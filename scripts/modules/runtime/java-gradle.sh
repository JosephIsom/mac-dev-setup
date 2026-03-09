#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "gradle"

  command_exists gradle || die "gradle command not found after installation."
  log_info "Gradle version:"
  gradle -version

  log_success "Gradle installation verified."
}

main "$@"
