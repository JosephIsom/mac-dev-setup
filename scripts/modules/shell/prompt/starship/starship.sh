#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_STARSHIP_PLUGIN="$REPO_ROOT/scripts/modules/shell/prompt/starship/starship-plugin.zsh"
REPO_STARSHIP_CONFIG="$REPO_ROOT/scripts/modules/shell/prompt/starship/starship.toml"
TARGET_PROMPT_PLUGIN="$HOME/.zsh/plugins/50-prompt.zsh"
TARGET_PROMPT_PLUGIN_BACKUP="$TARGET_PROMPT_PLUGIN.pre-mac-dev-setup.bak"
TARGET_STARSHIP_CONFIG="$HOME/.config/starship.toml"

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

install_starship_prompt() {
  backup_unmanaged_prompt_plugin
  install_managed_zsh_plugin "$REPO_STARSHIP_PLUGIN" "$(basename "$TARGET_PROMPT_PLUGIN")" >/dev/null
  copy_repo_file_if_missing "$REPO_STARSHIP_CONFIG" "$TARGET_STARSHIP_CONFIG"
}

verify_starship() {
  [[ -f "$TARGET_PROMPT_PLUGIN" ]] || die "Prompt plugin file not found at $TARGET_PROMPT_PLUGIN"
  [[ -f "$TARGET_STARSHIP_CONFIG" ]] || die "Starship config not found at $TARGET_STARSHIP_CONFIG"

  run_in_login_zsh "[[ -r \"$HOME/.zsh/plugins/50-prompt.zsh\" ]]"
  run_in_login_zsh "[[ -r \"$HOME/.config/starship.toml\" ]]"
  run_in_login_zsh 'command -v starship >/dev/null 2>&1'
  run_in_login_zsh "[[ \"\${STARSHIP_CONFIG:-}\" == \"$HOME/.config/starship.toml\" ]]"
  run_in_login_zsh 'starship init zsh >/dev/null'

  log_warn "Starship works best with a Nerd Font enabled in your terminal."
  log_success "Starship installation and zsh wiring verified."
}

main() {
  brew_install_and_verify_command "starship" "starship" "starship" --version
  install_starship_prompt
  verify_starship
}

main "$@"
