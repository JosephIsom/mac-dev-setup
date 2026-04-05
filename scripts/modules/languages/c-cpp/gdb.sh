#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "gdb"

  command_exists gdb || die "gdb command not found after installation."

  log_info "Verifying gdb..."
  gdb --version | head -n 1
  log_warn "gdb on macOS still requires manual codesigning before it can attach to processes reliably."

  log_success "gdb installation verified."
}

main "$@"
