#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  if ! command_exists_in_zsh npm; then
    die "TypeScript installation requires npm in zsh. Enable INSTALL_NODE_RUNTIME or fix zsh runtime activation."
  fi

  npm_install_global_package 'typescript@latest'
  npm_install_global_package 'tsx@latest'

  if ! command_exists_in_zsh tsc; then
    die "tsc was installed but is not available in zsh."
  fi

  if ! command_exists_in_zsh tsx; then
    die "tsx was installed but is not available in zsh."
  fi

  log_info "Verifying TypeScript in zsh..."
  run_in_login_zsh 'tsc --version'
  run_in_login_zsh 'tsx --version'

  log_success "TypeScript installation verified."
}

main "$@"
