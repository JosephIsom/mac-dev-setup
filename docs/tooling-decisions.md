# Tooling Decisions

## Executive Summary

This repo favors one primary choice per category, with explicit fallbacks where needed.

## Package Installation

- Primary: Homebrew
- Reason: standard macOS package manager with strong ecosystem coverage

## Runtime and Version Management

- Primary: mise
- Reason: one version manager across Python, Node, Go, Java, and more

## Python

### Runtime

- managed by mise

### Primary dependency workflow

- uv

### Fallback

- pip

### Policy

- use `mise` for Python runtime versions
- use `uv` for project/package/dependency workflows
- keep `pip` available for compatibility and edge cases

## JavaScript / TypeScript

### Runtime

- managed by mise

### Primary dependency workflow

- pnpm

### Fallback

- npm

### Policy

- use `mise` for Node runtime versions
- keep npm because it ships with Node
- prefer pnpm for active package management

## Go

- runtime managed by mise
- dependency management uses built-in Go modules

## Java

- runtime managed by mise
- Maven and Gradle are both supported
- choose based on project context

## Shell

- zsh only
- bash is intentionally not a first-class target in this setup

## Docker Runtime on macOS

- Colima
- Docker CLI
- Docker Buildx
- Docker Compose

Docker Desktop is intentionally not part of the baseline.

## Environment Tools

- `mise` is the default environment/version tool
- `direnv` remains optional and off by default

Policy:

- do not use direnv in the default baseline
- enable it only for specific workflows that need it

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

## Not Recommended as Default Additions

- Docker Desktop
- Poetry / Pipenv / nvm / asdf / pyenv
- Oh My Zsh or extra shell frameworks by default
- Ruby/Perl Neovim providers
- direnv in the default baseline
- hard-locking the repo to one AI editor or one model/provider workflow

## Version History

- v1: tooling decisions guide created from the consolidated final documentation draft
