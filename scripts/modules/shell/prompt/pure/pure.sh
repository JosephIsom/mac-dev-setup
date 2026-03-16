#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_PURE_PLUGIN="$REPO_ROOT/scripts/modules/shell/prompt/pure/pure-plugin.zsh"
REPO_PURE_CONFIG="$REPO_ROOT/scripts/modules/shell/prompt/pure/pure-config.zsh"
TARGET_PROMPT_PLUGIN="$HOME/.zsh/plugins/50-prompt.zsh"
TARGET_PROMPT_PLUGIN_BACKUP="$TARGET_PROMPT_PLUGIN.pre-mac-dev-setup.bak"
TARGET_PURE_CONFIG="$HOME/.config/pure/config.zsh"

backup_unmanaged_prompt_plugin() {
  [[ -f "$TARGET_PROMPT_PLUGIN" ]] || return 0
  grep -Fq "mac-dev-setup managed prompt loader" "$TARGET_PROMPT_PLUGIN" && return 0

  if [[ -f "$TARGET_PROMPT_PLUGIN_BACKUP" ]]; then
    log_warn "Overwriting $TARGET_PROMPT_PLUGIN using existing backup at $TARGET_PROMPT_PLUGIN_BACKUP"
    return 0
  fi

  cp "$TARGET_PROMPT_PLUGIN" "$TARGET_PROMPT_PLUGIN_BACKUP"
  log_warn "Backed up existing unmanaged prompt plugin: $TARGET_PROMPT_PLUGIN -> $TARGET_PROMPT_PLUGIN_BACKUP"
}

copy_repo_file_if_missing() {
  local src="$1"
  local dest="$2"

  [[ -f "$src" ]] || die "Missing repo-managed file: $src"

  if [[ -f "$dest" ]]; then
    log_info "Preserving existing $dest"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  log_success "Created $dest from repo template"
}

install_pure_prompt() {
  backup_unmanaged_prompt_plugin
  install_managed_zsh_plugin "$REPO_PURE_PLUGIN" "$(basename "$TARGET_PROMPT_PLUGIN")" >/dev/null
  copy_repo_file_if_missing "$REPO_PURE_CONFIG" "$TARGET_PURE_CONFIG"
}

verify_pure() {
  brew list pure >/dev/null 2>&1 || die "Pure formula is not installed."
  [[ -f "$TARGET_PROMPT_PLUGIN" ]] || die "Prompt plugin file not found at $TARGET_PROMPT_PLUGIN"
  [[ -f "$TARGET_PURE_CONFIG" ]] || die "Pure config not found at $TARGET_PURE_CONFIG"

  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/50-prompt.zsh\" ]]"
  run_in_login_zsh "[[ -r \"$HOME/.config/pure/config.zsh\" ]]"
  run_in_login_zsh 'whence -w prompt_pure_setup >/dev/null 2>&1'

  log_success "Pure installation and zsh wiring verified."
}

main() {
  brew_install_formula "pure"
  install_pure_prompt
  verify_pure
}

main "$@"
