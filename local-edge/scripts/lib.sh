#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
LIB_DIR="${LIB_DIR:-$REPO_ROOT/scripts/lib}"
CONFIG_DIR="${CONFIG_DIR:-$REPO_ROOT/config}"

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

LOCAL_EDGE_DIR="$REPO_ROOT/local-edge"
LOCAL_EDGE_TEMPLATES_DIR="$LOCAL_EDGE_DIR/templates"
LOCAL_EDGE_EXAMPLES_DIR="$LOCAL_EDGE_DIR/examples"
LOCAL_EDGE_DOCS_DIR="$LOCAL_EDGE_DIR/docs"
LOCAL_EDGE_INIT_SENTINEL_NAME=".setup-complete"

load_local_edge_environment() {
  ensure_macos
  prepare_environment
  ensure_brew_available

  : "${LOCAL_EDGE_KIND_CLUSTER_NAME:=local-edge}"
  : "${LOCAL_EDGE_KIND_INGRESS_HTTP_PORT:=8080}"
  : "${LOCAL_EDGE_KIND_INGRESS_HTTPS_PORT:=8443}"
  : "${LOCAL_EDGE_CADDY_ADMIN_ADDRESS:=127.0.0.1:2019}"
  : "${LOCAL_EDGE_INGRESS_NGINX_MANIFEST_URL:=https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.14.0/deploy/static/provider/kind/deploy.yaml}"

  BREW_PREFIX="$(brew --prefix)"
  CADDY_BIN="$(command -v caddy || true)"
  if [[ -z "$CADDY_BIN" ]]; then
    CADDY_BIN="$BREW_PREFIX/bin/caddy"
  fi

  CADDY_DATA_HOME="$BREW_PREFIX/var/lib"
  CADDY_ROOT_CERT="$CADDY_DATA_HOME/caddy/pki/authorities/local/root.crt"
  CADDY_SERVICE_CADDYFILE="$BREW_PREFIX/etc/Caddyfile"

  LOCAL_EDGE_STATE_DIR="$HOME/.config/mac-dev-setup/local-edge"
  LOCAL_EDGE_CADDY_DIR="$LOCAL_EDGE_STATE_DIR/caddy"
  LOCAL_EDGE_CADDY_SITES_DIR="$LOCAL_EDGE_CADDY_DIR/sites.d"
  LOCAL_EDGE_KIND_DIR="$LOCAL_EDGE_STATE_DIR/kind"
  LOCAL_EDGE_RUNTIME_DIR="$LOCAL_EDGE_STATE_DIR/runtime"
  LOCAL_EDGE_BACKUPS_DIR="$LOCAL_EDGE_STATE_DIR/backups"
  LOCAL_EDGE_CADDY_BACKUPS_DIR="$LOCAL_EDGE_BACKUPS_DIR/caddy"
  LOCAL_EDGE_ARCHIVE_ROOT="$HOME/.config/mac-dev-setup/local-edge-archives"
  LOCAL_EDGE_MANAGED_CADDYFILE="$LOCAL_EDGE_CADDY_DIR/Caddyfile"
  LOCAL_EDGE_MANAGED_KIND_CONFIG="$LOCAL_EDGE_KIND_DIR/kind-edge.yaml"
  LOCAL_EDGE_CADDY_LINK_STATE_FILE="$LOCAL_EDGE_RUNTIME_DIR/homebrew-caddyfile-state"
  LOCAL_EDGE_SETUP_STATE_FILE="$LOCAL_EDGE_RUNTIME_DIR/$LOCAL_EDGE_INIT_SENTINEL_NAME"

  export LOCAL_EDGE_KIND_CLUSTER_NAME LOCAL_EDGE_KIND_INGRESS_HTTP_PORT
  export LOCAL_EDGE_KIND_INGRESS_HTTPS_PORT LOCAL_EDGE_CADDY_ADMIN_ADDRESS
  export LOCAL_EDGE_INGRESS_NGINX_MANIFEST_URL BREW_PREFIX CADDY_BIN
  export CADDY_DATA_HOME CADDY_ROOT_CERT CADDY_SERVICE_CADDYFILE
  export LOCAL_EDGE_STATE_DIR LOCAL_EDGE_CADDY_DIR LOCAL_EDGE_CADDY_SITES_DIR
  export LOCAL_EDGE_KIND_DIR LOCAL_EDGE_RUNTIME_DIR LOCAL_EDGE_BACKUPS_DIR
  export LOCAL_EDGE_CADDY_BACKUPS_DIR LOCAL_EDGE_ARCHIVE_ROOT
  export LOCAL_EDGE_MANAGED_CADDYFILE LOCAL_EDGE_MANAGED_KIND_CONFIG
  export LOCAL_EDGE_CADDY_LINK_STATE_FILE LOCAL_EDGE_SETUP_STATE_FILE
}

