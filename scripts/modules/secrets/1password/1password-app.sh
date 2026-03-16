#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/1Password.app"
NOTES_DIR="$HOME/.config/1password"
NOTES_FILE="$NOTES_DIR/bootstrap-notes.txt"

write_notes() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
1Password bootstrap notes

Desktop app:
- Sign in to your 1Password account
- Turn on Touch ID or system authentication if desired

CLI integration:
- The op CLI can integrate with the 1Password desktop app for biometric auth
- Run `op signin` after the app is set up

SSH agent:
- If you want to use 1Password as your SSH agent, open 1Password > Settings > Developer
- Enable the SSH agent and follow the app's setup flow

Important:
- mac-dev-setup already enables Apple Keychain support for OpenSSH in ~/.ssh/config
- 1Password SSH agent is an alternative workflow, not a required replacement
EOF
}

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "1Password already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "1password"
  fi

  [[ -d "$APP_PATH" ]] || die "1Password app not found at $APP_PATH after installation."
  write_notes
  log_success "1Password installation verified."
}

main "$@"
