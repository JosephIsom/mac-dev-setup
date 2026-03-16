#!/usr/bin/env bash
set -euo pipefail

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

GCP_MODULES_DIR="$REPO_ROOT/scripts/modules/cloud/gcp"

main() {
  run_script_path "$GCP_MODULES_DIR/gcloud-cli.sh"
}

main "$@"
