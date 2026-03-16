#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Bitwarden.app"
NOTES_DIR="$HOME/.config/bitwarden"
NOTES_FILE="$NOTES_DIR/bootstrap-notes.txt"

write_notes() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
Bitwarden bootstrap notes

Desktop app:
- Sign in to your Bitwarden account
- On macOS, the desktop app uses Keychain for secure storage

CLI:
- The bw CLI is installed separately and can authenticate with email/password, API key, or SSO
- For arm64 Macs, npm is the recommended install path
EOF
}

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Bitwarden already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "bitwarden"
  fi

  [[ -d "$APP_PATH" ]] || die "Bitwarden app not found at $APP_PATH after installation."
  write_notes
  log_success "Bitwarden installation verified."
}

main "$@"
