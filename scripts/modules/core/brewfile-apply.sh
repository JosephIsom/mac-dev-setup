#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BREWFILE_PATH="$REPO_ROOT/Brewfile"

main() {
  ensure_brew_available
  [[ -f "$BREWFILE_PATH" ]] || die "Brewfile not found at $BREWFILE_PATH"

  log_info "Applying Brewfile with brew bundle..."
  brew bundle --file="$BREWFILE_PATH"

  log_info "Verifying Brewfile can be checked..."
  brew bundle check --file="$BREWFILE_PATH"

  log_success "Brewfile apply verified."
}

main "$@"