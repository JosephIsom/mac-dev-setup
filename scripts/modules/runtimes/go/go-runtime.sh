#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "go" "${GO_VERSION}"

  log_info "Verifying Go in zsh..."
  run_in_login_zsh 'go version'

  log_success "Go runtime installation verified."
}

main "$@"
