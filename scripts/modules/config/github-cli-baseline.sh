#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

BOOTSTRAP_GH_DIR="$HOME/.config/dev-bootstrap/gh"
GH_NOTES_FILE="$BOOTSTRAP_GH_DIR/README"

verify_protocol() {
  case "${GITHUB_GIT_PROTOCOL:-https}" in
    https|ssh) ;;
    *) die "Unsupported GITHUB_GIT_PROTOCOL: ${GITHUB_GIT_PROTOCOL}" ;;
  esac
}

write_notes() {
  mkdir -p "$BOOTSTRAP_GH_DIR"

  cat > "$GH_NOTES_FILE" <<EOF
GitHub CLI bootstrap notes

Configured git protocol: ${GITHUB_GIT_PROTOCOL:-https}

If not yet authenticated, run:
  gh auth login

Then verify with:
  gh auth status
EOF
}

configure_gh() {
  command_exists gh || die "gh must be installed before github-cli-baseline runs."

  verify_protocol

  log_info "Setting GitHub CLI git protocol to: ${GITHUB_GIT_PROTOCOL}"
  gh config set git_protocol "${GITHUB_GIT_PROTOCOL}"

  log_info "Checking GitHub CLI authentication status..."
  if gh auth status >/dev/null 2>&1; then
    gh auth status
    log_success "GitHub CLI authentication already configured."
  else
    log_warn "GitHub CLI is installed but not authenticated yet."
    log_warn "Run: gh auth login"
  fi
}

verify_gh_config() {
  local configured_protocol
  configured_protocol="$(gh config get git_protocol 2>/dev/null || true)"
  [[ "$configured_protocol" == "${GITHUB_GIT_PROTOCOL}" ]] || die "GitHub CLI git_protocol mismatch."
  log_success "GitHub CLI baseline configuration verified."
}

main() {
  write_notes
  configure_gh
  verify_gh_config
}

main "$@"