#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "actionlint"

  command_exists actionlint || die "actionlint command not found after installation."
  log_info "actionlint version:"
  actionlint -version

  log_success "actionlint installation verified."
}

main "$@"