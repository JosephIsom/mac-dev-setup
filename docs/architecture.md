# Architecture

## Executive Summary

The repo is organized around a single bootstrap entrypoint, profile-driven selection, module groups, and repo-owned managed config.

## Core Layout

### Entrypoint

- `scripts/bootstrap.sh`

This orchestrates install/config phases based on profile selections and flags.

### Module groups

- `scripts/modules/core/`
- `scripts/modules/config/`
- `scripts/modules/shell/`
- `scripts/modules/runtime/`
- `scripts/modules/container/`
- `scripts/modules/quality/`
- `scripts/modules/editor/`
- `scripts/modules/ai/`

### Profiles

- `config/profiles/minimal.env`
- `config/profiles/base.env`
- `config/profiles/full.env`

Profiles now act as override files. Module defaults are defined in the registry.

### Module registry

- Source of truth: `config/modules.yaml`
- Generated shell data consumed by bootstrap/verify: `scripts/lib/module-registry-generated.sh`
- Generated docs table: `docs/generated/module-registry.md`
- Generator script: `scripts/generate-module-registry.sh`

### User-local machine settings

- `config/user.env`

This file is intentionally gitignored.

## Configuration Ownership Model

### Current model

- repo-managed source files live under `home/...`
- bootstrap scripts copy them into `~/.config/dev-bootstrap/...`
- user-facing shell/editor hooks source those managed files

### Local override strategy

Use these for personal changes that should not be normalized into the baseline too early:

- `~/.config/dev-bootstrap/zsh/local.zsh`
- `~/.config/dev-bootstrap/tmux/local.conf`
- `~/.config/dev-bootstrap/nvim/local.lua`

## Baseline vs Optional Layers

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
- AI tooling evaluation installs

### Personal preference layer

Examples:

- Powerlevel10k specifics
- local zsh aliases/tweaks
- local tmux overrides
- local Neovim overrides
- personal macOS defaults choices
- future AI tool preferences and workflow choices

## Version History

- v1: architecture doc extracted from the consolidated final documentation draft
