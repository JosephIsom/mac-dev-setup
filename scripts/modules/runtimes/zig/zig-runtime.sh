#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "zig" "${ZIG_VERSION}"

  log_info "Verifying Zig in zsh..."
  run_in_login_zsh 'zig version'

  log_success "Zig runtime installation verified."
}

main "$@"
