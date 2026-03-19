#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

NOTES_DIR="$HOME/.config/mac-dev-setup"
NOTES_FILE="$NOTES_DIR/theme-followup.txt"

main() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
Islands Dark theme follow-up

Automatically themed by the repo:
- VS Code
- Cursor
- Windsurf
- Ghostty
- WezTerm (when enabled)
- iTerm2 dynamic profile (when enabled)
- Warp custom theme asset (when enabled)
- Neovim
- Helix (when enabled)
- tmux
- bottom
- k9s
- shell prompts and shell highlighting
- fzf, bat, delta, lazygit, and lazydocker

Manual follow-up where app-level theming is still required:

Warp:
- Open Settings > Appearance > Current Theme
- Pick Islands Dark (mac-dev-setup)
- Set font to JetBrainsMono Nerd Font, size 14

Zed:
- Choose a dark appearance in Settings
- Keep JetBrainsMono Nerd Font selected if you want editor text to match the rest of the setup

Sublime Text:
- Choose a dark UI theme manually
- Keep JetBrainsMono Nerd Font as the editor font if desired

JetBrains IDEs / IntelliJ / Android Studio / DataGrip:
- Choose a dark appearance in the app
- Keep JetBrainsMono Nerd Font as the editor font

Helix:
- The repo installs the Islands Dark theme and config automatically
- Run :theme islands_dark if you want to switch immediately in an existing session
EOF

  log_success "Theme follow-up notes written to $NOTES_FILE"
  log_warn "Some app themes still require one-time in-app setup. See $NOTES_FILE"
}

main "$@"
