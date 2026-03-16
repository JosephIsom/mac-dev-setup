#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

NOTES_DIR="$HOME/.config/jetbrains"
NOTES_FILE="$NOTES_DIR/intellij-idea-notes.txt"

find_intellij_app() {
  find /Applications "$HOME/Applications" -maxdepth 3 -type d -name "IntelliJ IDEA*.app" 2>/dev/null | head -n 1
}

main() {
  mkdir -p "$NOTES_DIR"

  local idea_app=""
  idea_app="$(find_intellij_app || true)"

  cat > "$NOTES_FILE" <<'EOF'
IntelliJ IDEA bootstrap notes

Preferred install path:
1. Open JetBrains Toolbox
2. Sign in to JetBrains Account
3. Install IntelliJ IDEA from Toolbox
4. Optionally enable shell scripts in Toolbox so CLI launchers are generated

Toolbox is the recommended management path for IntelliJ IDEA on macOS.
EOF

  if [[ -n "$idea_app" ]]; then
    log_success "Detected IntelliJ IDEA app: $idea_app"
  else
    log_warn "IntelliJ IDEA app not detected yet."
    log_warn "Install it from JetBrains Toolbox."
  fi

  log_success "IntelliJ IDEA baseline notes written."
}

main "$@"
