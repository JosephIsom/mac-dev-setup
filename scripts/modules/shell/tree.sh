#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "tree"; tree --version; log_success "tree installation verified."; }
main "$@"