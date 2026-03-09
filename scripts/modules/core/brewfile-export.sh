#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

EXPORT_DIR="$REPO_ROOT/docs/generated"
EXPORT_FILE="$EXPORT_DIR/Brewfile.snapshot"

main() {
  ensure_brew_available
  mkdir -p "$EXPORT_DIR"

  log_info "Exporting current Homebrew state to $EXPORT_FILE"
  brew bundle dump --file="$EXPORT_FILE" --force

  [[ -f "$EXPORT_FILE" ]] || die "Failed to create Brewfile snapshot."

  log_success "Brewfile snapshot exported."
}

main "$@"