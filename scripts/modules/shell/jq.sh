#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "jq"; jq --version; log_success "jq installation verified."; }
main "$@"