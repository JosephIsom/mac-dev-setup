#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  command_exists colima || die "colima-start requires Colima to be installed."

  if colima status 2>&1 | grep -qi 'running'; then
    log_success "Colima is already running."
  else
    log_info "Starting Colima with cpu=${COLIMA_CPU}, memory=${COLIMA_MEMORY}GiB, disk=${COLIMA_DISK}GiB..."
    colima start --cpu "$COLIMA_CPU" --memory "$COLIMA_MEMORY" --disk "$COLIMA_DISK"
  fi

  log_info "Colima status:"
  colima status

  log_success "Colima start verified."
}

main "$@"
