#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "maven"

  if ! command_exists maven && ! command_exists mvn; then
    :
  fi

  command_exists mvn || die "mvn command not found after installation."
  log_info "Maven version:"
  mvn -version

  log_success "Maven installation verified."
}

main "$@"
