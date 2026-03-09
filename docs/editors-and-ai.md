# Editors and AI

## Executive Summary

VS Code and IntelliJ are treated as anchor editors. Additional editors and AI tools are installed as separate evaluation lanes, not as locked-in defaults.

## Anchor Editors

### VS Code

Managed baseline includes:

- app install
- `code` CLI shim under `~/.local/bin`
- baseline extensions
- baseline settings scaffold

Policy:

- keep VS Code as a stable default editor
- use only the native/built-in AI capabilities that come with the product and your chosen sign-in/license path
- do not aggressively layer extra AI extensions into VS Code by default

### IntelliJ / JetBrains Toolbox

Policy:

- JetBrains Toolbox is the recommended management path
- keep IntelliJ as a stable default IDE
- use the native JetBrains AI capabilities that come with IntelliJ/JetBrains tooling
- do not force additional third-party AI plugins into IntelliJ by default

IntelliJ CLI helper may remain a warning until:

- Toolbox is installed
- IntelliJ IDEA is installed from Toolbox
- Toolbox shell scripts are enabled/generated
- the CLI helper module is rerun

## tmux

Current baseline includes:

- prefix set to `Ctrl-a`
- mouse enabled
- vi keys in copy mode/status mode
- pane splitting/navigation helpers
- reload binding
- local override support

## Neovim

Baseline includes:

- managed init hook
- lazy.nvim plugin manager
- colorscheme
- telescope
- treesitter
- LSP scaffold
- completion scaffold
- provider/toolchain setup
- local override support

Current health policy:

Fix:

- startup-breaking errors
- missing core executables/providers

Ignore for now unless needed:

- optional snippet enhancement warnings
- niche filetype warnings

## AI Tooling Philosophy

This repo treats AI tooling as an evaluation layer, not a locked-in standard workflow.

Current intended operating model:

1. Anchor editors remain stable:
   - VS Code
   - IntelliJ
2. Standalone AI tools are installed separately for evaluation.
3. Multiple tools can coexist.
4. The repo should not assume one provider, model, or AI-native editor will win long term.

## Supported AI Installs

Current supported install targets:

- OpenAI Codex app
- OpenAI Codex CLI
- Cursor Editor
- Cursor CLI
- Windsurf Editor

## Current Exclusions

Not currently supported as first-class modules:

- Windsurf CLI
- broad AI plugin sprawl inside VS Code
- broad AI plugin sprawl inside IntelliJ
- opinionated default model/provider selection

## Install Policy for AI Tools

Policy:

- prefer Homebrew cask for desktop apps when the vendor officially supports it and it is reliable for current releases
- prefer Homebrew for CLIs when the vendor officially supports it and it is reliable for current releases
- otherwise prefer the official vendor installer/download flow
- do not use npm unless it is the only practical supported path

## Current AI Install Approach

### OpenAI Codex

- Codex CLI: installed via Homebrew
- Codex app: uses OpenAI’s official macOS download/install flow

### Cursor

- Cursor Editor: uses Cursor’s official download/install flow
- Cursor CLI: uses Cursor’s official installer flow

### Windsurf

- Windsurf Editor: uses Windsurf’s official download/install flow
- no standalone Windsurf CLI module is included yet

## Verification Policy for AI Tools

`./scripts/verify.sh` checks:

- Codex CLI availability
- Cursor CLI availability
- Codex app presence
- Cursor Editor presence
- Windsurf Editor presence

Desktop app checks are warnings when the app is not present, because vendor-download flows may still require GUI installation steps.

## Recommended Current Posture

For now:

- keep AI tools decoupled
- treat them as evaluation candidates
- avoid forcing them into anchor editors unless and until you intentionally decide to do so

## Version History

- v1: editors and AI guide created from the consolidated final documentation draft and AI tooling additions
