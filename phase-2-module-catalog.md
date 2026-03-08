# Phase 2 Module Catalog

## Purpose

This file defines the selectable modules for the Mac development environment bootstrap system.

It answers:
- what can be installed
- what each module owns
- whether it should default on or off
- what prompt text should be used
- which install path should be preferred

## Module Design Rules

- Each module must be independently selectable.
- Each module must have a clear owner and bounded scope.
- Each module must have a verification step.
- Modules may depend on other modules, but dependencies must be explicit.
- App install and app configuration should usually be separate modules.

## Selection States

- Default On: installed in the `base` profile unless explicitly disabled
- Recommended Optional: not installed by default, but commonly useful
- Niche Optional: only install for specific workflows

---

## 1. Core Platform

### core.homebrew
- Default: On
- Prompt: Install Homebrew?
- Purpose: Primary host package manager for CLI tools, casks, and Brewfile-driven package state
- Install path: official Homebrew install script
- Verify:
  - `brew --version`
  - `brew doctor`
- Notes:
  - Homebrew remains the baseline package layer for this setup.

### core.xcode-clt
- Default: On
- Prompt: Install Xcode Command Line Tools?
- Purpose: Provides foundational macOS developer tooling used by Homebrew and many build/install flows
- Install path: `xcode-select --install`
- Verify:
  - `xcode-select -p`
  - `git --version`

### core.git
- Default: On
- Prompt: Install Git?
- Purpose: Source control CLI
- Install path: Homebrew
- Verify:
  - `git --version`

### core.github-cli
- Default: On
- Prompt: Install GitHub CLI?
- Purpose: GitHub auth, repo creation, PR workflow
- Install path: Homebrew
- Verify:
  - `gh --version`

### core.chezmoi
- Default: On
- Prompt: Install Chezmoi?
- Purpose: Dotfiles, templates, machine bootstrap orchestration
- Install path: Homebrew
- Verify:
  - `chezmoi --version`

---

## 2. Shell UX

### shell.zsh-baseline
- Default: On
- Prompt: Configure zsh baseline?
- Purpose: History, completion, aliases, shell behavior, PATH wiring
- Install path: chezmoi-managed dotfiles
- Verify:
  - `zsh -i -c exit`

### shell.starship
- Default: On
- Prompt: Install Starship prompt?
- Purpose: Modern cross-shell prompt
- Install path: Homebrew
- Verify:
  - `starship --version`

### shell.fzf
- Default: On
- Prompt: Install fzf?
- Purpose: Fuzzy selection in shell workflows
- Install path: Homebrew
- Verify:
  - `fzf --version`

### shell.zoxide
- Default: On
- Prompt: Install zoxide?
- Purpose: Smarter directory jumping
- Install path: Homebrew
- Verify:
  - `zoxide --version`

### shell.eza
- Default: On
- Prompt: Install eza?
- Purpose: Modern replacement for `ls`
- Install path: Homebrew
- Verify:
  - `eza --version`

### shell.bat
- Default: On
- Prompt: Install bat?
- Purpose: Better `cat` with syntax highlighting and paging
- Install path: Homebrew
- Verify:
  - `bat --version`

### shell.ripgrep
- Default: On
- Prompt: Install ripgrep?
- Purpose: Fast recursive search
- Install path: Homebrew
- Verify:
  - `rg --version`

### shell.fd
- Default: On
- Prompt: Install fd?
- Purpose: Better file finding
- Install path: Homebrew
- Verify:
  - `fd --version`

### shell.jq
- Default: On
- Prompt: Install jq?
- Purpose: JSON processing
- Install path: Homebrew
- Verify:
  - `jq --version`

### shell.yq
- Default: On
- Prompt: Install yq?
- Purpose: YAML processing
- Install path: Homebrew
- Verify:
  - `yq --version`

### shell.direnv
- Default: On
- Prompt: Install direnv?
- Purpose: Per-project environment activation
- Install path: Homebrew
- Verify:
  - `direnv version`

