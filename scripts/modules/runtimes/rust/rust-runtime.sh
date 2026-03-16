#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "rust" "${RUST_VERSION}"

  log_info "Verifying Rust in zsh..."
  run_in_login_zsh 'rustc --version'
  run_in_login_zsh 'cargo --version'

  log_success "Rust runtime installation verified."
}

main "$@"
