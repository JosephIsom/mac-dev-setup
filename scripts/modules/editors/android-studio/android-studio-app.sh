#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Android Studio.app"
NOTES_DIR="$HOME/.config/android-studio"
NOTES_FILE="$NOTES_DIR/bootstrap-notes.txt"

write_notes() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
Android Studio bootstrap notes

After installation:
1. Open Android Studio
2. Complete the Setup Wizard
3. Install the Android SDK, platform tools, emulator, and any required system images

Optional command-line launcher:
1. Open Android Studio
2. Choose Tools > Create Command-line Launcher
3. Install the `studio` launcher if you want terminal launch support
EOF
}

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Android Studio already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "android-studio"
  fi

  [[ -d "$APP_PATH" ]] || die "Android Studio app not found at $APP_PATH after installation."
  write_notes
  log_success "Android Studio installation verified."
}

main "$@"
