#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "shellcheck"

  command_exists shellcheck || die "shellcheck command not found after installation."
  log_info "shellcheck version:"
  shellcheck --version

  log_success "shellcheck installation verified."
}

main "$@"