### shell.tree
- Default: Recommended Optional
- Prompt: Install tree?
- Purpose: Directory tree visualization
- Install path: Homebrew
- Verify:
  - `tree --version`

### shell.wget
- Default: Recommended Optional
- Prompt: Install wget?
- Purpose: Alternative download utility
- Install path: Homebrew
- Verify:
  - `wget --version`

---

## 3. Python

### python.runtime
- Default: On
- Prompt: Install Python runtime via mise?
- Purpose: Global Python runtime management
- Install path: mise
- Verify:
  - `python --version`

### python.uv
- Default: On
- Prompt: Install uv?
- Purpose: Modern Python package/project workflow tool
- Install path: official installer or Homebrew; prefer official installer if we want latest upstream behavior
- Verify:
  - `uv --version`

### python.linters
- Default: Recommended Optional
- Prompt: Install Python lint/format tooling?
- Purpose: Bootstrap common Python tooling bundle
- Proposed contents:
  - `ruff`
  - optional `ty` later
- Install path: uv tool install or Homebrew depending on tool
- Verify:
  - `ruff --version`

### python.pre-commit
- Default: Recommended Optional
- Prompt: Install pre-commit?
- Purpose: Standardized Git hook automation
- Install path: uv tool install
- Verify:
  - `pre-commit --version`

---

## 4. JavaScript / TypeScript

### node.runtime
- Default: On
- Prompt: Install Node.js via mise?
- Purpose: Core JS/TS runtime
- Install path: mise
- Verify:
  - `node --version`
  - `npm --version`

### node.pnpm
- Default: On
- Prompt: Install pnpm?
- Purpose: Preferred package manager for JS/TS workflows
- Install path: official installer or Corepack-based activation, to be decided in implementation
- Verify:
  - `pnpm --version`

### node.typescript
- Default: On
- Prompt: Install TypeScript tooling?
- Purpose: Global TS compiler availability for quick-start workflows
- Proposed contents:
  - `typescript`
- Verify:
  - `tsc --version`

### node.bun
- Default: Recommended Optional
- Prompt: Install Bun?
- Purpose: Optional all-in-one JS runtime/toolkit
- Install path: official installer
- Verify:
  - `bun --version`

### node.frontend-tools
- Default: Recommended Optional
- Prompt: Install common frontend tooling?
- Purpose: Convenience bundle for modern web projects
- Proposed contents:
  - ESLint support
  - Prettier support
  - optional framework CLIs later
- Note:
  - Favor project-local installs where possible; keep global installs minimal.

---

## 5. Go

### go.runtime
- Default: On
- Prompt: Install Go via mise?
- Purpose: Go toolchain
- Install path: mise
- Verify:
  - `go version`

### go.dev-tools
- Default: Recommended Optional
- Prompt: Install common Go developer tools?
- Proposed contents:
  - `gopls`
  - `golangci-lint`
  - `delve`
- Verify:
  - `gopls version`
  - `golangci-lint version`

---

## 6. Java

### java.runtime
- Default: On
- Prompt: Install Java via mise?
- Purpose: JDK runtime management
- Install path: mise
- Verify:
  - `java --version`
  - `javac --version`

### java.maven
- Default: Recommended Optional
- Prompt: Install Maven?
- Purpose: Java build tool
- Install path: Homebrew
- Verify:
  - `mvn -version`

### java.gradle
- Default: Recommended Optional
- Prompt: Install Gradle?
- Purpose: Java/Kotlin build tool
- Install path: Homebrew
- Verify:
  - `gradle -version`

---

## 7. Editors and IDEs

### editor.vscode.app
- Default: On
- Prompt: Install VS Code?
- Purpose: Editor application
- Install path: Homebrew cask
- Verify:
  - application exists

### editor.vscode.cli
- Default: On when VS Code is on
- Prompt: Enable VS Code shell command?
- Purpose: `code` command in terminal
- Install path: automation to expose `code` CLI
- Verify:
  - `code --version`

