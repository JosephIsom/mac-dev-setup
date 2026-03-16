#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  command_exists pwsh || die "pwsh command not found. Install the PowerShell runtime first."

  log_info "Installing PSScriptAnalyzer..."
  pwsh -NoLogo -NoProfile -Command 'Install-Module PSScriptAnalyzer -Scope CurrentUser -Force -SkipPublisherCheck'

  log_info "Verifying PowerShell tooling..."
  pwsh -NoLogo -NoProfile -Command 'Get-Module -ListAvailable PSScriptAnalyzer | Select-Object -First 1 | Out-Null'

  log_success "PowerShell tooling verified."
}

main "$@"
