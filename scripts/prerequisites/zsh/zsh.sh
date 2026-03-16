#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

REPO_ZSH_DIR="$REPO_ROOT/scripts/prerequisites/zsh"
REPO_ZSH_PLUGIN_DIR="$REPO_ZSH_DIR/plugins"
TARGET_ZSH_DIR="$HOME/.zsh"
TARGET_ZSHRC="$HOME/.zshrc"
TARGET_ZPROFILE="$HOME/.zprofile"
TARGET_ZSH_PLUGIN_DIR="$TARGET_ZSH_DIR/plugins"
TARGET_ZSH_VENDOR_DIR="$TARGET_ZSH_DIR/vendor"
LEGACY_ZSH_DIR="$HOME/.config/zsh"
LEGACY_ZSHENV="$HOME/.zshenv"
LEGACY_ZSHENV_BACKUP="$HOME/.zshenv.mac-dev-setup-xdg.bak"
ZSH_VENDOR_REPOS=(
  "https://github.com/zsh-users/zsh-completions.git|$TARGET_ZSH_VENDOR_DIR/zsh-completions|zsh-completions"
  "https://github.com/Aloxaf/fzf-tab.git|$TARGET_ZSH_VENDOR_DIR/fzf-tab|fzf-tab"
  "https://github.com/zsh-users/zsh-autosuggestions.git|$TARGET_ZSH_VENDOR_DIR/zsh-autosuggestions|zsh-autosuggestions"
  "https://github.com/catppuccin/zsh-syntax-highlighting.git|$TARGET_ZSH_VENDOR_DIR/catppuccin-zsh-syntax-highlighting|catppuccin-zsh-syntax-highlighting"
  "https://github.com/zsh-users/zsh-syntax-highlighting.git|$TARGET_ZSH_VENDOR_DIR/zsh-syntax-highlighting|zsh-syntax-highlighting"
)

copy_repo_file() {
  local src="$1"
  local dest="$2"

  [[ -f "$src" ]] || die "Missing repo-managed file: $src"
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
}

copy_repo_file_if_missing() {
  local src="$1"
  local dest="$2"

  [[ -f "$src" ]] || return 0
  if [[ -f "$dest" ]]; then
    log_info "Preserving existing $dest"
    return 0
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  log_success "Created $dest from repo template"
}

backup_if_unmanaged() {
  local dest="$1"
  local backup="$2"

  [[ -f "$dest" ]] || return 0
  grep -Fq "mac-dev-setup" "$dest" && return 0

  if [[ -f "$backup" ]]; then
    log_warn "Overwriting $dest using existing backup at $backup"
    return 0
  fi

  cp "$dest" "$backup"
  log_warn "Backed up existing unmanaged file: $dest -> $backup"
}

