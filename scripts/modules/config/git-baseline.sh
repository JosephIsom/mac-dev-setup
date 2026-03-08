#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BOOTSTRAP_GIT_DIR="$HOME/.config/dev-bootstrap/git"
BOOTSTRAP_GITCONFIG="$BOOTSTRAP_GIT_DIR/gitconfig.bootstrap"
BOOTSTRAP_GITCONFIG_LOCAL="$BOOTSTRAP_GIT_DIR/gitconfig.local"
USER_GITCONFIG="$HOME/.gitconfig"

append_line_if_missing() {
  local file="$1"
  local line="$2"

  touch "$file"

  if grep -Fqx "$line" "$file" 2>/dev/null; then
    log_info "Line already present in $file"
    return 0
  fi

  printf '\n%s\n' "$line" >> "$file"
  log_success "Added managed include to $file"
}

write_bootstrap_gitconfig() {
  mkdir -p "$BOOTSTRAP_GIT_DIR"

  cat > "$BOOTSTRAP_GITCONFIG" <<'EOF'
[init]
    defaultBranch = main

[fetch]
    prune = true

[pull]
    rebase = false

[rerere]
    enabled = true

[core]
    excludesfile = ~/.config/dev-bootstrap/git/ignore
EOF

  cat > "$BOOTSTRAP_GIT_DIR/ignore" <<'EOF'
.DS_Store
*.swp
*.tmp
EOF
}

write_local_gitconfig() {
  mkdir -p "$BOOTSTRAP_GIT_DIR"

  if [[ -n "${GIT_USER_NAME:-}" && -n "${GIT_USER_EMAIL:-}" ]]; then
    cat > "$BOOTSTRAP_GITCONFIG_LOCAL" <<EOF
[user]
    name = ${GIT_USER_NAME}
    email = ${GIT_USER_EMAIL}
EOF
    log_success "Wrote managed Git identity to $BOOTSTRAP_GITCONFIG_LOCAL"
  else
    cat > "$BOOTSTRAP_GITCONFIG_LOCAL" <<'EOF'
# Fill in GIT_USER_NAME and GIT_USER_EMAIL in config/user.env
# Then rerun bootstrap to populate this file automatically.
EOF
    log_warn "Git identity not set. Populate config/user.env and rerun."
  fi
}

ensure_gitconfig_includes() {
  append_line_if_missing "$USER_GITCONFIG" '[include]'
  append_line_if_missing "$USER_GITCONFIG" '    path = ~/.config/dev-bootstrap/git/gitconfig.bootstrap'
  append_line_if_missing "$USER_GITCONFIG" '    path = ~/.config/dev-bootstrap/git/gitconfig.local'
}

verify_git_config() {
  command_exists git || die "git command not found."

  log_info "Verifying Git baseline config..."
  git config --global --get init.defaultBranch >/dev/null 2>&1 || die "Git init.defaultBranch not configured."
  git config --global --get fetch.prune >/dev/null 2>&1 || die "Git fetch.prune not configured."

  if [[ -n "${GIT_USER_NAME:-}" && -n "${GIT_USER_EMAIL:-}" ]]; then
    local configured_name configured_email
    configured_name="$(git config --global --get user.name || true)"
    configured_email="$(git config --global --get user.email || true)"

    [[ "$configured_name" == "$GIT_USER_NAME" ]] || die "Git user.name mismatch."
    [[ "$configured_email" == "$GIT_USER_EMAIL" ]] || die "Git user.email mismatch."
  fi

  log_success "Git baseline configuration verified."
}

main() {
  command_exists git || die "git must be installed before git-baseline runs."
  write_bootstrap_gitconfig
  write_local_gitconfig
  ensure_gitconfig_includes
  verify_git_config
}

main "$@"