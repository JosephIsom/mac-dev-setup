#!/usr/bin/env bash

PROFILE="base"
INTERACTIVE="true"

GIT_USER_NAME="${GIT_USER_NAME:-}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-}"
GITHUB_GIT_PROTOCOL="${GITHUB_GIT_PROTOCOL:-https}"

PYTHON_VERSION="${PYTHON_VERSION:-3.12}"
NODE_VERSION="${NODE_VERSION:-lts}"
GO_VERSION="${GO_VERSION:-latest}"
JAVA_VERSION="${JAVA_VERSION:-21}"

COLIMA_CPU="${COLIMA_CPU:-4}"
COLIMA_MEMORY="${COLIMA_MEMORY:-8}"
COLIMA_DISK="${COLIMA_DISK:-60}"

declare -a WITH_FLAGS=()
declare -a WITHOUT_FLAGS=()

# shellcheck disable=SC1091
source "$LIB_DIR/module-registry-generated.sh"

ALL_SELECTION_VARS=("${REGISTRY_SELECTION_VARS[@]}")

init_defaults() {
  local var
  for var in "${ALL_SELECTION_VARS[@]}"; do
    printf -v "$var" '%s' ''
  done
}

profile_exists_in_registry() {
  local candidate="$1"
  local profile

  for profile in "${REGISTRY_PROFILES[@]}"; do
    if [[ "$profile" == "$candidate" ]]; then
      return 0
    fi
  done

  return 1
}

apply_profile_defaults_from_registry() {
  local record profile var value

  profile_exists_in_registry "$PROFILE" || die "Unknown profile: $PROFILE"

  for record in "${REGISTRY_PROFILE_DEFAULT_RECORDS[@]}"; do
    IFS='|' read -r profile var value <<< "$record"
    [[ "$profile" == "$PROFILE" ]] || continue
    printf -v "$var" '%s' "$value"
  done
}

load_optional_user_config() {
  local user_file="$CONFIG_DIR/user.env"

  if [[ -f "$user_file" ]]; then
    # shellcheck disable=SC1090
    source "$user_file"
    log_info "Loaded user config: $user_file"
  else
    log_warn "Optional user config not found: $user_file"
  fi
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --profile)
        PROFILE="${2:-}"
        [[ -n "$PROFILE" ]] || die "Missing value for --profile"
        shift 2
        ;;
      --non-interactive)
        INTERACTIVE="false"
        shift
        ;;
      --interactive)
        INTERACTIVE="true"
        shift
        ;;
      --with-*)
        WITH_FLAGS+=("${1#--with-}")
        shift
        ;;
      --without-*)
        WITHOUT_FLAGS+=("${1#--without-}")
        shift
        ;;
      -h|--help)
        print_help
        exit 0
        ;;
      *)
        die "Unknown argument: $1"
        ;;
    esac
  done
}

print_help() {
  cat <<'EOF_HELP'
Usage:
  ./scripts/bootstrap.sh [options]

Options:
  --profile <name>         Profile to use (default: base)
  --interactive            Enable prompts
  --non-interactive        Disable prompts
  --with-<module>          Force-enable a module
  --without-<module>       Force-disable a module
  -h, --help               Show help
EOF_HELP
}

profile_path() {
  printf '%s/profiles/%s.env' "$CONFIG_DIR" "$PROFILE"
}

load_profile() {
  local profile_file
  profile_file="$(profile_path)"
  [[ -f "$profile_file" ]] || die "Profile not found: $profile_file"
  log_info "Loading profile overrides: $PROFILE"
  # shellcheck disable=SC1090
  source "$profile_file"
}

normalize_bool() {
  local value="${1:-}"
  case "$value" in
    true|TRUE|yes|YES|y|Y|1) printf 'true' ;;
    false|FALSE|no|NO|n|N|0) printf 'false' ;;
    "") printf '' ;;
    *) die "Invalid boolean value: $value" ;;
  esac
}

normalize_all_selection_vars() {
  local var value
  for var in "${ALL_SELECTION_VARS[@]}"; do
    value="${!var:-}"
    printf -v "$var" '%s' "$(normalize_bool "$value")"
  done
}

normalize_user_config() {
  case "${GITHUB_GIT_PROTOCOL:-https}" in
    https|ssh) ;;
    *) die "Invalid GITHUB_GIT_PROTOCOL: ${GITHUB_GIT_PROTOCOL}" ;;
  esac
}

flag_to_var_name() {
  local flag="$1"
  local normalized
  normalized="$(printf '%s' "$flag" | tr '[:lower:]-' '[:upper:]_')"
  printf 'INSTALL_%s' "$normalized"
}

selection_var_in_list() {
  local needle="$1"
  shift

  local item
  for item in "$@"; do
    if [[ "$item" == "$needle" ]]; then
      return 0
    fi
  done

  return 1
}

