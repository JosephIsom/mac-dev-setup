#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

CLOUDFLARE_MODULES_DIR="$REPO_ROOT/scripts/modules/cloud/cloudflare"

main() {
  run_script_path "$CLOUDFLARE_MODULES_DIR/wrangler.sh"
}

main "$@"
