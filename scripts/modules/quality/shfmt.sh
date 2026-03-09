#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "shfmt"

  command_exists shfmt || die "shfmt command not found after installation."
  log_info "shfmt version:"
  shfmt --version

  log_success "shfmt installation verified."
}

main "$@"