# Module Registry (Generated)

Source: `config/modules.yaml`

- Modules: 64
- Verify checks: 30

## Modules

| Order | Module ID | Selection Var | minimal | base | full | Group | Script | Depends On |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | core-repo-sanity | (always) | yes | yes | yes | core | repo-sanity | - |
| 2 | core-xcode-clt | INSTALL_CORE_XCODE_CLT | yes | yes | yes | core | xcode-clt | - |
| 3 | core-homebrew | INSTALL_CORE_HOMEBREW | yes | yes | yes | core | homebrew | - |
| 4 | core-git | INSTALL_CORE_GIT | yes | yes | yes | core | git | core-homebrew |
| 5 | core-github-cli | INSTALL_CORE_GITHUB_CLI | yes | yes | yes | core | github-cli | core-homebrew |
| 6 | core-mise | INSTALL_CORE_MISE | yes | yes | yes | core | mise | core-homebrew |
| 7 | config-git-baseline | INSTALL_CONFIG_GIT_BASELINE | yes | yes | yes | config | git-baseline | core-git |
| 8 | config-github-cli-baseline | INSTALL_CONFIG_GITHUB_CLI_BASELINE | yes | yes | yes | config | github-cli-baseline | core-github-cli |
| 9 | config-ssh-baseline | INSTALL_CONFIG_SSH_BASELINE | no | yes | yes | config | ssh-baseline | - |
| 10 | config-github-ssh-check | INSTALL_CONFIG_GITHUB_SSH_CHECK | no | no | no | config | github-ssh-check | config-ssh-baseline |
| 11 | shell-zsh-baseline | INSTALL_SHELL_ZSH_BASELINE | yes | yes | yes | shell | zsh-baseline | - |
| 12 | shell-completion-core | INSTALL_SHELL_COMPLETION_CORE | yes | yes | yes | shell | completion-core | - |
| 13 | shell-git-integration | INSTALL_SHELL_GIT_INTEGRATION | yes | yes | yes | shell | git-integration | - |
| 14 | shell-fzf | INSTALL_SHELL_FZF | yes | yes | yes | shell | fzf | - |
| 15 | shell-zoxide | INSTALL_SHELL_ZOXIDE | no | yes | yes | shell | zoxide | - |
| 16 | shell-eza | INSTALL_SHELL_EZA | no | yes | yes | shell | eza | - |
| 17 | shell-bat | INSTALL_SHELL_BAT | no | yes | yes | shell | bat | - |
| 18 | shell-ripgrep | INSTALL_SHELL_RIPGREP | yes | yes | yes | shell | ripgrep | - |
| 19 | shell-fd | INSTALL_SHELL_FD | yes | yes | yes | shell | fd | - |
| 20 | shell-jq | INSTALL_SHELL_JQ | yes | yes | yes | shell | jq | - |
| 21 | shell-yq | INSTALL_SHELL_YQ | yes | yes | yes | shell | yq | - |
| 22 | shell-direnv | INSTALL_SHELL_DIRENV | no | no | no | shell | direnv | - |
| 23 | shell-tree | INSTALL_SHELL_TREE | no | no | yes | shell | tree | - |
| 24 | shell-wget | INSTALL_SHELL_WGET | no | no | yes | shell | wget | - |
| 25 | shell-tmux | INSTALL_SHELL_TMUX | no | no | yes | shell | tmux | - |
| 26 | shell-tmux-baseline | INSTALL_SHELL_TMUX | no | no | yes | shell | tmux-baseline | shell-tmux |
| 27 | runtime-python-runtime | INSTALL_PYTHON_RUNTIME | yes | yes | yes | runtime | python-runtime | core-mise |
| 28 | runtime-python-uv | INSTALL_PYTHON_UV | yes | yes | yes | runtime | python-uv | core-homebrew |
| 29 | runtime-python-linters | INSTALL_PYTHON_LINTERS | no | yes | yes | runtime | python-linters | runtime-python-uv |
| 30 | runtime-python-pre-commit | INSTALL_PYTHON_PRE_COMMIT | no | yes | yes | runtime | python-pre-commit | runtime-python-uv |
| 31 | runtime-node-runtime | INSTALL_NODE_RUNTIME | no | yes | yes | runtime | node-runtime | core-mise |
| 32 | runtime-node-pnpm | INSTALL_NODE_PNPM | no | yes | yes | runtime | node-pnpm | runtime-node-runtime |
| 33 | runtime-node-typescript | INSTALL_NODE_TYPESCRIPT | no | yes | yes | runtime | node-typescript | runtime-node-runtime |
| 34 | runtime-go-runtime | INSTALL_GO_RUNTIME | no | yes | yes | runtime | go-runtime | core-mise |
| 35 | runtime-go-dev-tools | INSTALL_GO_DEV_TOOLS | no | yes | yes | runtime | go-dev-tools | runtime-go-runtime |
| 36 | runtime-java-runtime | INSTALL_JAVA_RUNTIME | no | yes | yes | runtime | java-runtime | core-mise |
| 37 | runtime-java-maven | INSTALL_JAVA_MAVEN | no | yes | yes | runtime | java-maven | runtime-java-runtime |
| 38 | runtime-java-gradle | INSTALL_JAVA_GRADLE | no | yes | yes | runtime | java-gradle | runtime-java-runtime |
| 39 | container-colima | INSTALL_CONTAINERS_COLIMA | no | yes | yes | container | colima | core-homebrew |
| 40 | container-docker-cli | INSTALL_CONTAINERS_DOCKER_CLI | no | yes | yes | container | docker-cli | core-homebrew |
| 41 | container-buildx | INSTALL_CONTAINERS_BUILDX | no | yes | yes | container | buildx | container-docker-cli |
| 42 | container-compose | INSTALL_CONTAINERS_COMPOSE | no | yes | yes | container | compose | container-docker-cli |
| 43 | container-colima-start | INSTALL_CONTAINERS_COLIMA | no | yes | yes | container | colima-start | container-colima |
| 44 | container-docker-verify | INSTALL_CONTAINERS_DOCKER_CLI | no | yes | yes | container | docker-verify | container-docker-cli, container-colima, container-buildx, container-compose |
| 45 | quality-shellcheck | INSTALL_QUALITY_SHELLCHECK | yes | yes | yes | quality | shellcheck | core-homebrew |
| 46 | quality-shfmt | INSTALL_QUALITY_SHFMT | yes | yes | yes | quality | shfmt | core-homebrew |
| 47 | quality-markdownlint | INSTALL_QUALITY_MARKDOWNLINT | no | no | yes | quality | markdownlint | runtime-node-runtime |
| 48 | quality-yamllint | INSTALL_QUALITY_YAMLLINT | no | no | yes | quality | yamllint | core-homebrew |
| 49 | quality-actionlint | INSTALL_QUALITY_ACTIONLINT | no | no | yes | quality | actionlint | core-homebrew |
| 50 | editor-vscode-app | INSTALL_EDITOR_VSCODE_APP | no | yes | yes | editor | vscode-app | core-homebrew |
| 51 | editor-vscode-cli | INSTALL_EDITOR_VSCODE_CLI | no | yes | yes | editor | vscode-cli | editor-vscode-app |
| 52 | editor-vscode-extensions-base | INSTALL_EDITOR_VSCODE_EXTENSIONS_BASE | no | yes | yes | editor | vscode-extensions-base | editor-vscode-cli |
| 53 | editor-vscode-settings-base | INSTALL_EDITOR_VSCODE_SETTINGS_BASE | no | yes | yes | editor | vscode-settings-base | editor-vscode-app |
| 54 | editor-intellij-toolbox | INSTALL_EDITOR_INTELLIJ_TOOLBOX | no | no | yes | editor | intellij-toolbox | core-homebrew |
| 55 | editor-intellij-idea | INSTALL_EDITOR_INTELLIJ_IDEA | no | no | yes | editor | intellij-idea | editor-intellij-toolbox |
| 56 | editor-intellij-cli | INSTALL_EDITOR_INTELLIJ_CLI | no | no | yes | editor | intellij-cli | editor-intellij-idea |
| 57 | editor-iterm2-app | INSTALL_EDITOR_ITERM2_APP | no | yes | yes | editor | iterm2-app | core-homebrew |
| 58 | editor-neovim | INSTALL_EDITOR_NEOVIM | no | no | yes | editor | neovim | core-homebrew |
| 59 | editor-neovim-toolchain | INSTALL_EDITOR_NEOVIM | no | no | yes | editor | neovim-toolchain | editor-neovim, runtime-node-runtime, runtime-python-runtime |
| 60 | ai-codex-app | INSTALL_AI_CODEX_APP | no | yes | yes | ai | codex-app | core-homebrew |
| 61 | ai-codex-cli | INSTALL_AI_CODEX_CLI | no | yes | yes | ai | codex-cli | core-homebrew |
| 62 | ai-cursor-editor | INSTALL_AI_CURSOR_EDITOR | no | yes | yes | ai | cursor-editor | core-homebrew |
| 63 | ai-cursor-cli | INSTALL_AI_CURSOR_CLI | no | yes | yes | ai | cursor-cli | core-homebrew |
| 64 | ai-windsurf-editor | INSTALL_AI_WINDSURF_EDITOR | no | yes | yes | ai | windsurf-editor | core-homebrew |

