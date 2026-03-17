#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

find_vscode_app() {
  local candidate

  for candidate in \
    "/Applications/Visual Studio Code.app" \
    "$HOME/Applications/Visual Studio Code.app"; do
    if [[ -d "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

main() {
  local app_path=""

  if app_path="$(find_vscode_app 2>/dev/null)"; then
    log_warn "VS Code already exists at $app_path. Leaving the existing app in place."
  else
    brew_install_cask "visual-studio-code"

    if brew list --cask "visual-studio-code" >/dev/null 2>&1; then
      app_path="$(find_vscode_app 2>/dev/null || true)"
      if [[ -z "$app_path" ]]; then
        log_warn "Homebrew reports visual-studio-code is installed, but the app bundle was not found in a standard Applications directory."
        log_info "Reinstalling VS Code cask to restore the app bundle..."
        brew reinstall --cask "visual-studio-code"
      fi
    fi
  fi

  app_path="$(find_vscode_app 2>/dev/null || true)"
  [[ -n "$app_path" ]] || die "VS Code app not found in /Applications or ~/Applications after installation."

  log_success "VS Code installation verified at $app_path."
}

main "$@"
