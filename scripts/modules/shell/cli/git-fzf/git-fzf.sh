#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

TARGET_FORGIT_DIR="$HOME/.zsh/vendor/forgit"
REPO_GIT_FZF_PLUGIN="$REPO_ROOT/scripts/modules/shell/cli/git-fzf/git-fzf-plugin.zsh"
TARGET_GIT_FZF_PLUGIN="$HOME/.zsh/plugins/git-fzf-plugin.zsh"

install_git_fzf_plugin() {
  install_managed_zsh_plugin "$REPO_GIT_FZF_PLUGIN" "$(basename "$TARGET_GIT_FZF_PLUGIN")" >/dev/null
}

main() {
  sync_git_checkout "https://github.com/wfxr/forgit.git" "$TARGET_FORGIT_DIR" "forgit"
  install_git_fzf_plugin

  [[ -f "$TARGET_FORGIT_DIR/forgit.plugin.zsh" ]] || die "forgit plugin not found at $TARGET_FORGIT_DIR/forgit.plugin.zsh"
  [[ -f "$TARGET_GIT_FZF_PLUGIN" ]] || die "git-fzf zsh plugin not found at $TARGET_GIT_FZF_PLUGIN"
  run_in_login_zsh 'typeset -f forgit::add >/dev/null 2>&1'
  log_success "git-fzf integration verified."
}

main "$@"
