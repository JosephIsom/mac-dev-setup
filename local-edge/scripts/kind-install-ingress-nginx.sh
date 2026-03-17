#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib.sh"

main() {
  load_local_edge_environment
  require_local_edge_setup "kind install-ingress-nginx"
  ensure_kind_ready_prereqs

  kind_cluster_exists || die "kind cluster not found: $LOCAL_EDGE_KIND_CLUSTER_NAME. Run ./scripts/bootstrap-local-edge.sh kind create first."

  kubectl apply --context "$(kind_context_name)" -f "$LOCAL_EDGE_INGRESS_NGINX_MANIFEST_URL"
  kubectl wait \
    --context "$(kind_context_name)" \
    --namespace ingress-nginx \
    --for=condition=Ready \
    pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=180s

  log_success "Installed ingress-nginx for the kind local-edge cluster."
}

main "$@"
