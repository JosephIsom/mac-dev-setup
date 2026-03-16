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

install_fonts() {
  local cask

  log_info "Installing system fonts with Homebrew casks..."
  for cask in "${FONT_CASKS[@]}"; do
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
