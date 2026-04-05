#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "meson"

  command_exists meson || die "meson command not found after installation."

  log_info "Verifying Meson..."
  meson --version

  log_success "Meson installation verified."
}

main "$@"
