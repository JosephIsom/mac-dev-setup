#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  mise_use_global "lua" "${LUA_VERSION}"

  log_info "Verifying Lua in zsh..."
  run_in_login_zsh 'lua -v'

  log_success "Lua runtime installation verified."
}

main "$@"
