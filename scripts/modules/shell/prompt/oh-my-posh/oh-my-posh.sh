#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_OMP_PLUGIN="$REPO_ROOT/scripts/modules/shell/prompt/oh-my-posh/oh-my-posh-plugin.zsh"
REPO_OMP_CONFIG="$REPO_ROOT/scripts/modules/shell/prompt/oh-my-posh/oh-my-posh.omp.json"
TARGET_PROMPT_PLUGIN="$HOME/.zsh/plugins/50-prompt.zsh"
TARGET_PROMPT_PLUGIN_BACKUP="$TARGET_PROMPT_PLUGIN.pre-mac-dev-setup.bak"
TARGET_OMP_CONFIG="$HOME/.config/ohmyposh/config.omp.json"

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

install_omp_prompt() {
  backup_unmanaged_prompt_plugin
  install_managed_zsh_plugin "$REPO_OMP_PLUGIN" "$(basename "$TARGET_PROMPT_PLUGIN")" >/dev/null
  copy_repo_file_if_missing "$REPO_OMP_CONFIG" "$TARGET_OMP_CONFIG"
}

verify_omp() {
  [[ -f "$TARGET_PROMPT_PLUGIN" ]] || die "Prompt plugin file not found at $TARGET_PROMPT_PLUGIN"
  [[ -f "$TARGET_OMP_CONFIG" ]] || die "Oh My Posh config not found at $TARGET_OMP_CONFIG"

  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/50-prompt.zsh\" ]]"
  run_in_login_zsh "[[ -r \"$HOME/.config/ohmyposh/config.omp.json\" ]]"
  run_in_login_zsh 'command -v oh-my-posh >/dev/null 2>&1'
  run_in_login_zsh "oh-my-posh init zsh --config \"$HOME/.config/ohmyposh/config.omp.json\" >/dev/null"

  log_warn "Oh My Posh works best with a Nerd Font enabled in your terminal."
  log_success "Oh My Posh installation and zsh wiring verified."
}

main() {
  brew_install_formula "jandedobbeleer/oh-my-posh/oh-my-posh"
  command_exists oh-my-posh || die "oh-my-posh command not found after installation."
  install_omp_prompt
  verify_omp
}

main "$@"
