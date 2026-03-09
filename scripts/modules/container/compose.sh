#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

PLUGIN_DIR="$HOME/.docker/cli-plugins"

main() {
  brew_install_formula "docker-compose"

  mkdir -p "$PLUGIN_DIR"

  if [[ -x /opt/homebrew/opt/docker-compose/bin/docker-compose ]]; then
    ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose "$PLUGIN_DIR/docker-compose"
  elif [[ -x /usr/local/opt/docker-compose/bin/docker-compose ]]; then
    ln -sfn /usr/local/opt/docker-compose/bin/docker-compose "$PLUGIN_DIR/docker-compose"
  else
    die "docker-compose plugin binary not found in Homebrew opt path."
  fi

  command_exists docker || die "docker command not found after install."
  log_info "Docker Compose version:"
  docker compose version

  log_success "Docker Compose installation verified."
}

main "$@"
