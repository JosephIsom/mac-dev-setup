#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "bat"; bat --version; log_success "bat installation verified."; }
main "$@"