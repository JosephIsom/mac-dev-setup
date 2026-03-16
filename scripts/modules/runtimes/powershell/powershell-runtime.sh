#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_formula "powershell"

  command_exists pwsh || die "pwsh command not found after installation."

  log_info "Verifying PowerShell runtime..."
  pwsh --version

  log_success "PowerShell runtime installation verified."
}

main "$@"
