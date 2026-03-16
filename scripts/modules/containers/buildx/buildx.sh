#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  install_docker_cli_plugin "docker-buildx" "docker-buildx" "docker-buildx"
  command_exists docker || die "docker command not found after install."
  log_info "Docker Buildx version:"
  docker buildx version

  log_success "Docker Buildx installation verified."
}

main "$@"
