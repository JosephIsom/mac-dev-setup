# mac-dev-setup

Automation-first MacBook development environment bootstrap.

## Goals

- Repeatable setup for future Macs
- Modular installation by profile or flags
- Homebrew for host packages
- mise for runtime management
- chezmoi for dotfiles
- Colima + Docker CLI for containers
- VS Code and IntelliJ as optional modules

## Current Status

Phase 1 in progress.

Implemented:
- repo skeleton
- bootstrap entrypoint
- shared shell helpers
- first module (`core/repo-sanity`)
- profile placeholders

Not implemented yet:
- Homebrew installation
- package installation modules
- chezmoi setup
- shell config automation
- runtime installation
- editor installation
- container setup

## Run

```bash
./scripts/bootstrap.sh
```

## Next

- Add module selection logic from profiles
- Add interactive prompts
- Add Homebrew bootstrap module
