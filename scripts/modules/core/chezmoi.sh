#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

run_brew_formula_install() {
  local formula="$1"

  command_exists brew || die "brew is required before installing $formula."
  log_info "Installing/upgrading Homebrew formula: $formula"
  brew install "$formula"
}

verify_chezmoi() {
  command_exists chezmoi || die "chezmoi command not found after installation."
  log_info "chezmoi version:"
  chezmoi --version
  log_success "chezmoi installation verified."
}

main() {
  run_brew_formula_install "chezmoi"
  verify_chezmoi
}

main "$@"