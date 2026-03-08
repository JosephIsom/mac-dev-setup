#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "yq"; yq --version; log_success "yq installation verified."; }
main "$@"