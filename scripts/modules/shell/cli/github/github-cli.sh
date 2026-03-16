#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

GH_CONFIG_DIR="$HOME/.config/gh"
GH_NOTES_FILE="$GH_CONFIG_DIR/bootstrap-notes"
REPO_GH_ZSH_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/github/github-completion.zsh"
TARGET_GH_ZSH_PLUGIN="$HOME/.zsh/plugins/github-completion.zsh"

write_notes() {
  mkdir -p "$GH_CONFIG_DIR"

  cat > "$GH_NOTES_FILE" <<EOF
GitHub CLI bootstrap notes

Configured git protocol: ssh

If not yet authenticated, run:
  gh auth login

Then verify with:
  gh auth status
EOF
}

install_gh_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_GH_ZSH_PLUGIN" "$(basename "$TARGET_GH_ZSH_PLUGIN")" >/dev/null
}

configure_gh() {
  command_exists gh || die "gh must be installed before GitHub CLI configuration runs."

  log_info "Setting GitHub CLI git protocol to: ssh"
  gh config set git_protocol "ssh"

  log_info "Checking GitHub CLI authentication status..."
  if gh auth status >/dev/null 2>&1; then
    gh auth status
    log_success "GitHub CLI authentication already configured."
  else
    log_warn "GitHub CLI is installed but not authenticated yet."
    log_warn "Run: gh auth login"
  fi
}

verify_github_cli() {
  command_exists gh || die "gh command not found after installation."
  log_info "GitHub CLI version:"
  gh --version
  log_success "GitHub CLI installation verified."
}

verify_gh_config() {
  local configured_protocol

  configured_protocol="$(gh config get git_protocol 2>/dev/null || true)"
  [[ "$configured_protocol" == "ssh" ]] || die "GitHub CLI git_protocol mismatch."
  [[ -f "$TARGET_GH_ZSH_PLUGIN" ]] || die "GitHub zsh completion plugin not found at $TARGET_GH_ZSH_PLUGIN."
  log_success "GitHub CLI configuration verified ($GH_CONFIG_DIR)."
}

main() {
  brew_install_formula "gh"
  verify_github_cli
  install_gh_zsh_plugin
  write_notes
  configure_gh
  verify_gh_config
}

main "$@"
