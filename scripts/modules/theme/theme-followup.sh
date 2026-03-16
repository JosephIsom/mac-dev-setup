#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

NOTES_DIR="$HOME/.config/mac-dev-setup"
NOTES_FILE="$NOTES_DIR/theme-followup.txt"

main() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
Apple Graphite Expanded theme follow-up

Automatically themed by the repo:
- Ghostty
- WezTerm
- VS Code
- Neovim
- shell prompts and shell highlighting
- tmux
- fzf, bat, delta, lazygit, and lazydocker

Manual follow-up where app-level theming is still required:

Warp:
- Open Settings > Appearance > Current Theme
- Pick the theme that matches your macOS appearance:
  - Apple Graphite Expanded Dark (mac-dev-setup)
  - Apple Graphite Expanded Light (mac-dev-setup)
- Set font to JetBrainsMono Nerd Font, size 14

iTerm2:
- If enabled, set the managed mac-dev-setup profile as the default profile
- If you keep separate light/dark profiles, switch them manually when macOS appearance changes

Zed:
- Choose a matching light or dark appearance in Settings
- Keep JetBrainsMono Nerd Font selected

Sublime Text:
- Choose the closest Apple Graphite Expanded UI theme and color scheme manually

JetBrains IDEs / IntelliJ / Android Studio:
- Choose light or dark appearance in the app
- Keep JetBrainsMono Nerd Font as the editor font

Cursor and Windsurf:
- Choose light or dark appearance in-app
- Keep JetBrainsMono Nerd Font in the editor/terminal settings

Helix:
- The repo does not yet automate live macOS light/dark switching for Helix
- If you use Helix regularly, set its theme manually to the matching appearance

bottom and k9s:
- These are still best adjusted manually if you want exact Apple Graphite Expanded colors
- Their current experience will mostly follow your terminal palette
EOF

  log_success "Theme follow-up notes written to $NOTES_FILE"
  log_warn "Some app themes still require one-time in-app setup. See $NOTES_FILE"
}

main "$@"