escape_sed_replacement() {
  printf '%s' "$1" | sed 's/[&|]/\\&/g'
}

ensure_local_edge_layout() {
  mkdir -p \
    "$CADDY_DATA_HOME" \
    "$LOCAL_EDGE_CADDY_DIR" \
    "$LOCAL_EDGE_CADDY_SITES_DIR" \
    "$LOCAL_EDGE_KIND_DIR" \
    "$LOCAL_EDGE_RUNTIME_DIR" \
    "$LOCAL_EDGE_CADDY_BACKUPS_DIR"
}

require_bootstrap_command() {
  local command_name="$1"
  local module_path="$2"

  command_exists "$command_name" || die "Missing required command: $command_name. Enable $module_path in scripts/bootstrap.sh and run bootstrap again."
}

require_caddy_installed() {
  [[ -x "$CADDY_BIN" ]] || die "Caddy is not installed. Re-run scripts/bootstrap.sh with scripts/modules/containers/caddy/caddy.sh enabled."
}

managed_caddy_link_active() {
  [[ -L "$CADDY_SERVICE_CADDYFILE" ]] && [[ "$(readlink "$CADDY_SERVICE_CADDYFILE")" == "$LOCAL_EDGE_MANAGED_CADDYFILE" ]]
}

mark_local_edge_setup_complete() {
  ensure_local_edge_layout
  cat > "$LOCAL_EDGE_SETUP_STATE_FILE" <<EOF_STATE
SETUP_TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
KIND_CLUSTER_NAME=$LOCAL_EDGE_KIND_CLUSTER_NAME
KIND_HTTP_PORT=$LOCAL_EDGE_KIND_INGRESS_HTTP_PORT
KIND_HTTPS_PORT=$LOCAL_EDGE_KIND_INGRESS_HTTPS_PORT
CADDYFILE=$LOCAL_EDGE_MANAGED_CADDYFILE
EOF_STATE
  chmod 644 "$LOCAL_EDGE_SETUP_STATE_FILE"
}

local_edge_setup_completed() {
  [[ -f "$LOCAL_EDGE_SETUP_STATE_FILE" ]]
}

require_local_edge_setup() {
  local command_label="${1:-this command}"

  local_edge_setup_completed || die "local-edge has not been set up yet for $command_label. Run ./scripts/bootstrap-local-edge.sh setup first."
  [[ -f "$LOCAL_EDGE_MANAGED_CADDYFILE" ]] || die "Managed Caddyfile missing at $LOCAL_EDGE_MANAGED_CADDYFILE. Re-run ./scripts/bootstrap-local-edge.sh setup."
  [[ -f "$LOCAL_EDGE_MANAGED_KIND_CONFIG" ]] || die "Managed kind config missing at $LOCAL_EDGE_MANAGED_KIND_CONFIG. Re-run ./scripts/bootstrap-local-edge.sh setup."
  managed_caddy_link_active || die "Homebrew's live Caddyfile is not linked to the managed local-edge config. Re-run ./scripts/bootstrap-local-edge.sh setup."
}

clear_local_edge_setup_state() {
  rm -f "$LOCAL_EDGE_SETUP_STATE_FILE"
}

docker_daemon_reachable() {
  docker info >/dev/null 2>&1
}

kind_context_name() {
  printf 'kind-%s\n' "$LOCAL_EDGE_KIND_CLUSTER_NAME"
}

kind_cluster_exists() {
  kind get clusters 2>/dev/null | grep -Fx "$LOCAL_EDGE_KIND_CLUSTER_NAME" >/dev/null
}

