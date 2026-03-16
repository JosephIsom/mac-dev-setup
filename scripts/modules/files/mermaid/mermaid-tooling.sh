#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  npm_install_global_package '@mermaid-js/mermaid-cli@latest'

  log_info "Verifying Mermaid tooling..."
  run_in_login_zsh 'mmdc --version'

  log_success "Mermaid tooling installation verified."
}

main "$@"