### editor.vscode.extensions.base
- Default: On when VS Code is on
- Prompt: Install baseline VS Code extensions?
- Proposed contents:
  - Python
  - Pylance
  - Go
  - ESLint
  - Prettier
  - Docker
  - EditorConfig
  - GitHub Pull Requests and Issues
- Verify:
  - `code --list-extensions`

### editor.intellij.toolbox
- Default: Recommended Optional
- Prompt: Install JetBrains Toolbox?
- Purpose: Manage IntelliJ installs and updates
- Install path: Homebrew cask or official app install path, to be finalized
- Verify:
  - application exists

### editor.intellij.idea
- Default: Recommended Optional
- Prompt: Install IntelliJ IDEA?
- Purpose: Java/general IDE
- Install path: JetBrains Toolbox-managed
- Verify:
  - IDEA app exists

---

## 8. Containers

### containers.colima
- Default: On
- Prompt: Install Colima?
- Purpose: Local container runtime on macOS
- Install path: Homebrew
- Verify:
  - `colima version`

### containers.docker-cli
- Default: On
- Prompt: Install Docker CLI?
- Purpose: Docker client commands
- Install path: Homebrew
- Verify:
  - `docker version`

### containers.buildx
- Default: On
- Prompt: Install Docker Buildx?
- Purpose: Modern Docker build workflow support
- Install path: Homebrew
- Verify:
  - `docker buildx version`

### containers.compose
- Default: On
- Prompt: Install Docker Compose plugin?
- Purpose: Compose-based local development
- Install path: Homebrew
- Verify:
  - `docker compose version`

### containers.lazydocker
- Default: Recommended Optional
- Prompt: Install lazydocker?
- Purpose: Terminal UI for Docker workflows
- Install path: Homebrew
- Verify:
  - `lazydocker --version`

---

## 9. Cloud and Platform CLIs

### cloud.aws
- Default: Niche Optional
- Prompt: Install AWS CLI?
- Install path: Homebrew
- Verify:
  - `aws --version`

### cloud.gcloud
- Default: Niche Optional
- Prompt: Install Google Cloud CLI?
- Install path: Homebrew cask or official installer, to be finalized
- Verify:
  - `gcloud --version`

### cloud.azure
- Default: Niche Optional
- Prompt: Install Azure CLI?
- Install path: Homebrew
- Verify:
  - `az version`

### cloud.kubectl
- Default: Recommended Optional
- Prompt: Install kubectl?
- Install path: Homebrew
- Verify:
  - `kubectl version --client`

### cloud.helm
- Default: Recommended Optional
- Prompt: Install Helm?
- Install path: Homebrew
- Verify:
  - `helm version`

---

## 10. Repo Hygiene / Automation

### quality.shellcheck
- Default: On
- Prompt: Install ShellCheck?
- Purpose: Lint bootstrap shell scripts
- Install path: Homebrew
- Verify:
  - `shellcheck --version`

### quality.shfmt
- Default: On
- Prompt: Install shfmt?
- Purpose: Format shell scripts
- Install path: Homebrew
- Verify:
  - `shfmt --version`

### quality.markdownlint
- Default: Recommended Optional
- Prompt: Install markdownlint?
- Purpose: Lint Markdown docs
- Install path: npm global or Homebrew if appropriate
- Verify:
  - `markdownlint --version`

### quality.yamllint
- Default: Recommended Optional
- Prompt: Install yamllint?
- Purpose: Lint YAML config
- Install path: Homebrew or uv tool depending on final approach
- Verify:
  - `yamllint --version`

### quality.actionlint
- Default: Recommended Optional
- Prompt: Install actionlint?
- Purpose: Lint GitHub Actions workflows
- Install path: Homebrew
- Verify:
  - `actionlint -version`

---

## 11. macOS Convenience

