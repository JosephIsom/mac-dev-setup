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

### User-local machine settings

- `config/user.env`

This file is intentionally gitignored.

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

## Brewfile Policy

This repo uses a hybrid Brewfile model.

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

## Version History

- v1: architecture doc extracted from the consolidated final documentation draft
