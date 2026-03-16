#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$REPO_ROOT/scripts/lib"
CONFIG_DIR="$REPO_ROOT/config"
MODULES_DIR="$REPO_ROOT/scripts/modules"
PREREQUISITES_DIR="$REPO_ROOT/scripts/prerequisites"

# shellcheck disable=SC1091
source "$LIB_DIR/common.sh"

export REPO_ROOT LIB_DIR CONFIG_DIR MODULES_DIR PREREQUISITES_DIR

main() {
  ensure_macos
  prepare_environment
  print_banner
  print_config_summary
  reset_managed_vscode_state

  run_script_path "$REPO_ROOT/scripts/repo-sanity.sh"
  run_script_path "$PREREQUISITES_DIR/prerequisites.sh"

  log_info "Running optional modules. Comment out any line in scripts/bootstrap.sh that you do not want."

  # macOS defaults
  run_script_path "$MODULES_DIR/macos/finder/finder.sh"
  run_script_path "$MODULES_DIR/macos/dock/dock.sh"
  run_script_path "$MODULES_DIR/macos/input/input.sh"
  run_script_path "$MODULES_DIR/macos/screenshots/screenshots.sh"

  # Accounts and identity
  run_script_path "$MODULES_DIR/accounts/github/github-ssh.sh"

  # Core / shell tooling
  run_script_path "$MODULES_DIR/shell/cli/github/github-cli.sh"

  # Shell / terminal
  run_script_path "$MODULES_DIR/shell/cli/fzf/fzf.sh"
  run_script_path "$MODULES_DIR/shell/cli/git-fzf/git-fzf.sh"
  run_script_path "$MODULES_DIR/shell/cli/zoxide/zoxide.sh"
  run_script_path "$MODULES_DIR/shell/cli/eza/eza.sh"
  run_script_path "$MODULES_DIR/shell/cli/bat/bat.sh"
  run_script_path "$MODULES_DIR/shell/cli/ripgrep/ripgrep.sh"
  run_script_path "$MODULES_DIR/shell/cli/fd/fd.sh"
  run_script_path "$MODULES_DIR/shell/cli/jq/jq.sh"
  run_script_path "$MODULES_DIR/shell/cli/yq/yq.sh"
  run_script_path "$MODULES_DIR/shell/cli/direnv/direnv.sh"
  run_script_path "$MODULES_DIR/shell/cli/tree/tree.sh"
  run_script_path "$MODULES_DIR/shell/cli/wget/wget.sh"
  run_script_path "$MODULES_DIR/shell/cli/tldr/tldr.sh"
  run_script_path "$MODULES_DIR/shell/cli/bottom/bottom.sh"
  run_script_path "$MODULES_DIR/shell/cli/lazygit/lazygit.sh"
  run_script_path "$MODULES_DIR/shell/cli/lazydocker/lazydocker.sh"
  run_script_path "$MODULES_DIR/shell/cli/jwt-cli/jwt-cli.sh"
  run_script_path "$MODULES_DIR/shell/cli/delta/delta.sh"
  run_script_path "$MODULES_DIR/shell/cli/watch/watch.sh"
  run_script_path "$MODULES_DIR/shell/cli/curl/curl.sh"
  run_script_path "$MODULES_DIR/shell/cli/httpie/httpie.sh"
  run_script_path "$MODULES_DIR/shell/cli/make/make.sh"
  run_script_path "$MODULES_DIR/shell/cli/cmake/cmake.sh"
  run_script_path "$MODULES_DIR/shell/cli/premake/premake.sh"
  run_script_path "$MODULES_DIR/shell/tmux/tmux.sh"
  # Prompt: enable one if desired
  # run_script_path "$MODULES_DIR/shell/prompt/p10k/p10k.sh"
  # run_script_path "$MODULES_DIR/shell/prompt/pure/pure.sh"
  # run_script_path "$MODULES_DIR/shell/prompt/starship/starship.sh"
  # run_script_path "$MODULES_DIR/shell/prompt/oh-my-posh/oh-my-posh.sh"

  # Language runtimes and tooling
  run_script_path "$MODULES_DIR/runtimes/python/python-runtime.sh"
  run_script_path "$MODULES_DIR/runtimes/python/uv.sh"
  run_script_path "$MODULES_DIR/runtimes/python/linters.sh"
  run_script_path "$MODULES_DIR/runtimes/node/node-runtime.sh"
  run_script_path "$MODULES_DIR/runtimes/node/npm-completion.sh"
  run_script_path "$MODULES_DIR/runtimes/node/pnpm.sh"
  run_script_path "$MODULES_DIR/runtimes/node/yarn.sh"
  run_script_path "$MODULES_DIR/runtimes/node/typescript.sh"
  run_script_path "$MODULES_DIR/runtimes/go/go-runtime.sh"
  run_script_path "$MODULES_DIR/runtimes/go/dev-tools.sh"
  run_script_path "$MODULES_DIR/runtimes/java/java-runtime.sh"
  run_script_path "$MODULES_DIR/runtimes/java/java-tooling.sh"
  run_script_path "$MODULES_DIR/runtimes/lua/lua-runtime.sh"
  run_script_path "$MODULES_DIR/runtimes/lua/lua-tooling.sh"
  run_script_path "$MODULES_DIR/runtimes/swift/swift-tooling.sh"

  # Build tooling
  run_script_path "$MODULES_DIR/build/jvm/maven.sh"
  run_script_path "$MODULES_DIR/build/jvm/gradle.sh"

  # Optional runtimes and language ecosystems
  # run_script_path "$MODULES_DIR/runtimes/powershell/powershell-runtime.sh"
  # run_script_path "$MODULES_DIR/runtimes/powershell/powershell-tooling.sh"
  # run_script_path "$MODULES_DIR/runtimes/rust/rust-runtime.sh"
  # run_script_path "$MODULES_DIR/runtimes/rust/rust-tooling.sh"
  # run_script_path "$MODULES_DIR/runtimes/bun/bun-runtime.sh"
  # run_script_path "$MODULES_DIR/runtimes/dotnet/dotnet-runtime.sh"
  run_script_path "$MODULES_DIR/runtimes/groovy/groovy-runtime.sh"
  run_script_path "$MODULES_DIR/runtimes/groovy/groovy-tooling.sh"
  run_script_path "$MODULES_DIR/runtimes/kotlin/kotlin-runtime.sh"
  run_script_path "$MODULES_DIR/runtimes/kotlin/kotlin-tooling.sh"
  run_script_path "$MODULES_DIR/runtimes/java/spring-boot.sh"
  # run_script_path "$MODULES_DIR/runtimes/php/php-runtime.sh"
  # run_script_path "$MODULES_DIR/runtimes/php/php-tooling.sh"
  # run_script_path "$MODULES_DIR/runtimes/ruby/ruby-runtime.sh"
  # run_script_path "$MODULES_DIR/runtimes/ruby/ruby-tooling.sh"
  # run_script_path "$MODULES_DIR/runtimes/zig/zig-runtime.sh"
  # run_script_path "$MODULES_DIR/runtimes/zig/zig-tooling.sh"

  # Cloud
  run_script_path "$MODULES_DIR/cloud/aws/aws.sh"
  # run_script_path "$MODULES_DIR/cloud/gcp/gcp.sh"
  # run_script_path "$MODULES_DIR/cloud/azure/azure.sh"
  # run_script_path "$MODULES_DIR/cloud/digitalocean/digitalocean.sh"
  # run_script_path "$MODULES_DIR/cloud/cloudflare/cloudflare.sh"
  # run_script_path "$MODULES_DIR/cloud/flyio/flyio.sh"

  # Containers
  run_script_path "$MODULES_DIR/containers/colima/colima.sh"
  run_script_path "$MODULES_DIR/containers/docker/docker-cli.sh"
  run_script_path "$MODULES_DIR/containers/buildx/buildx.sh"
  run_script_path "$MODULES_DIR/containers/compose/compose.sh"
  run_script_path "$MODULES_DIR/containers/kind/kind.sh"
  run_script_path "$MODULES_DIR/containers/kubectl/kubectl.sh"
  run_script_path "$MODULES_DIR/containers/helm/helm.sh"
  run_script_path "$MODULES_DIR/containers/k9s/k9s.sh"
  run_script_path "$MODULES_DIR/containers/tilt/tilt.sh"
  run_script_path "$MODULES_DIR/containers/kubectx/kubectx.sh"
  run_script_path "$MODULES_DIR/containers/stern/stern.sh"
  run_script_path "$MODULES_DIR/containers/ctlptl/ctlptl.sh"
  run_script_path "$MODULES_DIR/containers/testcontainers-desktop/testcontainers-desktop.sh"
  run_script_path "$MODULES_DIR/containers/colima/colima-start.sh"
  run_script_path "$MODULES_DIR/containers/docker/docker-verify.sh"

  # Language, spec, and file support
  run_script_path "$MODULES_DIR/languages/javascript/javascript-tooling.sh"
  run_script_path "$MODULES_DIR/languages/typescript/typescript-tooling.sh"
  run_script_path "$MODULES_DIR/languages/sql/sql-tooling.sh"
  run_script_path "$MODULES_DIR/languages/protobuf/protobuf-tooling.sh"
  run_script_path "$MODULES_DIR/specs/openapi/openapi-tooling.sh"
  run_script_path "$MODULES_DIR/specs/asyncapi/asyncapi-tooling.sh"
  run_script_path "$MODULES_DIR/specs/json-schema/json-schema-tooling.sh"
  run_script_path "$MODULES_DIR/specs/terraform-hcl/terraform-hcl-tooling.sh"
  run_script_path "$MODULES_DIR/specs/dockerfile/dockerfile-tooling.sh"
  run_script_path "$MODULES_DIR/specs/compose/compose-tooling.sh"
  run_script_path "$MODULES_DIR/specs/github-actions/github-actions-tooling.sh"
  run_script_path "$MODULES_DIR/files/formatting/formatting-tooling.sh"
  run_script_path "$MODULES_DIR/files/html/html-tooling.sh"
  run_script_path "$MODULES_DIR/files/css/css-tooling.sh"
  run_script_path "$MODULES_DIR/files/json/json-tooling.sh"
  run_script_path "$MODULES_DIR/files/markdown/markdown-tooling.sh"
  run_script_path "$MODULES_DIR/files/yaml/yaml-tooling.sh"
  run_script_path "$MODULES_DIR/files/dotenv/dotenv-tooling.sh"
  run_script_path "$MODULES_DIR/files/ini-editorconfig/ini-editorconfig-tooling.sh"
  run_script_path "$MODULES_DIR/files/shell-scripts/shell-scripts-tooling.sh"
  run_script_path "$MODULES_DIR/files/taskfile/taskfile-tooling.sh"
  run_script_path "$MODULES_DIR/files/justfile/justfile-tooling.sh"
  run_script_path "$MODULES_DIR/files/toml/toml-tooling.sh"

  # Optional spec and format support
  # run_script_path "$MODULES_DIR/languages/vue/vue-tooling.sh"
  # run_script_path "$MODULES_DIR/languages/svelte/svelte-tooling.sh"
  run_script_path "$MODULES_DIR/languages/graphql/graphql-tooling.sh"
  run_script_path "$MODULES_DIR/languages/gradle-groovy/gradle-groovy-tooling.sh"
  # run_script_path "$MODULES_DIR/runtimes/python/python-notebook-tooling.sh"
  # run_script_path "$MODULES_DIR/specs/cue/cue-tooling.sh"
  # run_script_path "$MODULES_DIR/specs/rego-opa/rego-opa-tooling.sh"
  run_script_path "$MODULES_DIR/specs/helm/helm-tooling.sh"
  # run_script_path "$MODULES_DIR/specs/ansible/ansible-tooling.sh"
  # run_script_path "$MODULES_DIR/specs/jsonnet/jsonnet-tooling.sh"
  # run_script_path "$MODULES_DIR/specs/bicep/bicep-tooling.sh"
  # run_script_path "$MODULES_DIR/files/mermaid/mermaid-tooling.sh"
  # run_script_path "$MODULES_DIR/files/asciidoc/asciidoc-tooling.sh"
  # run_script_path "$MODULES_DIR/files/plantuml/plantuml-tooling.sh"

  # Desktop apps
  run_script_path "$MODULES_DIR/desktop/browsers/google-chrome/google-chrome.sh"
  # run_script_path "$MODULES_DIR/desktop/browsers/firefox/firefox.sh"
  run_script_path "$MODULES_DIR/desktop/browsers/duckduckgo/duckduckgo.sh"
  run_script_path "$MODULES_DIR/desktop/git-gui/github-desktop/github-desktop.sh"
  # run_script_path "$MODULES_DIR/desktop/cloud-storage/dropbox/dropbox.sh"
  # run_script_path "$MODULES_DIR/desktop/media/spotify/spotify.sh"
  # run_script_path "$MODULES_DIR/desktop/sql-clients/tableplus/tableplus.sh"
  # run_script_path "$MODULES_DIR/desktop/sql-clients/sequel-ace/sequel-ace.sh"
  # run_script_path "$MODULES_DIR/desktop/sql-clients/datagrip/datagrip.sh"
  # run_script_path "$MODULES_DIR/desktop/sql-clients/dbeaver/dbeaver.sh"
  # run_script_path "$MODULES_DIR/desktop/sql-clients/beekeeper-studio/beekeeper-studio.sh"
  # run_script_path "$MODULES_DIR/desktop/sql-clients/postico/postico.sh"
  run_script_path "$MODULES_DIR/desktop/sql-clients/pgadmin4/pgadmin4.sh"
  run_script_path "$MODULES_DIR/desktop/sql-clients/tablepro/tablepro.sh"
  # run_script_path "$MODULES_DIR/desktop/rest-clients/bruno/bruno.sh"
  # run_script_path "$MODULES_DIR/desktop/rest-clients/hoppscotch/hoppscotch.sh"
  run_script_path "$MODULES_DIR/desktop/rest-clients/httpie-desktop/httpie-desktop.sh"
  run_script_path "$MODULES_DIR/desktop/rest-clients/insomnia/insomnia.sh"
  # run_script_path "$MODULES_DIR/desktop/rest-clients/postman/postman.sh"

  # Secrets and identity
  # run_script_path "$MODULES_DIR/secrets/1password/1password-app.sh"
  # run_script_path "$MODULES_DIR/secrets/1password/1password-cli.sh"
  # run_script_path "$MODULES_DIR/secrets/bitwarden/bitwarden-app.sh"
  # run_script_path "$MODULES_DIR/secrets/bitwarden/bitwarden-cli.sh"

  # Remote access and tunnels
  # run_script_path "$MODULES_DIR/remote-access/tailscale/tailscale.sh"
  # run_script_path "$MODULES_DIR/remote-access/ngrok/ngrok.sh"

  # Editors
  run_script_path "$MODULES_DIR/editors/vscode/vscode-app.sh"
  run_script_path "$MODULES_DIR/editors/vscode/vscode-cli.sh"
  run_script_path "$MODULES_DIR/editors/cursor/cursor-app.sh"
  run_script_path "$MODULES_DIR/editors/cursor/cursor-cli.sh"
  run_script_path "$MODULES_DIR/editors/intellij/toolbox.sh"
  run_script_path "$MODULES_DIR/editors/intellij/idea.sh"
  run_script_path "$MODULES_DIR/editors/intellij/ai.sh"
  run_script_path "$MODULES_DIR/editors/intellij/intellij-cli.sh"
  run_script_path "$MODULES_DIR/editors/windsurf/windsurf-app.sh"
  # run_script_path "$MODULES_DIR/editors/android-studio/android-studio-app.sh"
  run_script_path "$MODULES_DIR/editors/helix/helix-cli.sh"
  run_script_path "$MODULES_DIR/editors/neovim/neovim-cli.sh"
  run_script_path "$MODULES_DIR/editors/sublime-text/sublime-text-app.sh"
  run_script_path "$MODULES_DIR/editors/zed/zed-app.sh"
  # run_script_path "$MODULES_DIR/editors/kiro/kiro-app.sh"
  # run_script_path "$MODULES_DIR/editors/kiro/kiro-cli.sh"

  # Terminals
  # run_script_path "$MODULES_DIR/terminals/iterm2/iterm2-app.sh"
  run_script_path "$MODULES_DIR/terminals/ghostty/ghostty-app.sh"
  # run_script_path "$MODULES_DIR/terminals/wezterm/wezterm-app.sh"
  # run_script_path "$MODULES_DIR/terminals/warp/warp-app.sh"

  # AI tooling
  run_script_path "$MODULES_DIR/ai/codex/codex-app.sh"
  run_script_path "$MODULES_DIR/ai/codex/codex-cli.sh"
  run_script_path "$MODULES_DIR/ai/aider/aider-cli.sh"
  run_script_path "$MODULES_DIR/ai/claude/claude-cli.sh"
  run_script_path "$MODULES_DIR/ai/chatgpt/chatgpt-app.sh"
  run_script_path "$MODULES_DIR/ai/continue/continue-cli.sh"
  # run_script_path "$MODULES_DIR/ai/gemini/gemini-cli.sh"
  run_script_path "$MODULES_DIR/ai/github-copilot/github-copilot-cli.sh"
  # run_script_path "$MODULES_DIR/ai/ollama/ollama-cli.sh"
  # run_script_path "$MODULES_DIR/ai/lm-studio/lm-studio-app.sh"

  # Finalize VS Code after all enabled modules have staged their assets.
  run_script_path "$MODULES_DIR/editors/vscode/extensions.sh"
  run_script_path "$MODULES_DIR/editors/vscode/settings.sh"

  log_success "Bootstrap phase completed."
}

main "$@"
