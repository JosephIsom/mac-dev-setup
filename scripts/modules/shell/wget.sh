#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "wget"; wget --version; log_success "wget installation verified."; }
main "$@"