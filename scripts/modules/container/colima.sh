#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "colima"

  command_exists colima || die "colima command not found after installation."
  log_info "Colima version:"
  colima version

  log_success "Colima installation verified."
}

main "$@"
