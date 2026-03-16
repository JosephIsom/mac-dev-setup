#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

verify_awscli_local() {
  brew_install_formula "awscli-local"

  command_exists awslocal || die "awslocal command not found after installation."

  log_info "AWS CLI Local verification:"
  if ! awslocal --version; then
    awslocal --help >/dev/null
    log_info "awslocal is installed and responds to --help."
  fi

  log_info "Verifying awslocal zsh integration..."
  run_in_login_zsh 'complete -p awslocal 2>/dev/null | grep -F "aws_completer" >/dev/null'

  log_success "AWS CLI Local installation verified."
}

main() {
  verify_awscli_local
}

main "$@"
