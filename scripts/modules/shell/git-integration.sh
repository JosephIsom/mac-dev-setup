#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

# Git aliases and gh completion are in zsh conf.d (10-aliases.zsh, 30-completion.zsh).
# This module verifies that git integration is active in zsh.
main() {
  log_info "Verifying git integration in zsh..."
  zsh -i -c 'alias gs >/dev/null 2>&1' || die "Git alias gs not found in zsh. Run zsh-baseline first."
  log_success "Git terminal integrations verified (XDG zsh conf.d)."
}

main "$@"
