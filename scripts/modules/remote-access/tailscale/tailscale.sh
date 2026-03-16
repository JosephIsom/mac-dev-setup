#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Tailscale.app"
REPO_TAILSCALE_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/remote-access/tailscale/tailscale-completion.zsh"
TARGET_TAILSCALE_ZSH_PLUGIN="$HOME/.zsh/plugins/tailscale-completion.zsh"
NOTES_DIR="$HOME/.config/tailscale"
NOTES_FILE="$NOTES_DIR/bootstrap-notes.txt"

install_tailscale_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_TAILSCALE_ZSH_PLUGIN" "$(basename "$TARGET_TAILSCALE_ZSH_PLUGIN")" >/dev/null
}

write_notes() {
  mkdir -p "$NOTES_DIR"

  cat > "$NOTES_FILE" <<'EOF'
Tailscale bootstrap notes

After installation:
1. Open the Tailscale app
2. Complete the onboarding flow and sign in
3. Approve the VPN/system extension if macOS prompts for it

CLI:
- The tailscale CLI is included with the app install
- Run `tailscale up` after sign-in if you want to connect from the terminal
EOF
}

main() {
  if [[ -d "$APP_PATH" ]]; then
    log_warn "Tailscale already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "tailscale-app"
  fi

  [[ -d "$APP_PATH" ]] || die "Tailscale app not found at $APP_PATH after installation."

  if ! command_exists_in_zsh tailscale; then
    die "tailscale command not found in zsh after installation."
  fi

  install_tailscale_zsh_plugin
  run_in_login_zsh 'tailscale completion zsh >/dev/null'
  write_notes

  log_info "Tailscale version:"
  run_in_login_zsh 'tailscale version | head -n 1'
  [[ -f "$TARGET_TAILSCALE_ZSH_PLUGIN" ]] || die "Tailscale zsh completion plugin not found at $TARGET_TAILSCALE_ZSH_PLUGIN"
  log_success "Tailscale installation verified."
}

main "$@"