render_template_to_file() {
  local template_path="$1"
  local output_path="$2"
  local label="$3"
  local temp_file

  [[ -f "$template_path" ]] || die "Missing template: $template_path"

  temp_file="$(mktemp)"
  sed \
    -e "s|__LOCAL_EDGE_CADDY_SITES_DIR__|$(escape_sed_replacement "$LOCAL_EDGE_CADDY_SITES_DIR")|g" \
    -e "s|__LOCAL_EDGE_KIND_CLUSTER_NAME__|$(escape_sed_replacement "$LOCAL_EDGE_KIND_CLUSTER_NAME")|g" \
    -e "s|__LOCAL_EDGE_KIND_INGRESS_HTTP_PORT__|$(escape_sed_replacement "$LOCAL_EDGE_KIND_INGRESS_HTTP_PORT")|g" \
    -e "s|__LOCAL_EDGE_KIND_INGRESS_HTTPS_PORT__|$(escape_sed_replacement "$LOCAL_EDGE_KIND_INGRESS_HTTPS_PORT")|g" \
    -e "s|__LOCAL_EDGE_CADDY_ADMIN_ADDRESS__|$(escape_sed_replacement "$LOCAL_EDGE_CADDY_ADMIN_ADDRESS")|g" \
    < "$template_path" > "$temp_file"

  mkdir -p "$(dirname "$output_path")"

  if [[ ! -e "$output_path" ]]; then
    mv "$temp_file" "$output_path"
    chmod 644 "$output_path"
    log_success "Created $label at $output_path"
    return 0
  fi

  if cmp -s "$temp_file" "$output_path"; then
    rm -f "$temp_file"
    log_info "$label already up to date: $output_path"
    return 0
  fi

  rm -f "$temp_file"
  log_warn "$label already exists with local changes; leaving it in place: $output_path"
}

ensure_managed_caddy_link() {
  ensure_local_edge_layout

  if [[ -L "$CADDY_SERVICE_CADDYFILE" ]] && [[ "$(readlink "$CADDY_SERVICE_CADDYFILE")" == "$LOCAL_EDGE_MANAGED_CADDYFILE" ]]; then
    if [[ ! -f "$LOCAL_EDGE_CADDY_LINK_STATE_FILE" ]]; then
      printf 'ABSENT\n' > "$LOCAL_EDGE_CADDY_LINK_STATE_FILE"
    fi
    log_info "Homebrew Caddyfile already points at managed local-edge config."
    return 0
  fi

  if [[ ! -f "$LOCAL_EDGE_CADDY_LINK_STATE_FILE" ]]; then
    if [[ -e "$CADDY_SERVICE_CADDYFILE" || -L "$CADDY_SERVICE_CADDYFILE" ]]; then
      local backup_path="$LOCAL_EDGE_CADDY_BACKUPS_DIR/Caddyfile.pre-local-edge.$(date +%Y%m%d%H%M%S)"
      mv "$CADDY_SERVICE_CADDYFILE" "$backup_path"
      printf 'BACKUP=%s\n' "$backup_path" > "$LOCAL_EDGE_CADDY_LINK_STATE_FILE"
      log_warn "Backed up existing Homebrew Caddyfile to $backup_path"
    else
      printf 'ABSENT\n' > "$LOCAL_EDGE_CADDY_LINK_STATE_FILE"
    fi
  fi

  mkdir -p "$(dirname "$CADDY_SERVICE_CADDYFILE")"
  ln -sfn "$LOCAL_EDGE_MANAGED_CADDYFILE" "$CADDY_SERVICE_CADDYFILE"
  log_success "Linked $CADDY_SERVICE_CADDYFILE to managed local-edge Caddyfile."
}

restore_managed_caddy_link() {
  local prior_state=""

  if [[ -L "$CADDY_SERVICE_CADDYFILE" ]] && [[ "$(readlink "$CADDY_SERVICE_CADDYFILE")" == "$LOCAL_EDGE_MANAGED_CADDYFILE" ]]; then
    rm -f "$CADDY_SERVICE_CADDYFILE"
  fi

  if [[ -f "$LOCAL_EDGE_CADDY_LINK_STATE_FILE" ]]; then
    prior_state="$(<"$LOCAL_EDGE_CADDY_LINK_STATE_FILE")"
  fi

  case "$prior_state" in
    BACKUP=*)
      local backup_path="${prior_state#BACKUP=}"
      if [[ -e "$backup_path" || -L "$backup_path" ]]; then
        mv "$backup_path" "$CADDY_SERVICE_CADDYFILE"
        log_success "Restored previous Homebrew Caddyfile from $backup_path"
      else
        log_warn "Expected backup not found: $backup_path"
      fi
      ;;
    ABSENT|"")
      log_info "No pre-local-edge Homebrew Caddyfile to restore."
      ;;
    *)
      log_warn "Unknown Homebrew Caddyfile restore marker: $prior_state"
      ;;
  esac

  rm -f "$LOCAL_EDGE_CADDY_LINK_STATE_FILE"
}