## Verify Checks

| # | Selection Var | Kind | Severity | Label | Arg |
| --- | --- | --- | --- | --- | --- |
| 1 | INSTALL_CORE_HOMEBREW | cmd | fail | Homebrew available | brew |
| 2 | INSTALL_CORE_GIT | cmd | fail | Git available | git |
| 3 | INSTALL_CORE_GITHUB_CLI | cmd | fail | GitHub CLI available | gh |
| 4 | INSTALL_CORE_MISE | cmd | fail | mise available | mise |
| 5 | INSTALL_PYTHON_RUNTIME | cmd | fail | Python available | python |
| 6 | INSTALL_PYTHON_UV | cmd | fail | uv available | uv |
| 7 | INSTALL_NODE_RUNTIME | cmd | fail | Node available | node |
| 8 | INSTALL_NODE_RUNTIME | cmd | fail | npm available | npm |
| 9 | INSTALL_NODE_PNPM | cmd | fail | pnpm available | pnpm |
| 10 | INSTALL_GO_RUNTIME | cmd | fail | Go available | go |
| 11 | INSTALL_JAVA_RUNTIME | cmd | fail | Java available | java |
| 12 | INSTALL_JAVA_MAVEN | cmd | fail | Maven available | mvn |
| 13 | INSTALL_JAVA_GRADLE | cmd | fail | Gradle available | gradle |
| 14 | INSTALL_CONTAINERS_COLIMA | cmd | fail | Colima available | colima |
| 15 | INSTALL_CONTAINERS_DOCKER_CLI | cmd | fail | Docker CLI available | docker |
| 16 | INSTALL_CONTAINERS_COLIMA | colima_running | warn | Colima running | - |
| 17 | INSTALL_CONTAINERS_DOCKER_CLI | docker_reachable | warn | Docker daemon reachable | - |
| 18 | INSTALL_SHELL_TMUX | cmd | warn | tmux available | tmux |
| 19 | INSTALL_EDITOR_NEOVIM | cmd | warn | Neovim available | nvim |
| 20 | INSTALL_EDITOR_VSCODE_CLI | cmd | warn | VS Code CLI available | code |
| 21 | INSTALL_EDITOR_INTELLIJ_CLI | cmd | warn | IntelliJ CLI helper available | idea |
| 22 | INSTALL_AI_CODEX_CLI | cmd | warn | Codex CLI available | codex |
| 23 | INSTALL_AI_CURSOR_CLI | cursor_cli | warn | Cursor CLI available | - |
| 24 | INSTALL_AI_CODEX_APP | dir | warn | Codex app present | /Applications/Codex.app |
| 25 | INSTALL_AI_CURSOR_EDITOR | dir | warn | Cursor editor present | /Applications/Cursor.app |
| 26 | INSTALL_AI_WINDSURF_EDITOR | dir | warn | Windsurf editor present | /Applications/Windsurf.app |
| 27 | INSTALL_SHELL_ZSH_BASELINE | file | fail | Managed zsh bootstrap present | $HOME/.config/dev-bootstrap/zsh/bootstrap.zsh |
| 28 | INSTALL_SHELL_TMUX | file | fail | Managed tmux config present | $HOME/.config/dev-bootstrap/tmux/tmux.conf |
| 29 | INSTALL_EDITOR_NEOVIM | file | fail | Managed Neovim bootstrap present | $HOME/.config/dev-bootstrap/nvim/plugin/bootstrap.vim |
| 30 | INSTALL_CONFIG_SSH_BASELINE | file | fail | SSH config present | $HOME/.ssh/config |
