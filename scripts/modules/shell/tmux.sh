#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/common.sh"
main() { brew_install_formula "tmux"; tmux -V; log_success "tmux installation verified."; }
main "$@"