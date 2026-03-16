#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "httpie"

  command_exists http || die "http command not found after installation."

  log_info "HTTPie version:"
  http --version

  log_success "HTTPie installation verified."
}

main "$@"
