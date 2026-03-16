#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Zed.app"
NOTES_DIR="$HOME/.config/zed"
NOTES_FILE="$NOTES_DIR/bootstrap-notes.txt"

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Zed already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "zed"
  fi

  [[ -d "$APP_PATH" ]] || die "Zed app not found at $APP_PATH after installation."
  mkdir -p "$NOTES_DIR"
  cat > "$NOTES_FILE" <<'EOF'
Zed bootstrap notes

Zed includes a CLI, but on macOS it is installed from inside the app:
1. Open Zed
2. Open the command palette with Cmd+Shift+P
3. Run: cli: install

This creates /usr/local/bin/zed.
If the command is still unavailable afterward, open a new terminal window.
EOF

  if run_in_login_zsh 'command -v zed >/dev/null 2>&1'; then
    log_success "Zed CLI already available in zsh."
  else
    log_warn "Run 'cli: install' from Zed's command palette to enable the zed CLI."
  fi

  log_success "Zed installation verified."
}

main "$@"
