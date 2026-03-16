#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

NOTES_DIR="$HOME/.config/jetbrains"
NOTES_FILE="$NOTES_DIR/intellij-ai-notes.txt"

main() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
IntelliJ AI bootstrap notes

JetBrains AI Assistant:
1. Open IntelliJ IDEA from JetBrains Toolbox
2. Open the JetBrains AI widget or AI Chat tool window
3. Install the AI Assistant plugin
4. Accept the JetBrains AI terms and activate your license or trial

JetBrains Junie:
1. After AI Assistant is available, install Junie from the JetBrains AI widget or Plugins Marketplace
2. Junie requires a recent IntelliJ IDEA version and a JetBrains AI license

Helpful follow-up:
- Settings > Tools > MCP Server lets JetBrains IDEs auto-configure external AI clients such as Codex, Cursor, Claude, and Windsurf

Gemini Code Assist:
1. Open the Plugins Marketplace in IntelliJ IDEA
2. Install Gemini Code Assist
3. Sign in with your Google account or workspace account
EOF

  log_success "IntelliJ AI setup notes written."
}

main "$@"
