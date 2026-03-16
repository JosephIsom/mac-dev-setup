#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

FLYIO_MODULES_DIR="$REPO_ROOT/scripts/modules/cloud/flyio"

main() {
  run_script_path "$FLYIO_MODULES_DIR/flyctl.sh"
}

main "$@"
