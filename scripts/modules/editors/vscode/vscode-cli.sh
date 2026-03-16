#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
TARGET_DIR="$HOME/.local/bin"
TARGET_LINK="$TARGET_DIR/code"

main() {
  [[ -x "$APP_CLI" ]] || die "VS Code CLI source not found. Install VS Code app first and open it once if needed."

  ensure_local_bin_in_path
  ln -sf "$APP_CLI" "$TARGET_LINK"

  if ! run_in_login_zsh 'command -v code >/dev/null 2>&1'; then
    die "code command is not available in zsh after symlink setup."
  fi

  log_info "VS Code CLI version:"
  run_in_login_zsh 'code --version'

  log_success "VS Code CLI setup verified."
}

main "$@"
