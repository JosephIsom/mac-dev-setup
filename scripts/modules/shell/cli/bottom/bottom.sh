#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_and_verify_command "bottom" "btm" "bottom" --version
}

main "$@"
