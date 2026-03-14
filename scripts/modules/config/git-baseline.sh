#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

REPO_GITIGNORE="$REPO_ROOT/home/dot_config/git/ignore"
GIT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git"
GITIGNORE_FILE="$GIT_CONFIG_DIR/ignore"

copy_gitignore() {
  mkdir -p "$GIT_CONFIG_DIR"
  [[ -f "$REPO_GITIGNORE" ]] || die "Missing repo-managed file: $REPO_GITIGNORE"
  cp "$REPO_GITIGNORE" "$GITIGNORE_FILE"
}

apply_git_baseline() {
  command_exists git || die "git must be installed before git-baseline runs."

  log_info "Applying Git baseline configuration..."

  git config --global init.defaultBranch main
  git config --global fetch.prune true
  git config --global pull.rebase false
  git config --global rerere.enabled true
  git config --global core.excludesfile "$GITIGNORE_FILE"

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

verify_git_config() {
  local value

  log_info "Verifying Git baseline config..."

  value="$(git config --global --get init.defaultBranch || true)"
  [[ "$value" == "main" ]] || die "Git init.defaultBranch not configured correctly."

  value="$(git config --global --get fetch.prune || true)"
  [[ "$value" == "true" ]] || die "Git fetch.prune not configured correctly."

  value="$(git config --global --get pull.rebase || true)"
  [[ "$value" == "false" ]] || die "Git pull.rebase not configured correctly."

  value="$(git config --global --get rerere.enabled || true)"
  [[ "$value" == "true" ]] || die "Git rerere.enabled not configured correctly."

  value="$(git config --global --get core.excludesfile || true)"
  [[ "$value" == "$GITIGNORE_FILE" ]] || die "Git core.excludesfile not configured correctly."

  if [[ -n "${GIT_USER_NAME:-}" ]]; then
    value="$(git config --global --get user.name || true)"
    [[ "$value" == "$GIT_USER_NAME" ]] || die "Git user.name mismatch."
  fi

  if [[ -n "${GIT_USER_EMAIL:-}" ]]; then
    value="$(git config --global --get user.email || true)"
    [[ "$value" == "$GIT_USER_EMAIL" ]] || die "Git user.email mismatch."
  fi

  log_success "Git baseline configuration verified (XDG: $GITIGNORE_FILE)."
}

main() {
  copy_gitignore
  apply_git_baseline
  verify_git_config
}

main "$@"
