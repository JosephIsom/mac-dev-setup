#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

AZURE_MODULES_DIR="$REPO_ROOT/scripts/modules/cloud/azure"

main() {
  run_script_path "$AZURE_MODULES_DIR/azure-cli.sh"
}

main "$@"
