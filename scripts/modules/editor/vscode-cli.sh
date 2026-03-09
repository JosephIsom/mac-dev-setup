#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

APP_CLI="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
TARGET_DIR="$HOME/.local/bin"
TARGET_LINK="$TARGET_DIR/code"

ensure_local_bin_in_path() {
  mkdir -p "$TARGET_DIR"

  if ! grep -Fq 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.config/dev-bootstrap/zsh/local.zsh" 2>/dev/null; then
    printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.config/dev-bootstrap/zsh/local.zsh"
    log_success "Added ~/.local/bin PATH entry to dev-bootstrap local.zsh"
  fi
}

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