### macos.fonts.dev
- Default: Recommended Optional
- Prompt: Install developer fonts?
- Proposed contents:
  - JetBrains Mono Nerd Font
- Install path: Homebrew cask
- Verify:
  - font exists

### macos.window-management
- Default: Recommended Optional
- Prompt: Install window management utility?
- Proposed contents:
  - Rectangle
- Install path: Homebrew cask
- Verify:
  - application exists

### macos.app-store-cli
- Default: Niche Optional
- Prompt: Install `mas`?
- Purpose: Mac App Store CLI automation
- Install path: Homebrew
- Verify:
  - `mas version`

### macos.defaults
- Default: Recommended Optional
- Prompt: Apply macOS defaults/customizations?
- Purpose: Finder, Dock, keyboard, Terminal, screenshot, and related preference automation
- Install path: shell scripts
- Verify:
  - targeted preference checks where practical

---

## 12. Optional Reproducibility

### optional.nix
- Default: Off
- Prompt: Install Nix?
- Purpose: Optional reproducible environments and dev shells
- Install path: official installer path, to be finalized
- Verify:
  - `nix --version`

### optional.direnv-nix
- Default: Off unless Nix is on
- Prompt: Configure direnv + Nix integration?
- Purpose: smoother project-shell activation for Nix-based repos
- Verify:
  - shell hook behavior in test repo

---

## 13. Proposed Default Profiles

### profile.minimal
Enable:
- core.*
- shell.zsh-baseline
- shell.ripgrep
- shell.fd
- shell.fzf
- shell.jq
- shell.yq
- python.runtime
- python.uv
- quality.shellcheck
- quality.shfmt

### profile.base
Enable:
- all minimal items
- shell.starship
- shell.zoxide
- shell.eza
- shell.bat
- shell.direnv
- node.runtime
- node.pnpm
- node.typescript
- go.runtime
- java.runtime
- editor.vscode.app
- editor.vscode.cli
- editor.vscode.extensions.base
- containers.colima
- containers.docker-cli
- containers.buildx
- containers.compose

### profile.full
Enable:
- all base items
- python.pre-commit
- go.dev-tools
- java.maven
- java.gradle
- editor.intellij.toolbox
- editor.intellij.idea
- containers.lazydocker
- quality.markdownlint
- quality.yamllint
- quality.actionlint
- macos.fonts.dev
- macos.defaults

---

## 14. Initial Implementation Priorities

Implement next, in this order:
1. core.homebrew
2. core.git
3. core.github-cli
4. core.chezmoi
5. shell.zsh-baseline
6. shell baseline tools
7. python.runtime
8. node.runtime
9. go.runtime
10. java.runtime
11. editor.vscode.app
12. containers.colima
13. containers.docker-cli
14. quality.shellcheck
15. quality.shfmt

Reason:
- these produce the most usable machine baseline first.

---

## 15. Current Recommendations Snapshot

Most important additions beyond the original request:
- `uv` for Python workflows
- `pnpm` for JS/TS package management
- `direnv` for per-project environment handling
- repo-quality tools like `shellcheck` and `shfmt`
- optional cloud/Kubernetes modules instead of hard-coding them into the base setup

Notes:
- `uv` supports macOS installation via its standalone installer and also supports package-manager installation methods.
- `pnpm` provides an official installation path and continues to emphasize workspace and disk-efficiency workflows.
- `direnv` remains a straightforward shell-hook based tool for per-directory environment loading.
- Colima is available via Homebrew and remains suitable for Docker-Desktop-free local container workflows on macOS.

---

## 16. Open Decisions for Implementation

Still to finalize during implementation:
1. whether `uv` should be installed via Homebrew or its official installer
2. whether `pnpm` should be installed via Corepack or direct installer
3. whether JetBrains Toolbox should be installed via cask or direct vendor path
4. whether some quality tools should be installed through Homebrew vs language-native managers
5. exact defaults for `minimal`, `base`, and `full` profiles
