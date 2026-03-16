#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

DIGITALOCEAN_MODULES_DIR="$REPO_ROOT/scripts/modules/cloud/digitalocean"

main() {
  run_script_path "$DIGITALOCEAN_MODULES_DIR/doctl.sh"
}

main "$@"
