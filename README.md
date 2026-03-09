# mac-dev-setup

Comprehensive, automation-first macOS development environment bootstrap.

## Executive Summary

This repository bootstraps a modern macOS development machine with:

- Homebrew for package installation
- mise for language/runtime and tool version management
- uv as the preferred Python dependency workflow
- pnpm as the preferred JavaScript/TypeScript dependency workflow
- Colima + Docker CLI + Buildx + Compose instead of Docker Desktop
- zsh-based terminal setup with repo-managed config
- VS Code, IntelliJ/Toolbox, tmux, and Neovim support
- repo-managed configuration with a staged path toward fuller chezmoi ownership
- verification tooling to audit machine readiness

This setup is designed to be:

- automation-first
- repeatable
- profile-driven
- safe to rerun
- practical for future machine rebuilds

---

## Scope

The repository currently covers:

- core machine bootstrap
- shell and terminal tooling
- Git and GitHub CLI baseline config
- SSH baseline scaffold
- Python, Node, Go, and Java runtimes
- language-specific dev tooling
- container tooling and runtime
- editor installation and baseline config
- repo policy files and quality tooling
- machine verification

It does **not** try to fully automate:

- every first-launch GUI workflow
- every personal preference or theme tweak
- every IDE-specific plugin or account sign-in flow
- every macOS defaults choice by default

---

## Design Principles

### 1. Automation-first

The repo prefers scripted installation and configuration over manual setup.

### 2. Small safe increments

Each phase is meant to be rerunnable and validated before moving on.

### 3. Repo-owned managed config

Managed configuration should live in the repo and be copied or applied from there.

### 4. Local override support

Personal tweaks should live in explicit local override files instead of being mixed into managed baseline files.

### 5. Baseline vs optional

The setup distinguishes between what should exist on nearly every dev Mac and what should remain opt-in.

---

## Architecture

### Bootstrap entrypoint

- `scripts/bootstrap.sh`

This orchestrates the install/config phases based on profile selections and flags.

### Module groups

- `scripts/modules/core/`
- `scripts/modules/config/`
- `scripts/modules/shell/`
- `scripts/modules/runtime/`
- `scripts/modules/container/`
- `scripts/modules/quality/`
- `scripts/modules/editor/`

### Repo-managed config source

- `home/dot_config/dev-bootstrap/...`
- `home/dot_ssh/...`

These files are the repo-owned source for managed user config.

### Profiles

- `config/profiles/minimal.env`
- `config/profiles/base.env`
- `config/profiles/full.env`

### User-local machine settings

- `config/user.env`

This is intentionally gitignored.

---

## Profiles

### minimal

Lean bootstrap for a smaller baseline.

Use when you want:

- core package manager and shell baseline
- Git/GitHub CLI
- Python baseline
- minimal quality tools

### base

Recommended default profile.

Use when you want:

- core shell/tooling baseline
- all major runtimes
- Docker/Colima stack
- VS Code baseline
- core quality and dev tooling

### full

Broader workstation profile.

Use when you want:

- all of base
- IntelliJ/Toolbox path
- Neovim path
- more quality tools
- fuller workstation experience

---

## Preferred Tooling Decisions

### Package installation

- **Primary**: Homebrew
- **Reason**: standard macOS package manager with good ecosystem coverage

### Runtime/version management

- **Primary**: mise
- **Reason**: one version manager across Python, Node, Go, Java, and more

### Python dependency management

- **Primary**: uv
- **Fallback**: pip

Policy:

- use `mise` for Python runtime versions
- use `uv` for project/package/dependency workflows
- keep `pip` available for compatibility and edge cases

### JavaScript/TypeScript dependency management

- **Primary**: pnpm
- **Fallback**: npm

Policy:

- use `mise` for Node runtime versions
- keep npm because it ships with Node
- prefer pnpm for active package management

### Go dependency management

- built-in Go modules

### Java dependency/build tooling

- Maven and Gradle are both supported
- which one to use depends on project context

### Shell

- zsh only
- bash is intentionally not a first-class target in this setup

### Docker runtime on macOS

- Colima
- Docker CLI
- Docker Buildx
- Docker Compose

Docker Desktop is intentionally not part of the baseline.

### Environment tools

- `mise` is the default environment/version tool
- `direnv` remains optional and off by default

Policy:

- do not use direnv in the default baseline
- enable it only for specific workflows that need it

---

