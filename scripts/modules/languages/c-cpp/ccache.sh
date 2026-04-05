#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "ccache"

  command_exists ccache || die "ccache command not found after installation."

  log_info "Verifying ccache..."
  ccache --version | head -n 1

  log_success "ccache installation verified."
}

main "$@"
