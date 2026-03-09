#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "docker"

  command_exists docker || die "docker command not found after installation."
  log_info "Docker CLI version:"
  docker --version

  log_success "Docker CLI installation verified."
}

main "$@"
