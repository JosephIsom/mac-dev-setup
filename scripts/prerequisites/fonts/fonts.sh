#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

FONT_CASKS=(
  font-fira-code
  font-fira-code-nerd-font
  font-fira-mono
  font-fira-mono-nerd-font
  font-hack
  font-hack-nerd-font
  font-inter
  font-jetbrains-mono
  font-jetbrains-mono-nerd-font
  font-open-sans
  font-roboto
  font-roboto-mono
  font-roboto-mono-nerd-font
)
USER_FONTS_DIR="$HOME/Library/Fonts"
FONT_BACKUP_DIR="$HOME/.config/mac-dev-setup/backups/fonts"

font_globs_for_cask() {
  local cask="$1"

  case "$cask" in
    font-fira-code)
      printf '%s\n' "FiraCode-*.ttf" "FiraCode-*.otf"
      ;;
    font-fira-code-nerd-font)
      printf '%s\n' "FiraCodeNerdFont*.ttf" "FiraCodeNerdFont*.otf"
      ;;
    font-fira-mono)
      printf '%s\n' "FiraMono-*.ttf" "FiraMono-*.otf"
      ;;
    font-fira-mono-nerd-font)
      printf '%s\n' "FiraMonoNerdFont*.ttf" "FiraMonoNerdFont*.otf"
      ;;
    font-hack)
      printf '%s\n' "Hack-*.ttf" "Hack-*.otf"
      ;;
    font-hack-nerd-font)
      printf '%s\n' "HackNerdFont*.ttf" "HackNerdFont*.otf"
      ;;
    font-inter)
      printf '%s\n' "Inter-*.ttf" "Inter-*.otf" "Inter*.ttf" "Inter*.otf"
      ;;
    font-jetbrains-mono)
      printf '%s\n' "JetBrainsMono-*.ttf" "JetBrainsMono-*.otf"
      ;;
    font-jetbrains-mono-nerd-font)
      printf '%s\n' "JetBrainsMono*NerdFont*.ttf" "JetBrainsMono*NerdFont*.otf"
      ;;
    font-open-sans)
      printf '%s\n' "OpenSans-*.ttf" "OpenSans-*.otf" "OpenSans*.ttf" "OpenSans*.otf"
      ;;
    font-roboto)
      printf '%s\n' "Roboto-*.ttf" "Roboto-*.otf"
      ;;
    font-roboto-mono)
      printf '%s\n' "RobotoMono-*.ttf" "RobotoMono-*.otf"
      ;;
    font-roboto-mono-nerd-font)
      printf '%s\n' "RobotoMonoNerdFont*.ttf" "RobotoMonoNerdFont*.otf"
      ;;
  esac
}

backup_conflicting_user_fonts() {
  local cask="$1"
  local pattern=""
  local font_path=""
  local moved_any="false"

  [[ -d "$USER_FONTS_DIR" ]] || return 0
  brew list --cask "$cask" >/dev/null 2>&1 && return 0

  while IFS= read -r pattern; do
    [[ -n "$pattern" ]] || continue

    for font_path in "$USER_FONTS_DIR"/$pattern; do
      [[ -e "$font_path" ]] || continue

      mkdir -p "$FONT_BACKUP_DIR"
      mv "$font_path" "$FONT_BACKUP_DIR/"
      moved_any="true"
      log_warn "Moved conflicting font file to $FONT_BACKUP_DIR: $(basename "$font_path")"
    done
  done < <(font_globs_for_cask "$cask")

  if [[ "$moved_any" == "true" ]]; then
    log_info "Backed up conflicting user-installed font files before installing $cask."
  fi
}

install_fonts() {
  local cask

  log_info "Installing system fonts with Homebrew casks..."
  for cask in "${FONT_CASKS[@]}"; do
    backup_conflicting_user_fonts "$cask"
    brew_install_cask "$cask"
  done
}

verify_fonts() {
  local cask

  for cask in "${FONT_CASKS[@]}"; do
    brew list --cask "$cask" >/dev/null 2>&1 || die "Font cask not installed: $cask"
  done

  log_success "Requested font casks verified."
  log_info "JetBrainsMono Nerd Font is the default monospace font for managed terminal/editor configs."
}

main() {
  install_fonts
  verify_fonts
}

main "$@"
