#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_CODEX_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/ai/codex/codex-completion.zsh"
TARGET_CODEX_ZSH_PLUGIN="$HOME/.zsh/plugins/codex-completion.zsh"

install_codex_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_CODEX_ZSH_PLUGIN" "$(basename "$TARGET_CODEX_ZSH_PLUGIN")" >/dev/null
}

main() {
  brew_install_cask "codex"

  if ! command_exists_in_zsh codex; then
    die "codex command not found in zsh after installation."
  fi

  install_codex_zsh_plugin

  if ! run_in_login_zsh 'codex completion zsh >/dev/null 2>&1'; then
    die "codex zsh completion generation failed."
  fi

  log_info "Codex CLI version:"
  run_in_login_zsh 'codex --version || codex -V || true'

  [[ -f "$TARGET_CODEX_ZSH_PLUGIN" ]] || die "Codex zsh completion plugin not found at $TARGET_CODEX_ZSH_PLUGIN"
  log_success "Codex CLI installation verified."
}

main "$@"
