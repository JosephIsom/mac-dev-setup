#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "fd"; fd --version; log_success "fd installation verified."; }
main "$@"