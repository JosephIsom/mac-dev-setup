#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

NOTES_DIR="$HOME/.config/claude"
NOTES_FILE="$NOTES_DIR/ide-notes.txt"
REPO_CLAUDE_VSCODE_EXTENSIONS="$REPO_ROOT/scripts/modules/ai/claude/claude-vscode-extensions.txt"
TARGET_CLAUDE_VSCODE_EXTENSIONS="$HOME/.config/mac-dev-setup/vscode/extensions/claude-vscode-extensions.txt"
REPO_CLAUDE_VSCODE_SETTINGS="$REPO_ROOT/scripts/modules/ai/claude/claude-vscode-settings.jsonc"
TARGET_CLAUDE_VSCODE_SETTINGS="$HOME/.config/mac-dev-setup/vscode/settings/claude-vscode-settings.jsonc"

write_claude_notes() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
Claude Code IDE integration notes

VS Code, Cursor, Windsurf, and VSCodium:
- Open the integrated terminal inside the editor
- Run: claude
- Claude Code auto-installs its editor integration the first time it runs there

JetBrains IDEs:
- Open the integrated terminal in IntelliJ or another supported JetBrains IDE
- Run: claude

External terminals:
- Use the /ide command from Claude Code to connect to your open editor session
EOF
}

install_claude_vscode_extensions() {
  install_managed_vscode_extensions_manifest "$REPO_CLAUDE_VSCODE_EXTENSIONS" "$(basename "$TARGET_CLAUDE_VSCODE_EXTENSIONS")" >/dev/null
}

install_claude_vscode_settings() {
  install_managed_vscode_settings_fragment "$REPO_CLAUDE_VSCODE_SETTINGS" "$(basename "$TARGET_CLAUDE_VSCODE_SETTINGS")" >/dev/null
}

main() {
  npm_install_global_package "@anthropic-ai/claude-code@latest"

  if ! command_exists_in_zsh claude; then
    die "claude command not found in zsh after installation."
  fi

  write_claude_notes
  install_claude_vscode_extensions
  install_claude_vscode_settings

  log_info "Claude CLI version:"
  run_in_login_zsh 'claude --version || claude -V || true'
  log_info "Claude doctor output:"
  run_in_login_zsh 'claude doctor || true'
  [[ -f "$TARGET_CLAUDE_VSCODE_EXTENSIONS" ]] || die "Claude VS Code extensions manifest not found at $TARGET_CLAUDE_VSCODE_EXTENSIONS"
  [[ -f "$TARGET_CLAUDE_VSCODE_SETTINGS" ]] || die "Claude VS Code settings fragment not found at $TARGET_CLAUDE_VSCODE_SETTINGS"
  log_success "Claude CLI installation verified."
}

main "$@"
