#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  command_exists mise || die "mise must be installed before go-runtime runs."

  log_info "Installing Go via mise: ${GO_VERSION}"
  mise use -g "go@${GO_VERSION}"

  log_info "Verifying Go in zsh..."
  run_in_login_zsh 'go version'

  log_success "Go runtime installation verified."
}

main "$@"