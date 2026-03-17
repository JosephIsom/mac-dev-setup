#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$REPO_ROOT/scripts/lib"
CONFIG_DIR="$REPO_ROOT/config"
MODULES_DIR="$REPO_ROOT/scripts/modules"
PREREQUISITES_DIR="$REPO_ROOT/scripts/prerequisites"
export REPO_ROOT LIB_DIR CONFIG_DIR MODULES_DIR PREREQUISITES_DIR

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

print_help() {
  cat <<'EOF_HELP'
Usage:
  ./scripts/verify.sh

Edit this file directly to comment out optional checks that do not match your bootstrap choices.
EOF_HELP
}

parse_verify_args() {
  if [[ $# -eq 0 ]]; then
    return 0
  fi

  case "$1" in
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      die "Unknown argument: $1"
      ;;
  esac
}

pass() {
  printf '[PASS] %s\n' "$1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

warn() {
  printf '[WARN] %s\n' "$1"
  WARN_COUNT=$((WARN_COUNT + 1))
}

fail_check() {
  printf '[FAIL] %s\n' "$1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

record_by_severity() {
  local severity="$1"
  local label="$2"

  if [[ "$severity" == "warn" ]]; then
    warn "$label"
  else
    fail_check "$label"
  fi
}

command_available_in_zsh() {
  local cmd="$1"
  zsh -lc "command -v $cmd >/dev/null 2>&1"
}

run_check_cmd() {
  local cmd="$1"
  local label="$2"
  local severity="$3"

  if command_available_in_zsh "$cmd"; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_login_zsh() {
  local cmd="$1"
  local label="$2"
  local severity="$3"

  if zsh -il -c "$cmd"; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_file() {
  local path="$1"
  local label="$2"
  local severity="$3"

  if [[ -e "$path" ]]; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_dir() {
  local path="$1"
  local label="$2"
  local severity="$3"

  if [[ -d "$path" ]]; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_brew_cask() {
  local cask="$1"
  local label="$2"
  local severity="$3"

  if brew list --cask "$cask" >/dev/null 2>&1; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_vscode_extensions_from_manifests() {
  local manifests_dir="$HOME/.config/mac-dev-setup/vscode/extensions"
  local manifest_path
  local extension_id
  local severity="${1:-warn}"

  if [[ ! -d "$manifests_dir" ]]; then
    record_by_severity "$severity" "Managed VS Code extension manifests present"
    return 0
  fi

  while IFS= read -r manifest_path; do
    while IFS= read -r extension_id; do
      if [[ -z "$extension_id" || "$extension_id" == \#* ]]; then
        continue
      fi

      run_check_login_zsh "code --list-extensions | grep -Fix '$extension_id' >/dev/null" "VS Code extension installed: $extension_id" "$severity"
    done < "$manifest_path"
  done < <(find "$manifests_dir" -type f -name '*-vscode-extensions.txt' | sort)
}

run_check_colima_running() {
  local label="$1"
  local severity="$2"

  if zsh -lc 'colima status 2>&1 | grep -qi running'; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_docker_reachable() {
  local label="$1"
  local severity="$2"

  if zsh -lc 'docker info >/dev/null 2>&1'; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

run_check_cursor_cli() {
  local label="$1"
  local severity="$2"

  if zsh -lc 'command -v cursor-agent >/dev/null 2>&1 || command -v cursor >/dev/null 2>&1'; then
    pass "$label"
  else
    record_by_severity "$severity" "$label"
  fi
}

main() {
  parse_verify_args "$@"
  ensure_macos
  prepare_environment

  printf '\n'
  printf '========================================\n'
  printf 'mac-dev-setup verify\n'
  printf '========================================\n'
  printf '\n'

  # Prerequisites
  run_check_cmd "brew" "Homebrew available" fail
  run_check_cmd "git" "Git available" fail
  run_check_cmd "mise" "mise available" fail
  run_check_file "$HOME/.zshrc" "Managed zsh bootstrap present" fail
  run_check_file "$HOME/.ssh/config" "SSH config present" fail
  run_check_brew_cask "font-fira-code" "Fira Code font installed" fail
  run_check_brew_cask "font-fira-code-nerd-font" "Fira Code Nerd Font installed" fail
  run_check_brew_cask "font-fira-mono" "Fira Mono font installed" fail
  run_check_brew_cask "font-fira-mono-nerd-font" "Fira Mono Nerd Font installed" fail
  run_check_brew_cask "font-hack" "Hack font installed" fail
  run_check_brew_cask "font-hack-nerd-font" "Hack Nerd Font installed" fail
  run_check_brew_cask "font-inter" "Inter font installed" fail
  run_check_brew_cask "font-jetbrains-mono" "JetBrains Mono font installed" fail
  run_check_brew_cask "font-jetbrains-mono-nerd-font" "JetBrains Mono Nerd Font installed" fail
  run_check_brew_cask "font-open-sans" "Open Sans font installed" fail
  run_check_brew_cask "font-roboto" "Roboto font installed" fail
  run_check_brew_cask "font-roboto-mono" "Roboto Mono font installed" fail
  run_check_brew_cask "font-roboto-mono-nerd-font" "Roboto Mono Nerd Font installed" fail
  run_check_dir "$HOME/.zsh/vendor/zsh-completions" "zsh-completions installed" fail
  run_check_dir "$HOME/.zsh/vendor/fzf-tab" "fzf-tab installed" fail
  run_check_dir "$HOME/.zsh/vendor/zsh-autosuggestions" "zsh-autosuggestions installed" fail
  run_check_dir "$HOME/.zsh/vendor/zsh-syntax-highlighting" "zsh-syntax-highlighting installed" fail

  printf '\n'
  log_info "Optional checks below should match the uncommented module lines in scripts/bootstrap.sh."

  # macOS defaults
  run_check_login_zsh "[[ \"\$(defaults read NSGlobalDomain AppleShowAllExtensions 2>/dev/null)\" == \"1\" ]]" "Finder shows all filename extensions" warn
  run_check_login_zsh "[[ \"\$(defaults read com.apple.finder ShowPathbar 2>/dev/null)\" == \"1\" ]]" "Finder path bar enabled" warn
  run_check_login_zsh "[[ \"\$(defaults read com.apple.dock autohide 2>/dev/null)\" == \"1\" ]]" "Dock auto-hide enabled" warn
  run_check_login_zsh "[[ \"\$(defaults read NSGlobalDomain ApplePressAndHoldEnabled 2>/dev/null)\" == \"0\" ]]" "Press-and-hold disabled for key repeat" warn
  run_check_dir "$HOME/Pictures/Screenshots" "Screenshot directory present" warn

  # Core / account tooling
  run_check_cmd "gh" "GitHub CLI available" fail
  run_check_file "$HOME/.ssh/config.d/10-github.conf" "GitHub SSH config present" fail

  # Shell / terminal
  run_check_cmd "fzf" "fzf available" warn
  run_check_file "$HOME/.zsh/plugins/git-fzf-plugin.zsh" "git-fzf zsh plugin present" fail
  run_check_dir "$HOME/.zsh/vendor/forgit" "forgit vendor checkout present" fail
  run_check_login_zsh 'typeset -f forgit::add >/dev/null 2>&1' "git-fzf integration available" warn
  run_check_cmd "zoxide" "zoxide available" warn
  run_check_cmd "eza" "eza available" warn
  run_check_cmd "bat" "bat available" warn
  run_check_cmd "rg" "ripgrep available" warn
  run_check_cmd "fd" "fd available" warn
  run_check_cmd "jq" "jq available" warn
  run_check_cmd "yq" "yq available" warn
  run_check_cmd "direnv" "direnv available" warn
  run_check_cmd "tree" "tree available" warn
  run_check_cmd "wget" "wget available" warn
  run_check_cmd "tldr" "tldr available" warn
  run_check_cmd "btm" "bottom available" warn
  run_check_cmd "lazygit" "lazygit available" warn
  run_check_cmd "lazydocker" "lazydocker available" warn
  run_check_cmd "jwt" "jwt-cli available" warn
  run_check_cmd "delta" "git-delta available" warn
  run_check_cmd "watch" "watch available" warn
  run_check_login_zsh "[[ \"\$(command -v curl)\" == \"/opt/homebrew/opt/curl/bin/curl\" || \"\$(command -v curl)\" == \"/usr/local/opt/curl/bin/curl\" ]]" "Homebrew curl active" warn
  run_check_cmd "http" "HTTPie CLI available" warn
  run_check_login_zsh 'make --version | grep -F "GNU Make" >/dev/null' "GNU make active as make" warn
  run_check_cmd "cmake" "cmake available" warn
  run_check_cmd "premake5" "premake available" warn
  run_check_cmd "tmux" "tmux available" warn
  run_check_file "$HOME/.tmux.conf" "Managed tmux config present" fail
  run_check_dir "$HOME/.tmux/plugins/tpm" "TPM installed" fail
  run_check_dir "$HOME/.tmux/plugins/tmux-resurrect" "tmux-resurrect installed" fail
  run_check_dir "$HOME/.tmux/plugins/tmux-continuum" "tmux-continuum installed" fail

  # Language runtimes and tooling
  run_check_cmd "python" "Python available" fail
  run_check_cmd "uv" "uv available" fail
  run_check_cmd "pyright" "Pyright available" warn
  run_check_cmd "pyright-langserver" "Pyright language server available" warn
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/tasks/python-vscode-tasks.jsonc" "Python VS Code tasks template present" warn
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/launch/python-vscode-launch.jsonc" "Python VS Code launch template present" warn
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/workspace/python-vscode-workspace.code-workspace" "Python VS Code workspace template present" warn
  run_check_cmd "node" "Node available" fail
  run_check_cmd "npm" "npm available" fail
  run_check_file "$HOME/.zsh/plugins/npm-completion.zsh" "npm zsh completion plugin present" fail
  run_check_login_zsh 'npm completion >/dev/null 2>&1' "npm completion available" warn
  run_check_cmd "pnpm" "pnpm available" fail
  run_check_cmd "yarn" "Yarn available" fail
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/tasks/javascript-vscode-tasks.jsonc" "JavaScript VS Code tasks template present" warn
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/tasks/typescript-vscode-tasks.jsonc" "TypeScript VS Code tasks template present" warn
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/launch/typescript-vscode-launch.jsonc" "TypeScript VS Code launch template present" warn
  run_check_cmd "go" "Go available" fail
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/tasks/go-vscode-tasks.jsonc" "Go VS Code tasks template present" warn
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/launch/go-vscode-launch.jsonc" "Go VS Code launch template present" warn
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/workspace/go-vscode-workspace.code-workspace" "Go VS Code workspace template present" warn
  run_check_cmd "java" "Java available" fail
  run_check_cmd "jdtls" "Java language server available" warn
  run_check_cmd "google-java-format" "google-java-format available" warn
  run_check_cmd "mvn" "Maven available" fail
  run_check_cmd "gradle" "Gradle available" fail
  run_check_cmd "lua" "Lua available" fail
  run_check_cmd "lua-language-server" "Lua language server available" warn
  run_check_cmd "stylua" "stylua available" warn
  run_check_cmd "luacheck" "luacheck available" warn
  run_check_cmd "swift" "Swift available" fail
  run_check_login_zsh 'xcrun sourcekit-lsp --help >/dev/null 2>&1' "sourcekit-lsp available" warn
  run_check_cmd "swiftlint" "SwiftLint available" warn
  run_check_cmd "swiftformat" "SwiftFormat available" warn

  # Cloud
  run_check_cmd "aws" "AWS CLI available" warn
  run_check_cmd "awslocal" "AWS CLI Local available" warn
  run_check_cmd "okta-aws-cli" "okta-aws-cli available" warn
  run_check_cmd "aws-sso" "aws-sso-cli available" warn
  run_check_cmd "aws-vault" "AWS Vault available" warn
  run_check_cmd "localstack" "LocalStack available" warn
  run_check_dir "$HOME/.aws" "AWS config directory present" fail
  run_check_file "$HOME/.aws/config" "AWS config present" fail
  run_check_file "$HOME/.aws/credentials" "AWS credentials present" fail
  run_check_file "$HOME/.zsh/plugins/aws-completion.zsh" "AWS CLI zsh completion plugin present" fail
  run_check_login_zsh 'command -v aws_completer >/dev/null 2>&1' "AWS CLI completer available" warn
  run_check_login_zsh 'complete -p aws 2>/dev/null | grep -F "aws_completer" >/dev/null' "AWS CLI completion registered" warn
  run_check_login_zsh 'if command -v awslocal >/dev/null 2>&1; then complete -p awslocal 2>/dev/null | grep -F "aws_completer" >/dev/null; else exit 1; fi' "AWS CLI Local completion registered" warn
  # run_check_cmd "gcloud" "Google Cloud CLI available" warn
  # run_check_cmd "az" "Azure CLI available" warn
  # run_check_cmd "doctl" "doctl available" warn
  # run_check_cmd "wrangler" "Cloudflare Wrangler available" warn
  # run_check_login_zsh 'command -v fly >/dev/null 2>&1 || command -v flyctl >/dev/null 2>&1' "Fly.io CLI available" warn
  # run_check_file "$HOME/.zsh/plugins/gcloud-plugin.zsh" "Google Cloud zsh plugin present" fail
  # run_check_file "$HOME/.zsh/plugins/doctl-plugin.zsh" "doctl zsh plugin present" fail
  # run_check_file "$HOME/.zsh/plugins/wrangler-plugin.zsh" "Wrangler zsh plugin present" fail
  # run_check_file "$HOME/.zsh/plugins/flyctl-plugin.zsh" "Fly.io zsh plugin present" fail
  # run_check_login_zsh 'doctl completion zsh >/dev/null 2>&1' "doctl completion available" warn
  # run_check_login_zsh 'wrangler complete zsh >/dev/null 2>&1' "Wrangler completion available" warn
  # run_check_login_zsh 'if command -v fly >/dev/null 2>&1; then fly completion zsh >/dev/null 2>&1 || fly version -c zsh >/dev/null 2>&1; elif command -v flyctl >/dev/null 2>&1; then flyctl completion zsh >/dev/null 2>&1 || flyctl version -c zsh >/dev/null 2>&1; else exit 1; fi' "Fly.io completion available" warn

  # Containers
  run_check_cmd "colima" "Colima available" fail
  run_check_cmd "docker" "Docker CLI available" fail
  run_check_file "$HOME/.zsh/plugins/docker-completion.zsh" "Docker zsh completion plugin present" fail
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/tasks/docker-vscode-tasks.jsonc" "Docker VS Code tasks template present" warn
  run_check_login_zsh 'docker completion zsh >/dev/null 2>&1' "Docker completion available" warn
  run_check_cmd "caddy" "Caddy available" warn
  run_check_cmd "kind" "kind available" warn
  run_check_cmd "kubectl" "kubectl available" warn
  run_check_file "$HOME/.zsh/plugins/kubectl-completion.zsh" "kubectl zsh completion plugin present" fail
  run_check_login_zsh 'kubectl completion zsh >/dev/null 2>&1' "kubectl completion available" warn
  run_check_cmd "helm" "Helm available" warn
  run_check_file "$HOME/.zsh/plugins/helm-completion.zsh" "Helm zsh completion plugin present" fail
  run_check_login_zsh 'helm completion zsh >/dev/null 2>&1' "Helm completion available" warn
  run_check_cmd "k9s" "k9s available" warn
  run_check_cmd "tilt" "Tilt available" warn
  run_check_file "$HOME/.config/mac-dev-setup/vscode/templates/tasks/tilt-vscode-tasks.jsonc" "Tilt VS Code tasks template present" warn
  run_check_cmd "kubectx" "kubectx available" warn
  run_check_cmd "stern" "stern available" warn
  run_check_cmd "ctlptl" "ctlptl available" warn
  run_check_dir "/Applications/Testcontainers Desktop.app" "Testcontainers Desktop app present" warn
  run_check_file "$HOME/.config/testcontainers-desktop/bootstrap-notes.txt" "Testcontainers Desktop bootstrap notes present" fail
  run_check_colima_running "Colima running" warn
  run_check_docker_reachable "Docker daemon reachable" warn

  # Shell and file tooling
  run_check_cmd "shellcheck" "shellcheck available" warn
  run_check_cmd "shfmt" "shfmt available" warn
  run_check_cmd "markdownlint" "markdownlint available" warn
  run_check_cmd "yamllint" "yamllint available" warn
  run_check_cmd "actionlint" "actionlint available" warn

  # Language, spec, and file support
  run_check_cmd "eslint" "ESLint available" warn
  run_check_cmd "typescript-language-server" "TypeScript language server available" warn
  run_check_cmd "prettier" "Prettier available" warn
  run_check_cmd "vscode-html-language-server" "HTML language server available" warn
  run_check_cmd "stylelint" "Stylelint available" warn
  run_check_cmd "vscode-css-language-server" "CSS language server available" warn
  run_check_cmd "vscode-json-language-server" "JSON language server available" warn
  run_check_cmd "sqlfluff" "SQLFluff available" warn
  run_check_cmd "sql-language-server" "SQL language server available" warn
  run_check_cmd "protoc" "protoc available" warn
  run_check_cmd "buf" "Buf available" warn
  run_check_cmd "marksman" "Marksman available" warn
  run_check_cmd "yaml-language-server" "YAML language server available" warn
  run_check_cmd "dotenv-linter" "dotenv-linter available" warn
  run_check_cmd "editorconfig-checker" "editorconfig-checker available" warn
  run_check_cmd "bash-language-server" "Bash language server available" warn
  run_check_cmd "task" "Task available" warn
  run_check_file "$HOME/.zsh/plugins/task-completion.zsh" "Task zsh completion plugin present" fail
  run_check_login_zsh 'task --completion zsh >/dev/null 2>&1' "Task completion available" warn
  run_check_cmd "just" "just available" warn
  run_check_cmd "taplo" "taplo available" warn
  run_check_cmd "redocly" "OpenAPI CLI available" warn
  run_check_cmd "asyncapi" "AsyncAPI CLI available" warn
  run_check_cmd "ajv" "JSON Schema CLI available" warn
  run_check_cmd "terraform" "Terraform available" warn
  run_check_file "$HOME/.zsh/plugins/terraform-completion.zsh" "Terraform zsh completion plugin present" fail
  run_check_cmd "tflint" "tflint available" warn
  run_check_cmd "terraform-ls" "Terraform language server available" warn
  run_check_cmd "hadolint" "Hadolint available" warn
  run_check_cmd "docker-langserver" "Dockerfile language server available" warn
  run_check_login_zsh 'docker compose version >/dev/null 2>&1' "Docker Compose support available" warn
  run_check_cmd "docker-compose-langserver" "Docker Compose language server available" warn
  run_check_cmd "graphql-language-service-cli" "GraphQL language tooling available" warn
  run_check_cmd "groovy" "Groovy available" warn
  run_check_cmd "groovyc" "Groovy compiler available" warn
  run_check_cmd "npm-groovy-lint" "npm-groovy-lint available" warn
  run_check_login_zsh 'command -v groovy-language-server >/dev/null 2>&1' "Groovy language server available" warn
  run_check_cmd "kotlin" "Kotlin available" warn
  run_check_cmd "kotlinc" "Kotlin compiler available" warn
  run_check_cmd "kotlin-language-server" "Kotlin language server available" warn
  run_check_cmd "ktfmt" "ktfmt available" warn
  run_check_cmd "detekt" "Detekt available" warn
  run_check_cmd "spring" "Spring Boot CLI available" warn
  run_check_file "$HOME/.zsh/plugins/spring-boot-completion.zsh" "Spring Boot CLI zsh completion plugin present" fail
  run_check_login_zsh 'spring completion zsh >/dev/null 2>&1' "Spring Boot CLI completion available" warn
  run_check_cmd "ct" "chart-testing available" warn

  # Optional language support
  # run_check_cmd "pwsh" "PowerShell available" warn
  # run_check_login_zsh 'pwsh -NoLogo -NoProfile -Command '\''Get-Module -ListAvailable PSScriptAnalyzer | Select-Object -First 1 | Out-Null'\''' "PSScriptAnalyzer available" warn
  # run_check_cmd "rustc" "Rust available" warn
  # run_check_cmd "cargo" "Cargo available" warn
  # run_check_cmd "rust-analyzer" "Rust Analyzer available" warn
  # run_check_cmd "dotnet" ".NET available" warn
  # run_check_file "$HOME/.zsh/plugins/dotnet-completion.zsh" ".NET zsh completion plugin present" fail
  # run_check_login_zsh 'dotnet completions script zsh >/dev/null 2>&1' ".NET completion available" warn
  # run_check_cmd "php" "PHP available" warn
  # run_check_cmd "composer" "Composer available" warn
  # run_check_cmd "phpactor" "Phpactor available" warn
  # run_check_cmd "phpstan" "PHPStan available" warn
  # run_check_cmd "php-cs-fixer" "PHP CS Fixer available" warn
  # run_check_cmd "zig" "Zig available" warn
  # run_check_cmd "zls" "Zig language server available" warn
  # run_check_cmd "jupyter" "Jupyter available" warn
  # run_check_cmd "nbqa" "nbQA available" warn
  # run_check_cmd "jupytext" "Jupytext available" warn
  # run_check_cmd "cue" "CUE available" warn
  # run_check_login_zsh 'cue lsp serve -h >/dev/null 2>&1' "CUE language server available" warn
  # run_check_cmd "opa" "OPA available" warn
  # run_check_cmd "regal" "Regal available" warn
  # run_check_cmd "asciidoctor" "AsciiDoctor available" warn
  # run_check_cmd "vale" "Vale available" warn

  # Optional desktop apps
  # run_check_dir "/Applications/Google Chrome.app" "Google Chrome app present" warn
  # run_check_dir "/Applications/Firefox.app" "Firefox app present" warn
  # run_check_dir "/Applications/DuckDuckGo.app" "DuckDuckGo browser app present" warn
  run_check_dir "/Applications/GitHub Desktop.app" "GitHub Desktop app present" warn
  # run_check_dir "/Applications/Dropbox.app" "Dropbox app present" warn
  # run_check_dir "/Applications/Spotify.app" "Spotify app present" warn
  # run_check_dir "/Applications/TablePlus.app" "TablePlus app present" warn
  # run_check_dir "/Applications/Sequel Ace.app" "Sequel Ace app present" warn
  # run_check_dir "/Applications/DataGrip.app" "DataGrip app present" warn
  # run_check_dir "/Applications/DBeaver.app" "DBeaver app present" warn
  # run_check_dir "/Applications/Beekeeper Studio.app" "Beekeeper Studio app present" warn
  # run_check_dir "/Applications/Postico.app" "Postico app present" warn
  run_check_dir "/Applications/pgAdmin 4.app" "pgAdmin 4 app present" warn
  run_check_dir "/Applications/TablePro.app" "TablePro app present" warn
  # run_check_dir "/Applications/Bruno.app" "Bruno app present" warn
  # run_check_dir "/Applications/Hoppscotch.app" "Hoppscotch app present" warn
  # run_check_dir "/Applications/HTTPie.app" "HTTPie Desktop app present" warn
  run_check_dir "/Applications/Insomnia.app" "Insomnia app present" warn
  # run_check_dir "/Applications/Postman.app" "Postman app present" warn

  # Optional secrets and identity
  # run_check_dir "/Applications/1Password.app" "1Password app present" warn
  # run_check_cmd "op" "1Password CLI available" warn
  # run_check_file "$HOME/.zsh/plugins/op-completion.zsh" "1Password zsh completion plugin present" fail
  # run_check_login_zsh 'op completion zsh >/dev/null 2>&1' "1Password completion available" warn
  # run_check_file "$HOME/.config/1password/bootstrap-notes.txt" "1Password bootstrap notes present" warn
  # run_check_dir "/Applications/Bitwarden.app" "Bitwarden app present" warn
  # run_check_cmd "bw" "Bitwarden CLI available" warn
  # run_check_file "$HOME/.zsh/plugins/bw-completion.zsh" "Bitwarden zsh completion plugin present" fail
  # run_check_login_zsh 'bw completion --shell zsh >/dev/null 2>&1' "Bitwarden completion available" warn
  # run_check_file "$HOME/.config/bitwarden/bootstrap-notes.txt" "Bitwarden bootstrap notes present" warn

  # Optional remote access and tunnels
  # run_check_dir "/Applications/Tailscale.app" "Tailscale app present" warn
  # run_check_cmd "tailscale" "Tailscale CLI available" warn
  # run_check_file "$HOME/.zsh/plugins/tailscale-completion.zsh" "Tailscale zsh completion plugin present" fail
  # run_check_login_zsh 'tailscale completion zsh >/dev/null 2>&1' "Tailscale completion available" warn
  # run_check_file "$HOME/.config/tailscale/bootstrap-notes.txt" "Tailscale bootstrap notes present" warn
  # run_check_cmd "ngrok" "ngrok available" warn
  # run_check_file "$HOME/.zsh/plugins/ngrok-completion.zsh" "ngrok zsh completion plugin present" fail
  # run_check_login_zsh 'ngrok completion >/dev/null 2>&1' "ngrok completion available" warn
  # run_check_file "$HOME/.config/ngrok/bootstrap-notes.txt" "ngrok bootstrap notes present" warn

  # Editors
  run_check_cmd "code" "VS Code CLI available" warn
  run_check_file "$HOME/.config/mac-dev-setup/vscode/extensions/vscode-core-vscode-extensions.txt" "VS Code core extensions manifest present" fail
  run_check_file "$HOME/.config/mac-dev-setup/vscode/settings/vscode-core-vscode-settings.jsonc" "VS Code core settings fragment present" fail
  run_check_file "$HOME/Library/Application Support/Code/User/settings.json" "Managed VS Code settings present" fail
  run_check_vscode_extensions_from_manifests warn
  run_check_cmd "idea" "IntelliJ CLI helper available" warn
  run_check_file "$HOME/.config/jetbrains/intellij-ai-notes.txt" "IntelliJ AI setup notes present" warn
  run_check_cmd "hx" "Helix editor available" warn
  run_check_cmd "nvim" "Neovim available" warn
  run_check_file "$HOME/.config/nvim/init.lua" "Managed Neovim init.lua present" fail
  run_check_file "$HOME/.config/nvim/lua/mac_dev_setup/local.lua" "Neovim local override file present" fail
  run_check_dir "$HOME/.local/share/nvim/lazy/lazy.nvim" "lazy.nvim checkout present" fail
  run_check_login_zsh 'nvim --headless "+qa" >/dev/null 2>&1' "Neovim config loads headlessly" warn
  run_check_dir "/Applications/Sublime Text.app" "Sublime Text app present" warn
  run_check_file "$HOME/.zsh/plugins/sublime-text-path.zsh" "Sublime Text zsh path plugin present" fail
  run_check_login_zsh 'command -v subl >/dev/null 2>&1' "Sublime Text CLI available" warn
  run_check_dir "/Applications/Zed.app" "Zed editor present" warn
  run_check_file "$HOME/.config/zed/bootstrap-notes.txt" "Zed bootstrap notes present" warn
  run_check_cmd "zed" "Zed CLI available" warn
  # run_check_dir "/Applications/Kiro.app" "Kiro IDE app present" warn
  # run_check_cmd "kiro-cli" "Kiro CLI available" warn
  # run_check_cmd "kiro" "Kiro command router available" warn
  # run_check_dir "/Applications/Android Studio.app" "Android Studio app present" warn
  # run_check_file "$HOME/.config/android-studio/bootstrap-notes.txt" "Android Studio bootstrap notes present" warn
  # run_check_dir "/Applications/iTerm.app" "iTerm2 app present" warn
  # run_check_file "$HOME/Library/Application Support/iTerm2/DynamicProfiles/00-mac-dev-setup.json" "Managed iTerm2 dynamic profile present" fail
  run_check_dir "/Applications/Ghostty.app" "Ghostty app present" warn
  run_check_file "$HOME/.config/ghostty/config" "Managed Ghostty config present" fail
  run_check_file "$HOME/.config/ghostty/local.conf" "Ghostty local override template present" fail
  run_check_dir "$HOME/.config/ghostty/themes" "Managed Ghostty theme directory present" fail
  run_check_file "$HOME/.config/ghostty/themes/apple-graphite-expanded-light.conf" "Ghostty Apple Graphite Expanded Light theme present" fail
  run_check_file "$HOME/.config/ghostty/themes/apple-graphite-expanded-dark.conf" "Ghostty Apple Graphite Expanded Dark theme present" fail
  # run_check_dir "/Applications/WezTerm.app" "WezTerm app present" warn
  # run_check_file "$HOME/.config/wezterm/wezterm.lua" "Managed WezTerm config present" fail
  # run_check_file "$HOME/.config/wezterm/local.lua" "WezTerm local override template present" fail
  # run_check_dir "/Applications/Warp.app" "Warp app present" warn
  # run_check_file "$HOME/.warp/themes/apple-graphite-expanded-dark-mac-dev-setup.yaml" "Managed Warp dark theme present" fail
  # run_check_file "$HOME/.warp/themes/apple-graphite-expanded-light-mac-dev-setup.yaml" "Managed Warp light theme present" fail
  # run_check_file "$HOME/.warp/bootstrap-notes.txt" "Warp bootstrap notes present" fail

  # AI tooling
  run_check_cmd "codex" "Codex CLI available" warn
  run_check_file "$HOME/.zsh/plugins/codex-completion.zsh" "Codex zsh completion plugin present" fail
  run_check_login_zsh 'codex completion zsh >/dev/null 2>&1' "Codex completion available" warn
  run_check_cursor_cli "Cursor CLI available" warn
  run_check_dir "/Applications/Codex.app" "Codex app present" warn
  run_check_dir "/Applications/Cursor.app" "Cursor editor present" warn
  run_check_dir "/Applications/Windsurf.app" "Windsurf editor present" warn
  # run_check_cmd "aider" "Aider CLI available" warn
  # run_check_cmd "claude" "Claude CLI available" warn
  # run_check_file "$HOME/.config/claude/ide-notes.txt" "Claude IDE integration notes present" warn
  run_check_dir "/Applications/ChatGPT.app" "ChatGPT app present" warn
  run_check_cmd "cn" "Continue CLI available" warn
  # run_check_cmd "gemini" "Gemini CLI available" warn
  run_check_cmd "copilot" "GitHub Copilot CLI available" warn
  # run_check_cmd "ollama" "Ollama CLI available" warn
  # run_check_dir "/Applications/LM Studio.app" "LM Studio app present" warn

  printf '\n'
  printf 'Summary: %s pass, %s warn, %s fail\n' "$PASS_COUNT" "$WARN_COUNT" "$FAIL_COUNT"

  if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
