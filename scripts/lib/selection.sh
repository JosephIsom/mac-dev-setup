#!/usr/bin/env bash

PROFILE="base"
NON_INTERACTIVE="false"
INTERACTIVE="true"

GIT_USER_NAME="${GIT_USER_NAME:-}"
GIT_USER_EMAIL="${GIT_USER_EMAIL:-}"
GITHUB_GIT_PROTOCOL="${GITHUB_GIT_PROTOCOL:-https}"

declare -a WITH_FLAGS=()
declare -a WITHOUT_FLAGS=()

ALL_SELECTION_VARS=(
  INSTALL_CORE_XCODE_CLT
  INSTALL_CORE_HOMEBREW
  INSTALL_CORE_GIT
  INSTALL_CORE_GITHUB_CLI
  INSTALL_CORE_CHEZMOI

  INSTALL_CONFIG_GIT_BASELINE
  INSTALL_CONFIG_GITHUB_CLI_BASELINE

  INSTALL_SHELL_ZSH_BASELINE
  INSTALL_SHELL_STARSHIP
  INSTALL_SHELL_FZF
  INSTALL_SHELL_ZOXIDE
  INSTALL_SHELL_EZA
  INSTALL_SHELL_BAT
  INSTALL_SHELL_RIPGREP
  INSTALL_SHELL_FD
  INSTALL_SHELL_JQ
  INSTALL_SHELL_YQ
  INSTALL_SHELL_DIRENV
  INSTALL_SHELL_TREE
  INSTALL_SHELL_WGET
  INSTALL_SHELL_TMUX
  INSTALL_SHELL_GIT_INTEGRATION
  INSTALL_SHELL_COMPLETION_CORE

  INSTALL_PYTHON_RUNTIME
  INSTALL_PYTHON_UV
  INSTALL_PYTHON_LINTERS
  INSTALL_PYTHON_PRE_COMMIT

  INSTALL_NODE_RUNTIME
  INSTALL_NODE_PNPM
  INSTALL_NODE_TYPESCRIPT
  INSTALL_NODE_BUN
  INSTALL_NODE_FRONTEND_TOOLS

  INSTALL_GO_RUNTIME
  INSTALL_GO_DEV_TOOLS

  INSTALL_JAVA_RUNTIME
  INSTALL_JAVA_MAVEN
  INSTALL_JAVA_GRADLE

  INSTALL_EDITOR_VSCODE_APP
  INSTALL_EDITOR_VSCODE_CLI
  INSTALL_EDITOR_VSCODE_EXTENSIONS_BASE
  INSTALL_EDITOR_INTELLIJ_TOOLBOX
  INSTALL_EDITOR_INTELLIJ_IDEA
  INSTALL_EDITOR_ITERM2_APP
  INSTALL_EDITOR_NEOVIM

  INSTALL_CONTAINERS_COLIMA
  INSTALL_CONTAINERS_DOCKER_CLI
  INSTALL_CONTAINERS_BUILDX
  INSTALL_CONTAINERS_COMPOSE
  INSTALL_CONTAINERS_LAZYDOCKER

  INSTALL_CLOUD_AWS
  INSTALL_CLOUD_GCLOUD
  INSTALL_CLOUD_AZURE
  INSTALL_CLOUD_KUBECTL
  INSTALL_CLOUD_HELM

  INSTALL_QUALITY_SHELLCHECK
  INSTALL_QUALITY_SHFMT
  INSTALL_QUALITY_MARKDOWNLINT
  INSTALL_QUALITY_YAMLLINT
  INSTALL_QUALITY_ACTIONLINT

  INSTALL_MACOS_FONTS_DEV
  INSTALL_MACOS_WINDOW_MANAGEMENT
  INSTALL_MACOS_APP_STORE_CLI
  INSTALL_MACOS_DEFAULTS

  INSTALL_OPTIONAL_NIX
  INSTALL_OPTIONAL_DIRENV_NIX
)

