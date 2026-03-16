#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
LIB_DIR="$REPO_ROOT/scripts/lib"
CONFIG_DIR="$REPO_ROOT/config"
MODULES_DIR="$REPO_ROOT/scripts/modules"
PREREQUISITES_DIR="$REPO_ROOT/scripts/prerequisites"
export REPO_ROOT LIB_DIR CONFIG_DIR MODULES_DIR PREREQUISITES_DIR

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

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
