#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

APP_PATH="/Applications/Atuin.app"
REPO_ATUIN_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/atuin/atuin-plugin.zsh"
TARGET_ATUIN_PLUGIN="$HOME/.zsh/plugins/atuin-plugin.zsh"
ATUIN_CONFIG_DIR="$HOME/.config/atuin"
ATUIN_NOTES_FILE="$ATUIN_CONFIG_DIR/bootstrap-notes.txt"

install_atuin_plugin() {
  install_managed_zsh_plugin "$REPO_ATUIN_PLUGIN" "$(basename "$TARGET_ATUIN_PLUGIN")" >/dev/null
}

write_notes() {
  mkdir -p "$ATUIN_CONFIG_DIR"

  cat > "$ATUIN_NOTES_FILE" <<'EOF'
Atuin bootstrap notes

CLI:
- Open a new shell so the managed zsh integration loads
- Run `atuin status` to confirm the shell hook is available

Optional sync:
- Run `atuin login` if you already have an Atuin account
- Run `atuin register` if you want to create one

Desktop app:
- Open Atuin.app from /Applications after install
- Use it for Atuin Desktop runbook and workflow features
EOF
}

main() {
  brew_install_formula "atuin"

  if [[ -d "$APP_PATH" ]]; then
    log_warn "Atuin already exists at $APP_PATH. Leaving the existing app in place."
  else
    brew_install_cask "atuin-desktop"
  fi

  install_atuin_plugin
  write_notes

  command_exists atuin || die "atuin command not found after installation."
  [[ -f "$TARGET_ATUIN_PLUGIN" ]] || die "Atuin zsh plugin file not found at $TARGET_ATUIN_PLUGIN"
  [[ -d "$APP_PATH" ]] || die "Atuin app not found at $APP_PATH after installation."

  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/atuin-plugin.zsh\" ]]"
  run_in_login_zsh 'command -v atuin >/dev/null 2>&1'
  run_in_login_zsh 'atuin init zsh >/dev/null'

  log_info "Atuin version:"
  run_in_login_zsh 'atuin --version'
  log_success "Atuin installation verified."
}

main "$@"
