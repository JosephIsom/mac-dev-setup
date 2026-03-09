#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "yamllint"

  command_exists yamllint || die "yamllint command not found after installation."
  log_info "yamllint version:"
  yamllint --version

  log_success "yamllint installation verified."
}

main "$@"