#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../lib/common.sh"

main() {
  ensure_macos
  prepare_environment

  run_script_path "$PREREQUISITES_DIR/xcode/xcode-clt.sh"
  run_script_path "$PREREQUISITES_DIR/homebrew/homebrew.sh"
  run_script_path "$PREREQUISITES_DIR/fonts/fonts.sh"
  run_script_path "$PREREQUISITES_DIR/git/git.sh"
  run_script_path "$PREREQUISITES_DIR/mise/mise.sh"
  run_script_path "$PREREQUISITES_DIR/ssh/ssh.sh"
  run_script_path "$PREREQUISITES_DIR/zsh/zsh.sh"
}

main "$@"
