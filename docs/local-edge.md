# Local Edge

`local-edge/` is the repo's optional laptop edge stack for local HTTPS and clean `.localhost` routing.

It exists as a separate capability because the main bootstrap is still meant to stay focused on base machine setup and reusable tooling. Bootstrap installs the `caddy` module, but it does not configure Caddy, trust local certificates, create kind ingress mappings, or start services for you.

## What It Covers

- host-installed Caddy as the single front-door reverse proxy and TLS terminator
- `.localhost` hostnames without editing `/etc/hosts`
- local certificate trust with explicit operator action
- personal apps on host loopback ports or Docker or Colima
- work apps in kind behind Kubernetes Ingress on alternate host ports `8080` and `8443`

## Entry Point

Run:

```bash
./scripts/bootstrap-local-edge.sh setup
```

That stages the managed Caddyfile and kind config under `~/.config/mac-dev-setup/local-edge`, links Homebrew's active `Caddyfile` to the managed version with backup-safe behavior, validates the config, and prints the follow-up commands.

`setup` is the only command that provisions or relinks the managed local-edge config. The other `bootstrap-local-edge` commands are operational commands that expect setup to have already run.

## Common Commands

```bash
./scripts/bootstrap-local-edge.sh setup
./scripts/bootstrap-local-edge.sh caddy validate
./scripts/bootstrap-local-edge.sh caddy start
./scripts/bootstrap-local-edge.sh caddy trust-certs
./scripts/bootstrap-local-edge.sh kind create
./scripts/bootstrap-local-edge.sh kind install-ingress-nginx
./scripts/bootstrap-local-edge.sh examples up
./scripts/bootstrap-local-edge.sh smoke-test
./scripts/bootstrap-local-edge.sh safe-reset
```

## Read Next

- [local-edge README](/Users/joe/src/personal/mac-dev-setup/local-edge/README.md)
- [Architecture Notes](/Users/joe/src/personal/mac-dev-setup/local-edge/docs/architecture.md)
- [Troubleshooting](/Users/joe/src/personal/mac-dev-setup/local-edge/docs/troubleshooting.md)
