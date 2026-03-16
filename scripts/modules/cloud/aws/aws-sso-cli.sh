#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

verify_aws_sso_cli() {
  brew_install_formula "aws-sso-cli"

  command_exists aws-sso || die "aws-sso command not found after installation."

  log_info "AWS SSO CLI verification:"
  if ! aws-sso --version; then
    aws-sso --help >/dev/null
    log_info "aws-sso is installed and responds to --help."
  fi

  log_success "AWS SSO CLI installation verified."
}

main() {
  verify_aws_sso_cli
}

main "$@"