copy_dir_contents_if_missing() {
  local src_dir="$1"
  local dest_dir="$2"

  [[ -d "$src_dir" ]] || return 0
  mkdir -p "$dest_dir"

  for f in "$src_dir"/*; do
    [[ -f "$f" ]] || continue
    [[ "$(basename "$f")" == ".gitkeep" ]] && continue
    copy_repo_file_if_missing "$f" "$dest_dir/$(basename "$f")"
  done
}

copy_repo_dir_contents() {
  local src_dir="$1"
  local dest_dir="$2"
  local f

  [[ -d "$src_dir" ]] || return 0
  mkdir -p "$dest_dir"

  for f in "$src_dir"/*; do
    [[ -f "$f" ]] || continue
    [[ "$(basename "$f")" == ".gitkeep" ]] && continue
    copy_repo_file "$f" "$dest_dir/$(basename "$f")"
  done
}

retire_legacy_zshenv() {
  [[ -f "$LEGACY_ZSHENV" ]] || return 0

  if grep -Fq "export ZDOTDIR=\"\$XDG_CONFIG_HOME/zsh\"" "$LEGACY_ZSHENV"; then
    if [[ ! -f "$LEGACY_ZSHENV_BACKUP" ]]; then
      cp "$LEGACY_ZSHENV" "$LEGACY_ZSHENV_BACKUP"
      log_warn "Backed up legacy managed ~/.zshenv to $LEGACY_ZSHENV_BACKUP"
    fi
    rm -f "$LEGACY_ZSHENV"
    log_success "Removed legacy managed ~/.zshenv so zsh uses default startup files."
  fi
}

sync_zsh_vendor_plugins() {
  local repo_spec repo_url dest_dir label

  mkdir -p "$TARGET_ZSH_VENDOR_DIR"

  for repo_spec in "${ZSH_VENDOR_REPOS[@]}"; do
    IFS='|' read -r repo_url dest_dir label <<<"$repo_spec"
    sync_git_checkout "$repo_url" "$dest_dir" "$label"
  done
}

verify_zsh_setup() {
  command_exists zsh || die "zsh command not found."

  [[ -d "$TARGET_ZSH_VENDOR_DIR/zsh-completions/src" ]] || die "zsh-completions vendor repo not installed."
  [[ -f "$TARGET_ZSH_VENDOR_DIR/fzf-tab/fzf-tab.plugin.zsh" ]] || die "fzf-tab vendor repo not installed."
  [[ -f "$TARGET_ZSH_VENDOR_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] || die "zsh-autosuggestions vendor repo not installed."
  [[ -f "$TARGET_ZSH_VENDOR_DIR/catppuccin-zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh" ]] || die "Catppuccin syntax-highlighting theme not installed."
  [[ -f "$TARGET_ZSH_VENDOR_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] || die "zsh-syntax-highlighting vendor repo not installed."
  [[ -f "$TARGET_ZSH_PLUGIN_DIR/10-colored-man-pages.zsh" ]] || die "Managed zsh colored-man-pages plugin not installed."
  [[ -f "$TARGET_ZSH_PLUGIN_DIR/y0-fzf-tab.zsh" ]] || die "Managed zsh fzf-tab plugin loader not installed."
  [[ -f "$TARGET_ZSH_PLUGIN_DIR/y1-zsh-autosuggestions.zsh" ]] || die "Managed zsh autosuggestions plugin loader not installed."
  [[ -f "$TARGET_ZSH_PLUGIN_DIR/zz0-catppuccin-zsh-syntax-highlighting.zsh" ]] || die "Managed Catppuccin syntax-highlighting plugin loader not installed."
  [[ -f "$TARGET_ZSH_PLUGIN_DIR/zz1-zsh-syntax-highlighting.zsh" ]] || die "Managed zsh syntax-highlighting plugin loader not installed."

  log_info "Verifying zsh login shell configuration..."
  zsh -il -c 'command -v brew >/dev/null 2>&1'

  log_info "Verifying zsh completions..."
  zsh -il -c 'autoload -Uz compinit && compinit -d "$HOME/.zcompdump" && command -v _main_complete >/dev/null 2>&1 || true'

  if [[ "${SHELL:-}" != *"/zsh" ]]; then
    log_warn "Default shell does not appear to be zsh (SHELL=${SHELL:-unknown})."
    log_warn "If needed, change it with: chsh -s \"$(command -v zsh)\""
  fi
}

main() {
  command_exists zsh || die "zsh command not found."

  mkdir -p "$TARGET_ZSH_DIR/conf.d"
  mkdir -p "$TARGET_ZSH_PLUGIN_DIR"
  mkdir -p "$TARGET_ZSH_DIR/completions"
  mkdir -p "$TARGET_ZSH_VENDOR_DIR"

  retire_legacy_zshenv

  backup_if_unmanaged "$TARGET_ZPROFILE" "$TARGET_ZPROFILE.pre-mac-dev-setup.bak"
  backup_if_unmanaged "$TARGET_ZSHRC" "$TARGET_ZSHRC.pre-mac-dev-setup.bak"

  copy_repo_file "$REPO_ZSH_DIR/dot_zprofile" "$TARGET_ZPROFILE"
  copy_repo_file "$REPO_ZSH_DIR/dot_zshrc" "$TARGET_ZSHRC"

  # conf.d: deploy all; do not overwrite 90-local.zsh if it already exists
  for f in "$REPO_ZSH_DIR/conf.d/"*.zsh; do
    [[ -f "$f" ]] || continue
    base="$(basename "$f")"
    if [[ "$base" == "90-local.zsh" ]]; then
      if [[ -f "$LEGACY_ZSH_DIR/conf.d/$base" && ! -f "$TARGET_ZSH_DIR/conf.d/$base" ]]; then
        copy_repo_file_if_missing "$LEGACY_ZSH_DIR/conf.d/$base" "$TARGET_ZSH_DIR/conf.d/$base"
      fi
      copy_repo_file_if_missing "$f" "$TARGET_ZSH_DIR/conf.d/$base"
    else
      copy_repo_file "$f" "$TARGET_ZSH_DIR/conf.d/$base"
    fi
  done

  copy_dir_contents_if_missing "$LEGACY_ZSH_DIR/completions" "$TARGET_ZSH_DIR/completions"
  copy_dir_contents_if_missing "$LEGACY_ZSH_DIR/plugins" "$TARGET_ZSH_PLUGIN_DIR"
  copy_repo_dir_contents "$REPO_ZSH_DIR/completions" "$TARGET_ZSH_DIR/completions"
  copy_repo_dir_contents "$REPO_ZSH_PLUGIN_DIR" "$TARGET_ZSH_PLUGIN_DIR"
  sync_zsh_vendor_plugins

  verify_zsh_setup
  log_success "zsh configuration installed (~/.zshrc, ~/.zprofile, ~/.zsh/)."
}

main "$@"
