#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "mise"

  command_exists mise || die "mise command not found after installation."
  log_info "mise version:"
  mise --version
  log_success "mise installation verified."
}

main "$@"