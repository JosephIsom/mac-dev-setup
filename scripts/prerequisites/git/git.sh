#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_GITIGNORE="$REPO_ROOT/scripts/prerequisites/git/ignore"
REPO_GIT_ZSH_PLUGIN="$REPO_ROOT/scripts/prerequisites/git/git-aliases.zsh"
TARGET_GIT_CONFIG_DIR="$HOME/.config/git"
GITIGNORE_FILE="$TARGET_GIT_CONFIG_DIR/ignore"
GITIGNORE_BACKUP_FILE="$GITIGNORE_FILE.pre-mac-dev-setup.bak"
TARGET_GIT_ZSH_PLUGIN="$HOME/.zsh/plugins/git-aliases.zsh"

copy_gitignore() {
  [[ -f "$REPO_GITIGNORE" ]] || die "Missing repo-managed file: $REPO_GITIGNORE"

  mkdir -p "$TARGET_GIT_CONFIG_DIR"

  if [[ -f "$GITIGNORE_FILE" ]] && ! grep -Fq "mac-dev-setup managed global gitignore" "$GITIGNORE_FILE"; then
    if [[ ! -f "$GITIGNORE_BACKUP_FILE" ]]; then
      cp "$GITIGNORE_FILE" "$GITIGNORE_BACKUP_FILE"
      log_warn "Backed up existing unmanaged global gitignore to $GITIGNORE_BACKUP_FILE"
    else
      log_warn "Preserving existing unmanaged global gitignore backup at $GITIGNORE_BACKUP_FILE"
    fi
  fi

  cp "$REPO_GITIGNORE" "$GITIGNORE_FILE"
  chmod 600 "$GITIGNORE_FILE"
}

install_git_zsh_plugin() {
  install_managed_zsh_plugin "$REPO_GIT_ZSH_PLUGIN" "$(basename "$TARGET_GIT_ZSH_PLUGIN")" >/dev/null
}

apply_git_config() {
  command_exists git || die "git must be installed before git configuration runs."

  log_info "Applying Git configuration..."

  git config --global init.defaultBranch main
  git config --global fetch.prune true
  git config --global pull.rebase false
  git config --global rerere.enabled true
  git config --global credential.helper osxkeychain
  git config --global core.excludesfile "$GITIGNORE_FILE"
  git config --global core.pager delta
  git config --global interactive.diffFilter 'delta --color-only'
  git config --global delta.navigate true
  git config --global delta.line-numbers true
  git config --global delta.syntax-theme ansi
  git config --global delta.file-style 'bold blue'
  git config --global delta.hunk-header-style 'blue'
  git config --global delta.plus-style 'syntax green'
  git config --global delta.minus-style 'syntax red'
  git config --global delta.line-numbers-left-style '8'
  git config --global delta.line-numbers-right-style '8'
  git config --global merge.conflictstyle zdiff3

  if [[ -n "${GIT_USER_NAME:-}" ]]; then
    git config --global user.name "$GIT_USER_NAME"
  else
    log_warn "GIT_USER_NAME not set. Skipping git user.name."
  fi

  if [[ -n "${GIT_USER_EMAIL:-}" ]]; then
    git config --global user.email "$GIT_USER_EMAIL"
  else
    log_warn "GIT_USER_EMAIL not set. Skipping git user.email."
  fi
}

verify_git() {
  command_exists git || die "git command not found after installation."
  log_info "Git version:"
  git --version
  log_success "Git installation verified."
}

verify_git_config() {
  local value

  log_info "Verifying Git configuration..."

  value="$(git config --global --get init.defaultBranch || true)"
  [[ "$value" == "main" ]] || die "Git init.defaultBranch not configured correctly."

  value="$(git config --global --get fetch.prune || true)"
  [[ "$value" == "true" ]] || die "Git fetch.prune not configured correctly."

  value="$(git config --global --get pull.rebase || true)"
  [[ "$value" == "false" ]] || die "Git pull.rebase not configured correctly."

  value="$(git config --global --get rerere.enabled || true)"
  [[ "$value" == "true" ]] || die "Git rerere.enabled not configured correctly."

  value="$(git config --global --get credential.helper || true)"
  [[ "$value" == "osxkeychain" ]] || die "Git credential.helper not configured correctly."

  value="$(git config --global --get core.excludesfile || true)"
  [[ "$value" == "$GITIGNORE_FILE" ]] || die "Git core.excludesfile not configured correctly."

  value="$(git config --global --get core.pager || true)"
  [[ "$value" == "delta" ]] || die "Git core.pager not configured correctly."

  value="$(git config --global --get interactive.diffFilter || true)"
  [[ "$value" == "delta --color-only" ]] || die "Git interactive.diffFilter not configured correctly."

  value="$(git config --global --get delta.navigate || true)"
  [[ "$value" == "true" ]] || die "Git delta.navigate not configured correctly."

  value="$(git config --global --get delta.line-numbers || true)"
  [[ "$value" == "true" ]] || die "Git delta.line-numbers not configured correctly."

  value="$(git config --global --get delta.syntax-theme || true)"
  [[ "$value" == "ansi" ]] || die "Git delta.syntax-theme not configured correctly."

  value="$(git config --global --get merge.conflictstyle || true)"
  [[ "$value" == "zdiff3" ]] || die "Git merge.conflictstyle not configured correctly."

  [[ -f "$TARGET_GIT_ZSH_PLUGIN" ]] || die "Git zsh plugin not installed at $TARGET_GIT_ZSH_PLUGIN."

  if [[ -n "${GIT_USER_NAME:-}" ]]; then
    value="$(git config --global --get user.name || true)"
    [[ "$value" == "$GIT_USER_NAME" ]] || die "Git user.name mismatch."
  fi

  if [[ -n "${GIT_USER_EMAIL:-}" ]]; then
    value="$(git config --global --get user.email || true)"
    [[ "$value" == "$GIT_USER_EMAIL" ]] || die "Git user.email mismatch."
  fi

  log_success "Git configuration verified ($GITIGNORE_FILE)."
}

main() {
  brew_install_formula "git"
  copy_gitignore
  install_git_zsh_plugin
  apply_git_config
  verify_git
  verify_git_config
}

main "$@"