## Brewfile Policy

This repo uses a **hybrid Brewfile model**.

### Source of truth

- checked-in `Brewfile` is the curated baseline

### Snapshot/audit

- exported Brewfile snapshot is for review and drift detection

### Promotion rule

If something appears on a machine and is not already in the checked-in Brewfile, ask:

- do I want this on nearly every future dev Mac?
- is it part of the intended baseline?
- can I support it cleanly in modules/profiles?

If yes:

- promote it into the checked-in `Brewfile`

If no:

- leave it out of the curated baseline

### Practical policy

- keep `Brewfile` intentional and readable
- do not treat machine snapshots as automatic truth
- use snapshots to inspect drift, not to blindly overwrite policy

---

## Configuration Ownership Model

The repo is moving toward fuller chezmoi ownership, but currently uses a staged approach.

### Current model

- repo-managed source files live under `home/...`
- bootstrap scripts copy them into `~/.config/dev-bootstrap/...`
- user-facing shell/editor hooks source those managed files

### Why

This keeps the setup:

- practical now
- less risky than a full immediate chezmoi migration
- easier to evolve into fuller chezmoi control later

### Local override strategy

Use these for personal changes that should not be normalized into the baseline too early:

- `~/.config/dev-bootstrap/zsh/local.zsh`
- `~/.config/dev-bootstrap/tmux/local.conf`
- `~/.config/dev-bootstrap/nvim/local.lua`

---

## Terminal / Shell Baseline

### Current baseline

- zsh
- Homebrew shellenv
- completion support
- fzf integration
- git aliases/integration
- zoxide
- local override file

### Powerlevel10k

Your current Powerlevel10k setup was intentionally preserved.

Policy:

- managed bootstrap should not overwrite personal p10k preferences
- future p10k-specific automation should remain additive, not destructive

### tmux baseline

Current tmux baseline includes:

- prefix set to `Ctrl-a`
- mouse enabled
- vi keys in copy mode/status mode
- pane splitting/navigation helpers
- reload binding
- local override support

---

## Editors

## VS Code

### Managed baseline

- app install
- `code` CLI shim under `~/.local/bin`
- baseline extensions
- baseline settings scaffold

### Notes

Extension installation is more reliable with VS Code closed.

### Baseline extension intent

The extension set focuses on:

- Python
- Go
- JS/TS formatting/linting
- Docker
- EditorConfig
- GitHub PR workflow

## IntelliJ / JetBrains Toolbox

### Policy

JetBrains Toolbox is the recommended management path.

### Practical sequence

1. install JetBrains Toolbox
2. open Toolbox
3. sign in to JetBrains account
4. install IntelliJ IDEA from Toolbox
5. enable/generate Toolbox shell scripts
6. rerun the IntelliJ CLI helper phase

### Why it is handled this way

Some parts of the IntelliJ flow are inherently GUI/account-driven and are better documented than over-automated.

## Neovim

### Baseline includes

- managed init hook
- lazy.nvim plugin manager
- colorscheme
- telescope
- treesitter
- LSP scaffold
- completion scaffold
- provider/toolchain setup
- local override support

### Notes

Neovim bootstrapping has some first-run caveats:

- plugins may need an initial sync
- Treesitter may need an initial `:TSUpdate`
- toolchain health depends on external LSP binaries/providers being installed

### Current health policy

Fix:

- startup-breaking errors
- missing core executables/providers

Ignore for now unless needed:

- optional snippet enhancement warnings
- niche filetype warnings

---

## Language Tooling

## Python

### Runtime

- managed by mise

### Primary workflow

- uv

### Tooling

- Ruff
- pre-commit
- pynvim provider

### Policy

- use uv-first workflows for new projects
- use pip only for compatibility when needed

## Node / TypeScript

### Runtime

- managed by mise

### Primary workflow

- pnpm

### Tooling

- TypeScript
- language servers for Neovim
- VS Code extension support

## Go

### Runtime

- managed by mise

### Tooling

- gopls
- golangci-lint
- dlv

## Java

### Runtime

- managed by mise

### Tooling

- Maven
- Gradle

---

## Containers

### Baseline stack

- Colima
- Docker CLI
- Docker Buildx
- Docker Compose

### Practical sequence

1. install Colima and Docker CLI stack
2. install Buildx and Compose plugins
3. create Docker CLI plugin symlinks if needed
4. start Colima with selected CPU/memory/disk values
5. verify with `docker info`
6. verify end-to-end with `docker run --rm hello-world`

