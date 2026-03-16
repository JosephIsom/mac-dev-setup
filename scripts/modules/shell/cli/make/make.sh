#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_MAKE_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/make/make-path.zsh"
TARGET_MAKE_PLUGIN="$HOME/.zsh/plugins/make-path.zsh"

install_make_plugin() {
  install_managed_zsh_plugin "$REPO_MAKE_PLUGIN" "$(basename "$TARGET_MAKE_PLUGIN")" >/dev/null
}

main() {
  brew_install_formula "make"
  install_make_plugin

  [[ -f "$TARGET_MAKE_PLUGIN" ]] || die "make path plugin file not found at $TARGET_MAKE_PLUGIN"
  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/make-path.zsh\" ]]"
  run_in_login_zsh 'command -v gmake >/dev/null 2>&1'
  run_in_login_zsh 'make --version | grep -F "GNU Make" >/dev/null'

  log_success "GNU make installation verified."
}

main "$@"