ensure_managed_local_edge_files() {
  ensure_local_edge_layout

  render_template_to_file \
    "$LOCAL_EDGE_TEMPLATES_DIR/caddy/Caddyfile" \
    "$LOCAL_EDGE_MANAGED_CADDYFILE" \
    "managed local-edge Caddyfile"
  render_template_to_file \
    "$LOCAL_EDGE_TEMPLATES_DIR/caddy/sites.d/10-host-services.caddy" \
    "$LOCAL_EDGE_CADDY_SITES_DIR/10-host-services.caddy" \
    "host services sites file"
  render_template_to_file \
    "$LOCAL_EDGE_TEMPLATES_DIR/caddy/sites.d/20-kind-services.caddy" \
    "$LOCAL_EDGE_CADDY_SITES_DIR/20-kind-services.caddy" \
    "kind sites file"
  render_template_to_file \
    "$LOCAL_EDGE_TEMPLATES_DIR/kind/kind-edge.yaml" \
    "$LOCAL_EDGE_MANAGED_KIND_CONFIG" \
    "kind config"

  ensure_managed_caddy_link
}

run_managed_caddy() {
  require_caddy_installed
  env \
    XDG_DATA_HOME="$CADDY_DATA_HOME" \
    HOME="$CADDY_DATA_HOME" \
    PATH="$PATH" \
    "$CADDY_BIN" "$@"
}

validate_managed_caddyfile() {
  require_caddy_installed
  [[ -f "$LOCAL_EDGE_MANAGED_CADDYFILE" ]] || die "Managed Caddyfile not found at $LOCAL_EDGE_MANAGED_CADDYFILE. Run ./scripts/bootstrap-local-edge.sh setup first."
  run_managed_caddy validate --config "$LOCAL_EDGE_MANAGED_CADDYFILE"
}

brew_service_status() {
  local service_name="$1"
  brew services list 2>/dev/null | awk -v service_name="$service_name" '$1 == service_name {print $2}'
}

caddy_service_running() {
  local status=""
  status="$(brew_service_status "caddy")"
  [[ "$status" == "started" ]]
}

ensure_kind_ready_prereqs() {
  require_bootstrap_command "kind" "scripts/modules/containers/kind/kind.sh"
  require_bootstrap_command "kubectl" "scripts/modules/containers/kubectl/kubectl.sh"
  require_bootstrap_command "helm" "scripts/modules/containers/helm/helm.sh"
  require_bootstrap_command "docker" "scripts/modules/containers/docker/docker-cli.sh"
}

print_operator_next_steps() {
  cat <<EOF_STEPS

Next steps:
  ./scripts/bootstrap-local-edge.sh caddy start
  ./scripts/bootstrap-local-edge.sh caddy trust-certs
  ./scripts/bootstrap-local-edge.sh kind create
  ./scripts/bootstrap-local-edge.sh kind install-ingress-nginx   # optional example controller
  ./scripts/bootstrap-local-edge.sh examples up
  ./scripts/bootstrap-local-edge.sh smoke-test --include-kind --insecure

Managed local-edge state:
  Caddy config: $LOCAL_EDGE_MANAGED_CADDYFILE
  Kind config:  $LOCAL_EDGE_MANAGED_KIND_CONFIG
  Backups:      $LOCAL_EDGE_BACKUPS_DIR

Notes:
  - Only ./scripts/bootstrap-local-edge.sh setup provisions or links managed local-edge config.
  - Trusting the local Caddy CA changes the macOS trust store and will prompt for admin approval.
  - No /etc/hosts changes are made; *.localhost names resolve to loopback.
  - Kind ingress is exposed on 127.0.0.1:$LOCAL_EDGE_KIND_INGRESS_HTTP_PORT and 127.0.0.1:$LOCAL_EDGE_KIND_INGRESS_HTTPS_PORT so Caddy can keep 80 and 443.
EOF_STEPS
}
