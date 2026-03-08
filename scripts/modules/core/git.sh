#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

run_brew_formula_install() {
  local formula="$1"

  command_exists brew || die "brew is required before installing $formula."
  log_info "Installing/upgrading Homebrew formula: $formula"
  brew install "$formula"
}

verify_git() {
  command_exists git || die "git command not found after installation."
  log_info "Git version:"
  git --version
  log_success "Git installation verified."
}

main() {
  run_brew_formula_install "git"
  verify_git
}

main "$@"