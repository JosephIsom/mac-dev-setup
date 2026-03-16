#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_and_verify_command "git-delta" "delta" "git-delta" --version
  log_info "delta will use the managed Apple Graphite Expanded styling through global git config."
}

main "$@"
