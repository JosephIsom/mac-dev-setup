#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  brew_install_and_verify_command "just" "just" "just" --version
  #FIXME: This has completions available and are missing from this script.
  # see: https://just.systems/man/en/shell-completion-scripts.html
}

main "$@"