validate_flag_targets() {
  local flag var_name

  if [[ ${#WITH_FLAGS[@]} -gt 0 ]]; then
    for flag in "${WITH_FLAGS[@]}"; do
      var_name="$(flag_to_var_name "$flag")"
      if ! selection_var_in_list "$var_name" "${ALL_SELECTION_VARS[@]}"; then
        die "Unsupported module flag: $flag"
      fi
    done
  fi

  if [[ ${#WITHOUT_FLAGS[@]} -gt 0 ]]; then
    for flag in "${WITHOUT_FLAGS[@]}"; do
      var_name="$(flag_to_var_name "$flag")"
      if ! selection_var_in_list "$var_name" "${ALL_SELECTION_VARS[@]}"; then
        die "Unsupported module flag: $flag"
      fi
    done
  fi
}

apply_flag_overrides() {
  local flag var_name

  validate_flag_targets

  if [[ ${#WITH_FLAGS[@]} -gt 0 ]]; then
    for flag in "${WITH_FLAGS[@]}"; do
      var_name="$(flag_to_var_name "$flag")"
      printf -v "$var_name" 'true'
    done
  fi

  if [[ ${#WITHOUT_FLAGS[@]} -gt 0 ]]; then
    for flag in "${WITHOUT_FLAGS[@]}"; do
      var_name="$(flag_to_var_name "$flag")"
      printf -v "$var_name" 'false'
    done
  fi
}

set_selection_var() {
  local selection_var="$1"
  local value="$2"
  printf -v "$selection_var" '%s' "$value"
}

prompt_yes_no() {
  local prompt="$1"
  local default_value="$2"
  local reply default_hint

  case "$default_value" in
    true) default_hint="Y/n" ;;
    false) default_hint="y/N" ;;
    *) die "prompt_yes_no requires default true/false" ;;
  esac

  while true; do
    read -r -p "$prompt [$default_hint] " reply || true
    reply="${reply:-}"

    if [[ -z "$reply" ]]; then
      printf '%s\n' "$default_value"
      return 0
    fi

    case "$reply" in
      y|Y|yes|YES) printf 'true\n'; return 0 ;;
      n|N|no|NO) printf 'false\n'; return 0 ;;
      *) log_warn "Please answer y or n." ;;
    esac
  done
}

interactive_adjustments() {
  [[ "$INTERACTIVE" == "true" ]] || return 0

  log_info "Interactive selection enabled."

  INSTALL_EDITOR_ITERM2_APP="$(prompt_yes_no "Install iTerm2?" "${INSTALL_EDITOR_ITERM2_APP:-false}")"
  INSTALL_EDITOR_NEOVIM="$(prompt_yes_no "Install Neovim?" "${INSTALL_EDITOR_NEOVIM:-false}")"
  INSTALL_SHELL_TMUX="$(prompt_yes_no "Install tmux?" "${INSTALL_SHELL_TMUX:-false}")"
  INSTALL_GO_RUNTIME="$(prompt_yes_no "Install Golang tooling?" "${INSTALL_GO_RUNTIME:-false}")"
  INSTALL_EDITOR_VSCODE_APP="$(prompt_yes_no "Install VS Code?" "${INSTALL_EDITOR_VSCODE_APP:-false}")"
  INSTALL_EDITOR_VSCODE_CLI="$(prompt_yes_no "Set up VS Code CLI support?" "${INSTALL_EDITOR_VSCODE_CLI:-false}")"
  INSTALL_EDITOR_VSCODE_EXTENSIONS_BASE="$(prompt_yes_no "Install baseline VS Code extensions?" "${INSTALL_EDITOR_VSCODE_EXTENSIONS_BASE:-false}")"
  INSTALL_EDITOR_VSCODE_SETTINGS_BASE="$(prompt_yes_no "Install baseline VS Code settings scaffold?" "${INSTALL_EDITOR_VSCODE_SETTINGS_BASE:-false}")"
  INSTALL_EDITOR_INTELLIJ_TOOLBOX="$(prompt_yes_no "Install JetBrains Toolbox?" "${INSTALL_EDITOR_INTELLIJ_TOOLBOX:-false}")"
  INSTALL_EDITOR_INTELLIJ_IDEA="$(prompt_yes_no "Mark IntelliJ IDEA as expected/managed?" "${INSTALL_EDITOR_INTELLIJ_IDEA:-false}")"
  INSTALL_EDITOR_INTELLIJ_CLI="$(prompt_yes_no "Set up IntelliJ CLI helper?" "${INSTALL_EDITOR_INTELLIJ_CLI:-false}")"
  INSTALL_AI_CODEX_APP="$(prompt_yes_no "Install OpenAI Codex app?" "${INSTALL_AI_CODEX_APP:-false}")"
  INSTALL_AI_CODEX_CLI="$(prompt_yes_no "Install OpenAI Codex CLI?" "${INSTALL_AI_CODEX_CLI:-false}")"
  INSTALL_AI_CURSOR_EDITOR="$(prompt_yes_no "Install Cursor editor?" "${INSTALL_AI_CURSOR_EDITOR:-false}")"
  INSTALL_AI_CURSOR_CLI="$(prompt_yes_no "Install Cursor CLI?" "${INSTALL_AI_CURSOR_CLI:-false}")"
  INSTALL_AI_WINDSURF_EDITOR="$(prompt_yes_no "Install Windsurf editor?" "${INSTALL_AI_WINDSURF_EDITOR:-false}")"
  INSTALL_CONTAINERS_COLIMA="$(prompt_yes_no "Install Colima?" "${INSTALL_CONTAINERS_COLIMA:-false}")"
  INSTALL_CONTAINERS_DOCKER_CLI="$(prompt_yes_no "Install Docker CLI tooling?" "${INSTALL_CONTAINERS_DOCKER_CLI:-false}")"

  if [[ "$INSTALL_EDITOR_VSCODE_APP" == "false" ]]; then
    set_selection_var "INSTALL_EDITOR_VSCODE_CLI" "false"
    set_selection_var "INSTALL_EDITOR_VSCODE_EXTENSIONS_BASE" "false"
    set_selection_var "INSTALL_EDITOR_VSCODE_SETTINGS_BASE" "false"
  fi

  if [[ "$INSTALL_EDITOR_VSCODE_CLI" == "false" ]]; then
    set_selection_var "INSTALL_EDITOR_VSCODE_EXTENSIONS_BASE" "false"
  fi

  if [[ "$INSTALL_EDITOR_INTELLIJ_TOOLBOX" == "false" ]]; then
    set_selection_var "INSTALL_EDITOR_INTELLIJ_IDEA" "false"
    set_selection_var "INSTALL_EDITOR_INTELLIJ_CLI" "false"
  fi

  if [[ "$INSTALL_EDITOR_INTELLIJ_IDEA" == "false" ]]; then
    set_selection_var "INSTALL_EDITOR_INTELLIJ_CLI" "false"
  fi

  if [[ "$INSTALL_GO_RUNTIME" == "false" ]]; then
    set_selection_var "INSTALL_GO_DEV_TOOLS" "false"
  fi

  if [[ "$INSTALL_NODE_RUNTIME" == "false" ]]; then
    set_selection_var "INSTALL_NODE_PNPM" "false"
    set_selection_var "INSTALL_NODE_TYPESCRIPT" "false"
  fi

  if [[ "$INSTALL_JAVA_RUNTIME" == "false" ]]; then
    set_selection_var "INSTALL_JAVA_MAVEN" "false"
    set_selection_var "INSTALL_JAVA_GRADLE" "false"
  fi

  if [[ "$INSTALL_PYTHON_UV" == "false" ]]; then
    set_selection_var "INSTALL_PYTHON_LINTERS" "false"
    set_selection_var "INSTALL_PYTHON_PRE_COMMIT" "false"
  fi

  if [[ "$INSTALL_CONTAINERS_COLIMA" == "false" ]]; then
    set_selection_var "INSTALL_CONTAINERS_DOCKER_CLI" "false"
    set_selection_var "INSTALL_CONTAINERS_BUILDX" "false"
    set_selection_var "INSTALL_CONTAINERS_COMPOSE" "false"
  fi

  if [[ "$INSTALL_CONTAINERS_DOCKER_CLI" == "false" ]]; then
    set_selection_var "INSTALL_CONTAINERS_BUILDX" "false"
    set_selection_var "INSTALL_CONTAINERS_COMPOSE" "false"
  fi
}

resolve_selection() {
  apply_profile_defaults_from_registry
  load_profile
  load_optional_user_config
  normalize_all_selection_vars
  normalize_user_config
  apply_flag_overrides
  normalize_all_selection_vars
  interactive_adjustments
  normalize_all_selection_vars
}

print_selection_summary() {
  local var
  log_info "Profile: $PROFILE"
  log_info "Interactive: $INTERACTIVE"
  log_info "Git identity name set: $([[ -n "${GIT_USER_NAME:-}" ]] && printf yes || printf no)"
  log_info "Git identity email set: $([[ -n "${GIT_USER_EMAIL:-}" ]] && printf yes || printf no)"
  log_info "GitHub protocol: ${GITHUB_GIT_PROTOCOL:-https}"
  log_info "Runtime versions: python=${PYTHON_VERSION} node=${NODE_VERSION} go=${GO_VERSION} java=${JAVA_VERSION}"
  log_info "Colima resources: cpu=${COLIMA_CPU} memory=${COLIMA_MEMORY}GiB disk=${COLIMA_DISK}GiB"
  log_info "Resolved selections:"
  for var in "${ALL_SELECTION_VARS[@]}"; do
    printf '  %-34s %s\n' "$var" "${!var}"
  done
}
