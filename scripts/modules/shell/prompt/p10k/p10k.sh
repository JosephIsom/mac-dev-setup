#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_P10K_PLUGIN="$REPO_ROOT/scripts/modules/shell/prompt/p10k/p10k-plugin.zsh"
REPO_P10K_CONFIG="$REPO_ROOT/scripts/modules/shell/prompt/p10k/p10k-config.zsh"
TARGET_PROMPT_PLUGIN="$HOME/.zsh/plugins/50-prompt.zsh"
TARGET_PROMPT_PLUGIN_BACKUP="$TARGET_PROMPT_PLUGIN.pre-mac-dev-setup.bak"
TARGET_P10K_DIR="$HOME/.local/share/powerlevel10k"
TARGET_P10K_THEME="$TARGET_P10K_DIR/powerlevel10k.zsh-theme"
TARGET_P10K_CONFIG="$HOME/.p10k.zsh"

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

install_powerlevel10k() {
  if [[ -f "$TARGET_P10K_THEME" ]]; then
    if [[ ! -d "$TARGET_P10K_DIR/.git" ]]; then
      log_info "Using existing Powerlevel10k install at $TARGET_P10K_DIR"
      return 0
    fi
  fi

  sync_git_checkout "https://github.com/romkatv/powerlevel10k.git" "$TARGET_P10K_DIR" "powerlevel10k"
}

install_p10k_prompt() {
  backup_unmanaged_prompt_plugin
  install_managed_zsh_plugin "$REPO_P10K_PLUGIN" "$(basename "$TARGET_PROMPT_PLUGIN")" >/dev/null
  copy_repo_file_if_missing "$REPO_P10K_CONFIG" "$TARGET_P10K_CONFIG"
}

verify_p10k() {
  command_exists git || die "git command not found."
  [[ -f "$TARGET_PROMPT_PLUGIN" ]] || die "Prompt plugin file not found at $TARGET_PROMPT_PLUGIN"
  [[ -f "$TARGET_P10K_THEME" ]] || die "Powerlevel10k theme file not found at $TARGET_P10K_THEME"
  [[ -f "$TARGET_P10K_CONFIG" ]] || die "Powerlevel10k config not found at $TARGET_P10K_CONFIG"

  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/50-prompt.zsh\" ]]"
  run_in_login_zsh "[[ -r \"$HOME/.p10k.zsh\" ]]"
  run_in_login_zsh '(( $+functions[p10k] ))'

  log_warn "Powerlevel10k works best with a Nerd Font enabled in your terminal."
  log_success "Powerlevel10k installation and zsh wiring verified."
}

main() {
  install_powerlevel10k
  install_p10k_prompt
  verify_p10k
}

main "$@"
