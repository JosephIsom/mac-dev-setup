# mac-dev-setup

Automation-first macOS development environment bootstrap.

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
- evaluation-friendly AI tooling support without locking into a single AI workflow

## What this repo is for

Use this repo when you want:

- a repeatable new-Mac setup
- profile-driven installation
- rerunnable bootstrap phases
- a curated baseline plus opt-in tooling
- a stable base editor/IDE layer with room to evaluate fast-moving AI tools separately

## Scope

This repository currently covers:

- core machine bootstrap
- shell and terminal tooling
- Git, GitHub CLI, and SSH baseline config
- Python, Node, Go, and Java runtimes
- language-specific dev tooling
- container tooling and runtime
- editor installation and baseline config
- selected standalone AI tooling installs
- repo policy files and quality tooling
- machine verification

It does not try to fully automate:

- every first-launch GUI workflow
- every personal preference/theme tweak
- every IDE-specific sign-in flow
- every AI model/provider choice
- every macOS defaults opinion

## Profiles

### minimal

Lean bootstrap for a smaller baseline.

Use when you want:

- core package manager and shell baseline
- Git/GitHub CLI
- Python baseline
- minimal quality tools
- no AI tooling by default

### base

Recommended default profile.

Use when you want:

- core shell/tooling baseline
- all major runtimes
- Docker/Colima stack
- VS Code baseline
- core quality and dev tooling
- AI tooling evaluation support enabled by default

### full

Broader workstation profile.

Use when you want:

- all of base
- IntelliJ/Toolbox path
- Neovim path
- more quality tools
- fuller workstation experience
- AI tooling evaluation support enabled by default

## Quick Start

1. Clone the repo.
2. Create `config/user.env`.
3. Choose a profile.
4. Run bootstrap.
5. Run verify.
6. Complete expected GUI/account steps.
7. Re-run targeted modules if needed.

Example:

```bash
./scripts/bootstrap.sh --profile base --non-interactive
./scripts/verify.sh
```

## Key Decisions

- Package installation: Homebrew
- Runtime/version management: mise
- Python dependency management: uv-first, pip fallback
- JS/TS dependency management: pnpm-first, npm fallback
- Docker runtime on macOS: Colima + Docker CLI stack
- Shell target: zsh only
- Environment tools: mise by default, direnv optional and off by default

See `docs/tooling-decisions.md` for the full rationale.

## Editors and AI

Anchor editors:

- VS Code
- IntelliJ

Additional supported tools:

- OpenAI Codex app
- OpenAI Codex CLI
- Cursor Editor
- Cursor CLI
- Windsurf Editor

Current AI posture:

- keep anchor editors stable
- use native/built-in AI in VS Code and IntelliJ for now
- install standalone AI tools separately for evaluation
- do not assume one editor, one model, or one vendor will win long term

See `docs/editors-and-ai.md`.

## Verification

Use:

```bash
./scripts/verify.sh
```

This checks:

- core commands present
- runtimes present
- Docker stack reachable
- selected editor CLIs present where applicable
- selected AI CLIs/apps present where applicable
- key managed config files exist

Warnings are acceptable for intentionally optional items.

See `docs/troubleshooting-and-verification.md`.

## Documentation Map

- `docs/architecture.md`
- `docs/bootstrap-usage.md`
- `docs/tooling-decisions.md`
- `docs/editors-and-ai.md`
- `docs/troubleshooting-and-verification.md`

## Version History

- v1: initial repo docs set created from the consolidated final documentation draft
