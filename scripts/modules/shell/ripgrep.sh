#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "ripgrep"; rg --version; log_success "ripgrep installation verified."; }
main "$@"