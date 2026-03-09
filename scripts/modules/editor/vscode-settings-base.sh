#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
SETTINGS_FILE="$VSCODE_USER_DIR/settings.json"

main() {
  mkdir -p "$VSCODE_USER_DIR"

  cat > "$SETTINGS_FILE" <<'EOF'
{
  "editor.formatOnSave": true,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "editor.rulers": [100],
  "editor.tabSize": 2,
  "terminal.integrated.shellIntegration.enabled": true,
  "editor.renderWhitespace": "selection",
  "[python]": {
    "editor.defaultFormatter": "ms-python.python"
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
EOF

  [[ -f "$SETTINGS_FILE" ]] || die "VS Code settings file was not created."

  log_success "VS Code settings scaffold installed."
}

main "$@"