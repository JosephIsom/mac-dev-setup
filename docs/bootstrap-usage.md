# Bootstrap Usage

## Executive Summary

Use `scripts/bootstrap.sh` as the main entrypoint and `scripts/verify.sh` as the follow-up audit.

## Typical Machine Bootstrap

1. clone repo
2. create `config/user.env`
3. choose profile
4. run bootstrap
5. run verify
6. handle expected manual GUI/account steps
7. rerun targeted modules if needed

## Core Commands

### Base profile

```bash
./scripts/bootstrap.sh --profile base --non-interactive
./scripts/verify.sh
```

### Full profile

```bash
./scripts/bootstrap.sh --profile full --non-interactive
./scripts/verify.sh
```

### Interactive mode

```bash
./scripts/bootstrap.sh --profile base --interactive
```

### Force-enable or disable specific modules

```bash
./scripts/bootstrap.sh --profile base --non-interactive --with-editor-neovim --without-editor-intellij-toolbox
```

## `config/user.env`

Typical values include:

```bash
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="you@example.com"
GITHUB_GIT_PROTOCOL="ssh"

PYTHON_VERSION="3.12"
NODE_VERSION="lts"
GO_VERSION="latest"
JAVA_VERSION="21"

COLIMA_CPU="4"
COLIMA_MEMORY="8"
COLIMA_DISK="60"
```

## When Adding a New Tool

1. decide whether it is baseline or optional
2. add module and profile flags if needed
3. add verification
4. update Brewfile policy if appropriate
5. update docs

## When Changing Config

1. change repo-owned source under `home/...`
2. rerun relevant bootstrap module
3. verify resulting user config files
4. keep personal-only tweaks in local override files

## Practical Sequences

### IntelliJ / Toolbox

1. install JetBrains Toolbox
2. open Toolbox
3. sign in to JetBrains account
4. install IntelliJ IDEA from Toolbox
5. enable/generate Toolbox shell scripts
6. rerun the IntelliJ CLI helper phase

### SSH / GitHub SSH

1. apply SSH baseline
2. generate key if needed:
   - `ssh-keygen -t ed25519 -C "you@example.com"`
3. add public key to GitHub
4. test with:
   - `ssh -T git@github.com`
5. optionally enable the repo’s GitHub SSH check module

### Containers

1. install Colima and Docker CLI stack
2. install Buildx and Compose plugins
3. create Docker CLI plugin symlinks if needed
4. start Colima with selected CPU/memory/disk values
5. verify with `docker info`
6. verify end-to-end with `docker run --rm hello-world`

## Version History

- v1: bootstrap usage guide created from the consolidated final documentation draft
