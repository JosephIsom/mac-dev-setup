#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "cppcheck"

  command_exists cppcheck || die "cppcheck command not found after installation."

  log_info "Verifying cppcheck..."
  cppcheck --version

  log_success "cppcheck installation verified."
}

main "$@"
