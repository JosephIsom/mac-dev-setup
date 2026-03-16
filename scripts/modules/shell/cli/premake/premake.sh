#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_PREMAKE_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/premake/premake-alias.zsh"
TARGET_PREMAKE_PLUGIN="$HOME/.zsh/plugins/premake-alias.zsh"

install_premake_plugin() {
  install_managed_zsh_plugin "$REPO_PREMAKE_PLUGIN" "$(basename "$TARGET_PREMAKE_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "premake"
  install_premake_plugin

  [[ -f "$TARGET_PREMAKE_PLUGIN" ]] || die "premake alias plugin file not found at $TARGET_PREMAKE_PLUGIN"
  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/premake-alias.zsh\" ]]"
  run_in_login_zsh 'command -v premake5 >/dev/null 2>&1'
  run_in_login_zsh 'alias premake | grep -F "premake5" >/dev/null'
  run_in_login_zsh 'premake5 --version >/dev/null'

  log_success "Premake installation verified."
}

main "$@"
