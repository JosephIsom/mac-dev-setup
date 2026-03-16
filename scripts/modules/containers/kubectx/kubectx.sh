#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "kubectx"

  command_exists kubectx || die "kubectx command not found after installation."
  log_info "kubectx help:"
  kubectx --help >/dev/null
  log_success "kubectx installation verified."
}

main "$@"
