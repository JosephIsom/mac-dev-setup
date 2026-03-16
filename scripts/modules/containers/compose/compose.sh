#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

main() {
  install_docker_cli_plugin "docker-compose" "docker-compose" "docker-compose"
  command_exists docker || die "docker command not found after install."
  log_info "Docker Compose version:"
  docker compose version

  log_success "Docker Compose installation verified."
}

main "$@"
