#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_NGROK_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/remote-access/ngrok/ngrok-completion.zsh"
TARGET_NGROK_ZSH_PLUGIN="$HOME/.zsh/plugins/ngrok-completion.zsh"
NOTES_DIR="$HOME/.config/ngrok"
NOTES_FILE="$NOTES_DIR/bootstrap-notes.txt"

install_ngrok_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_NGROK_ZSH_PLUGIN" "$(basename "$TARGET_NGROK_ZSH_PLUGIN")" >/dev/null
}

write_notes() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
ngrok bootstrap notes

After installation:
1. Create or sign in to your ngrok account
2. Run: ngrok config add-authtoken <token>
3. Start a tunnel with commands like: ngrok http 3000
EOF
}

main() {
  brew_install_cask "ngrok"

  if ! command_exists_in_zsh ngrok; then
    die "ngrok command not found in zsh after installation."
  fi

  install_ngrok_zsh_plugin
  run_in_login_zsh 'ngrok completion >/dev/null 2>&1'
  write_notes

  log_info "ngrok version:"
  run_in_login_zsh 'ngrok version'
  [[ -f "$TARGET_NGROK_ZSH_PLUGIN" ]] || die "ngrok zsh completion plugin not found at $TARGET_NGROK_ZSH_PLUGIN"
  log_success "ngrok installation verified."
}

main "$@"
