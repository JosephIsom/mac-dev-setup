#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

TESTCONTAINERS_DESKTOP_TAP="atomicjar/tap"
APP_PATH="/Applications/Testcontainers Desktop.app"
NOTES_DIR="$HOME/.config/testcontainers-desktop"
NOTES_FILE="$NOTES_DIR/bootstrap-notes.txt"

write_notes() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
Testcontainers Desktop bootstrap notes

- Launch Testcontainers Desktop and sign in with your Docker account.
- Choose the container runtime you want Testcontainers libraries to use.
- If you want to try the embedded runtime, enable it from the app menu after first launch.
EOF
}

verify_testcontainers_desktop() {
  [[ -d "$APP_PATH" ]] || die "Testcontainers Desktop app not found at $APP_PATH."
  [[ -f "$NOTES_FILE" ]] || die "Testcontainers Desktop bootstrap notes not found at $NOTES_FILE."
  log_success "Testcontainers Desktop installation verified."
}

main() {
  brew_ensure_tap "$TESTCONTAINERS_DESKTOP_TAP"
  brew_install_formula "testcontainers-desktop"
  write_notes
  verify_testcontainers_desktop
}

main "$@"
