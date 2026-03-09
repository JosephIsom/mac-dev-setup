#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/common.sh"

PLUGIN_DIR="$HOME/.docker/cli-plugins"

main() {
  brew_install_formula "docker-buildx"

  mkdir -p "$PLUGIN_DIR"

  if [[ -x /opt/homebrew/opt/docker-buildx/bin/docker-buildx ]]; then
    ln -sfn /opt/homebrew/opt/docker-buildx/bin/docker-buildx "$PLUGIN_DIR/docker-buildx"
  elif [[ -x /usr/local/opt/docker-buildx/bin/docker-buildx ]]; then
    ln -sfn /usr/local/opt/docker-buildx/bin/docker-buildx "$PLUGIN_DIR/docker-buildx"
  else
    die "docker-buildx plugin binary not found in Homebrew opt path."
  fi

  command_exists docker || die "docker command not found after install."
  log_info "Docker Buildx version:"
  docker buildx version

  log_success "Docker Buildx installation verified."
}

main "$@"
