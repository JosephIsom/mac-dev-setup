#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  command_exists chezmoi || die "chezmoi must be installed before chezmoi-apply-managed runs."

  log_warn "Chezmoi adoption phase is partial right now."
  log_warn "Repo-managed source files exist, but bootstrap still copies them directly."
  log_warn "This phase prepares the repo for fuller chezmoi ownership later."

  log_success "Chezmoi ownership preparation acknowledged."
}

main "$@"
