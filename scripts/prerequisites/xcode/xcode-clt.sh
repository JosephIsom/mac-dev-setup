#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

xcode_developer_dir() {
  xcode-select -p 2>/dev/null || true
}

has_xcode_developer_tools() {
  [[ -n "$(xcode_developer_dir)" ]]
}

log_xcode_developer_dir() {
  local developer_dir
  developer_dir="$(xcode_developer_dir)"

  if [[ -n "$developer_dir" ]]; then
    log_info "Active developer directory: $developer_dir"
  fi
}

trigger_xcode_clt_installer() {
  local install_output="" install_status=0

  install_output="$(xcode-select --install 2>&1)" || install_status=$?

  if [[ -n "$install_output" ]]; then
    printf '%s\n' "$install_output"
  fi

  if [[ "$install_status" -eq 0 ]]; then
    log_info "macOS accepted the install request."
    return 0
  fi

  if grep -qi 'already installed' <<<"$install_output"; then
    log_info "macOS reports that Command Line Tools are already installed."
    return 0
  fi

  if grep -qi 'install requested' <<<"$install_output"; then
    log_info "macOS reports that the install request is already in progress."
    return 0
  fi

  log_warn "macOS did not confirm that the installer was started automatically."
  return 1
}

main() {
  if has_xcode_developer_tools; then
    log_success "Apple developer tools already configured."
    log_xcode_developer_dir
    exit 0
  fi

  log_warn "Xcode Command Line Tools are not installed."
  log_info "They must be installed before Homebrew and the rest of bootstrap can continue."
  log_info "Triggering Apple's installer..."

  trigger_xcode_clt_installer || true

  if has_xcode_developer_tools; then
    log_success "Apple developer tools detected after installer trigger."
    log_xcode_developer_dir
    exit 0
  fi

  log_warn "If a macOS prompt appeared, finish that installation first."
  log_warn "If no prompt appeared, open System Settings > General > Software Update and install Command Line Tools."
  die "Xcode Command Line Tools are still unavailable. Re-run bootstrap after the installation finishes."
}

main "$@"
