#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

verify_okta_aws_cli() {
  brew_install_formula "okta-aws-cli"

  command_exists okta-aws-cli || die "okta-aws-cli command not found after installation."

  log_info "okta-aws-cli verification:"
  if ! okta-aws-cli --version; then
    okta-aws-cli --help >/dev/null
    log_info "okta-aws-cli is installed and responds to --help."
  fi

  log_success "okta-aws-cli installation verified."
}

main() {
  verify_okta_aws_cli
}

main "$@"
