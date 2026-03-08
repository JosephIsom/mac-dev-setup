#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "zoxide"; zoxide --version; log_success "zoxide installation verified."; }
main "$@"