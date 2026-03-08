#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "direnv"; direnv version; log_success "direnv installation verified."; }
main "$@"