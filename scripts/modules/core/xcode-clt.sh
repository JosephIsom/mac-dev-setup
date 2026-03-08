#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

if xcode-select -p >/dev/null 2>&1; then
  log_success "Xcode Command Line Tools already installed."
  xcode-select -p
  exit 0
fi

log_warn "Xcode Command Line Tools are not installed."
log_info "Triggering Apple's installer..."

if xcode-select --install >/dev/null 2>&1; then
  :
else
  log_warn "macOS reported that the installer could not be started automatically."
fi

if xcode-select -p >/dev/null 2>&1; then
  log_success "Xcode Command Line Tools detected after installer trigger."
  xcode-select -p
  exit 0
fi

die "Xcode Command Line Tools installation has been triggered but is not complete yet. Finish the macOS install prompt, then re-run bootstrap."