### Resource configuration

Current user-configurable values:

- `COLIMA_CPU`
- `COLIMA_MEMORY`
- `COLIMA_DISK`

These are provided through `config/user.env`.

---

## Git / GitHub / SSH

## Git baseline

Managed globally:

- `init.defaultBranch = main`
- `fetch.prune = true`
- `pull.rebase = false`
- `rerere.enabled = true`
- global excludes file

Git identity is populated from `config/user.env` when available.

## GitHub CLI baseline

Managed:

- install
- protocol baseline (`https` or `ssh`)
- auth state check/warning

## SSH baseline

Managed scaffold:

- `~/.ssh/config`
- GitHub host block
- keychain/agent settings for macOS

### Practical SSH sequence

1. apply SSH baseline
2. generate key if needed:
   - `ssh-keygen -t ed25519 -C "you@example.com"`
3. add public key to GitHub
4. test with:
   - `ssh -T git@github.com`
5. optionally enable the repo’s GitHub SSH check module

---

## Quality Tooling

Installed baseline may include:

- shellcheck
- shfmt
- markdownlint
- yamllint
- actionlint

Repo policy/config files:

- `.editorconfig`
- `.gitattributes`
- `.gitignore`
- `.markdownlint.jsonc`
- `.yamllint.yml`

These files make the repo itself behave more like a real maintained project.

---

## Verification

Use:

- `./scripts/verify.sh`

This checks:

- core commands present
- runtimes present
- Docker stack reachable
- selected editor CLIs present where applicable
- key managed config files exist

### Warning policy

Warnings are acceptable for intentionally optional items.

Example:

- IntelliJ CLI helper may warn on machines where Toolbox/IDEA shell scripts have not been generated yet

That should remain a warning, not a failure.

---

## Baseline vs Optional

### Baseline machine concerns

Examples:

- Homebrew
- runtimes
- shell baseline
- Git/GitHub CLI
- Docker/Colima stack
- repo verification tooling

### Developer productivity layer

Examples:

- tmux
- Neovim
- VS Code extensions/settings
- IntelliJ CLI helper path

### Personal preference layer

Examples:

- Powerlevel10k specifics
- local zsh aliases/tweaks
- local tmux overrides
- local Neovim overrides
- personal macOS defaults choices

This separation is intentional and should remain part of the repo’s operating model.

---

## Known First-Run Caveats

### VS Code

- extension install is more reliable with the VS Code UI closed

### IntelliJ / Toolbox

- first launch, sign-in, and install are GUI-driven
- shell scripts may need to be enabled from Toolbox/IDE settings before CLI helper passes cleanly

### Neovim

- first-run plugin sync may be noisy
- Treesitter may need `:TSUpdate`
- some toolchain/provider warnings are expected until Node/Python tooling is installed

### Docker / Colima

- Docker plugin discovery may require CLI plugin symlinks
- Colima must be running before Docker verification passes

---

## Suggested Ongoing Workflow

### Typical machine bootstrap

1. clone repo
2. create `config/user.env`
3. choose profile
4. run bootstrap
5. run verify
6. handle any expected manual GUI/account steps
7. rerun targeted modules if needed

### When adding a new tool

1. decide whether it is baseline or optional
2. add module and profile flags if needed
3. add verification
4. update Brewfile policy if appropriate
5. update final docs

### When changing config

1. change repo-owned source under `home/...`
2. rerun relevant bootstrap module
3. verify resulting user config files
4. keep personal-only tweaks in local override files

---

## Recommended Future Enhancements

These are reasonable future additions, but were not required for the current baseline.

### Good future candidates

- macOS defaults automation (only if you want a more opinionated machine baseline)
- Colima lifecycle helper commands (`stop`, `reset`, etc.)
- richer VS Code extension bundles by language
- additional Neovim filetype cleanup for niche filetypes
- fuller chezmoi-native apply flow
- CI for repo linting/smoke tests

### Not recommended as default additions right now

- Docker Desktop
- Poetry / Pipenv / nvm / asdf / pyenv
- Oh My Zsh or extra shell frameworks by default
- Ruby/Perl Neovim providers
- direnv in the default baseline

---

## Version History

- v1: initial final documentation draft covering architecture, profiles, policies, tooling choices, practical sequences, ownership model, and verification workflow
