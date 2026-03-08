#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

run_brew_formula_install() {
  local formula="$1"

  command_exists brew || die "brew is required before installing $formula."
  log_info "Installing/upgrading Homebrew formula: $formula"
  brew install "$formula"
}

verify_github_cli() {
  command_exists gh || die "gh command not found after installation."
  log_info "GitHub CLI version:"
  gh --version
  log_success "GitHub CLI installation verified."
}

main() {
  run_brew_formula_install "gh"
  verify_github_cli
}

main "$@"