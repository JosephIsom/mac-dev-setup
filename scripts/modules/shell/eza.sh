#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "eza"; eza --version; log_success "eza installation verified."; }
main "$@"