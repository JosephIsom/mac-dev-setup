#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

main() {
  command_exists docker || die "docker-verify requires Docker CLI."
  command_exists colima || die "docker-verify requires Colima."

  if ! colima status 2>&1 | grep -qi 'running'; then
    die "Colima is not running. Start Colima before Docker verification."
  fi

  log_info "Docker version:"
  docker version

  log_info "Docker info:"
  docker info >/dev/null
  log_success "docker info succeeded."

  log_info "Docker Buildx version:"
  docker buildx version

  log_info "Docker Compose version:"
  docker compose version

  log_info "Running hello-world container..."
  docker run --rm hello-world >/dev/null

  log_success "Docker stack verification succeeded."
}

main "$@"