init_defaults() {
  local var
  for var in "${ALL_SELECTION_VARS[@]}"; do
    printf -v "$var" '%s' ''
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
        NON_INTERACTIVE="true"
        INTERACTIVE="false"
        shift
        ;;
      --interactive)
        NON_INTERACTIVE="false"
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
  cat <<'EOF'
Usage:
  ./scripts/bootstrap.sh [options]

Options:
  --profile <name>         Profile to use (default: base)
  --interactive            Enable prompts
  --non-interactive        Disable prompts
  --with-<module>          Force-enable a module
  --without-<module>       Force-disable a module
  -h, --help               Show help
EOF
}

profile_path() {
  printf '%s/profiles/%s.env' "$CONFIG_DIR" "$PROFILE"
}

load_profile() {
  local profile_file
  profile_file="$(profile_path)"
  [[ -f "$profile_file" ]] || die "Profile not found: $profile_file"
  log_info "Loading profile: $PROFILE"
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

validate_flag_targets() {
  local flag var_name found var

  if [[ ${#WITH_FLAGS[@]} -gt 0 ]]; then
    for flag in "${WITH_FLAGS[@]}"; do
      var_name="$(flag_to_var_name "$flag")"
      found="false"
      for var in "${ALL_SELECTION_VARS[@]}"; do
        if [[ "$var" == "$var_name" ]]; then
          found="true"
          break
        fi
      done
      [[ "$found" == "true" ]] || die "Unsupported module flag: $flag"
    done
  fi

  if [[ ${#WITHOUT_FLAGS[@]} -gt 0 ]]; then
    for flag in "${WITHOUT_FLAGS[@]}"; do
      var_name="$(flag_to_var_name "$flag")"
      found="false"
      for var in "${ALL_SELECTION_VARS[@]}"; do
        if [[ "$var" == "$var_name" ]]; then
          found="true"
          break
        fi
      done
      [[ "$found" == "true" ]] || die "Unsupported module flag: $flag"
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
  INSTALL_EDITOR_INTELLIJ_TOOLBOX="$(prompt_yes_no "Install JetBrains Toolbox?" "${INSTALL_EDITOR_INTELLIJ_TOOLBOX:-false}")"
  INSTALL_EDITOR_INTELLIJ_IDEA="$(prompt_yes_no "Install IntelliJ IDEA?" "${INSTALL_EDITOR_INTELLIJ_IDEA:-false}")"
  INSTALL_CONTAINERS_COLIMA="$(prompt_yes_no "Install Colima?" "${INSTALL_CONTAINERS_COLIMA:-false}")"
  INSTALL_CONTAINERS_DOCKER_CLI="$(prompt_yes_no "Install Docker CLI tooling?" "${INSTALL_CONTAINERS_DOCKER_CLI:-false}")"
  INSTALL_OPTIONAL_NIX="$(prompt_yes_no "Install Nix?" "${INSTALL_OPTIONAL_NIX:-false}")"

  if [[ "$INSTALL_EDITOR_VSCODE_APP" == "false" ]]; then
    INSTALL_EDITOR_VSCODE_CLI="false"
    INSTALL_EDITOR_VSCODE_EXTENSIONS_BASE="false"
  fi

  if [[ "$INSTALL_EDITOR_INTELLIJ_TOOLBOX" == "false" ]]; then
    INSTALL_EDITOR_INTELLIJ_IDEA="false"
  fi

  if [[ "$INSTALL_CONTAINERS_COLIMA" == "false" ]]; then
    INSTALL_CONTAINERS_DOCKER_CLI="false"
    INSTALL_CONTAINERS_BUILDX="false"
    INSTALL_CONTAINERS_COMPOSE="false"
    INSTALL_CONTAINERS_LAZYDOCKER="false"
  fi

  if [[ "$INSTALL_OPTIONAL_NIX" == "false" ]]; then
    INSTALL_OPTIONAL_DIRENV_NIX="false"
  fi
}

resolve_selection() {
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
  log_info "Resolved selections:"
  for var in "${ALL_SELECTION_VARS[@]}"; do
    printf '  %-34s %s\n' "$var" "${!var}"
  done
}