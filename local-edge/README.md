# local-edge

`local-edge/` is the repo's opt-in laptop edge stack. The name is intentional: this directory owns the local reverse-proxy, TLS, hostname, and ingress edge concerns for the laptop, without turning the main bootstrap into a second environment orchestration system.

## What Bootstrap Does And Does Not Do

Main bootstrap:

- installs the `caddy` binary through the existing modules system
- installs `kind`, `kubectl`, `helm`, Docker CLI, Colima, and related prerequisites
- does not configure the local edge stack
- does not trust local certificates
- does not start Caddy
- does not create the kind cluster

Local edge bootstrap:

- stages the managed Caddy and kind config
- links Homebrew's active `Caddyfile` to the managed one with backup-safe behavior
- validates the managed Caddyfile
- offers an explicit certificate trust step
- creates and tears down the kind cluster on demand
- brings up example personal and work apps for smoke testing

After `./scripts/bootstrap-local-edge.sh setup` has completed, the rest of the `bootstrap-local-edge` commands are operational commands. They do not provision or relink the managed config for you.

## Layout

- `docs/`: architecture notes and troubleshooting
- `examples/`: Docker and Kubernetes sample workloads
- `scripts/`: the opt-in command surface and helper scripts
- `templates/`: repo-owned templates copied into `~/.config/mac-dev-setup/local-edge`

## Managed State

The setup flow creates or manages:

- `~/.config/mac-dev-setup/local-edge/caddy/Caddyfile`
- `~/.config/mac-dev-setup/local-edge/caddy/sites.d/*.caddy`
- `~/.config/mac-dev-setup/local-edge/kind/kind-edge.yaml`
- `~/.config/mac-dev-setup/local-edge/backups/`
- `~/.config/mac-dev-setup/local-edge/runtime/homebrew-caddyfile-state`
- Homebrew's live `Caddyfile` path at `/opt/homebrew/etc/Caddyfile` or `/usr/local/etc/Caddyfile`, backed up before replacement when needed

Setup does not modify `/etc/hosts`.
Setup is the only command that provisions or relinks this managed state.

## Commands

```bash
./scripts/bootstrap-local-edge.sh setup
./scripts/bootstrap-local-edge.sh caddy validate
./scripts/bootstrap-local-edge.sh caddy start
./scripts/bootstrap-local-edge.sh caddy reload
./scripts/bootstrap-local-edge.sh caddy stop
./scripts/bootstrap-local-edge.sh caddy trust-certs
./scripts/bootstrap-local-edge.sh kind create
./scripts/bootstrap-local-edge.sh kind delete
./scripts/bootstrap-local-edge.sh kind recreate
./scripts/bootstrap-local-edge.sh kind install-ingress-nginx
./scripts/bootstrap-local-edge.sh examples up
./scripts/bootstrap-local-edge.sh examples down
./scripts/bootstrap-local-edge.sh smoke-test --include-kind --insecure
./scripts/bootstrap-local-edge.sh safe-reset
```

Every command above except `setup` assumes setup has already completed.

## Standard Flow

```bash
./scripts/bootstrap.sh
./scripts/bootstrap-local-edge.sh setup
./scripts/bootstrap-local-edge.sh caddy start
./scripts/bootstrap-local-edge.sh caddy trust-certs
./scripts/bootstrap-local-edge.sh kind create
./scripts/bootstrap-local-edge.sh kind install-ingress-nginx
./scripts/bootstrap-local-edge.sh examples up
./scripts/bootstrap-local-edge.sh smoke-test --include-kind
```

Use `--insecure` on the smoke test until the CA has been trusted.

## Adding Personal Services

1. Run the host process or Docker workload on a loopback port such as `127.0.0.1:18100`.
2. Add a new site block to `~/.config/mac-dev-setup/local-edge/caddy/sites.d/10-host-services.caddy`.
3. Reload Caddy with `./scripts/bootstrap-local-edge.sh caddy reload`.

Example:

```caddyfile
dashboard.localhost {
	import localhost_site_defaults
	reverse_proxy 127.0.0.1:18100
}
```

## Adding Work App Hostnames

1. Expose the workload inside kind with a `Service`.
2. Install the ingress controller you want to use inside kind.
3. Add a Kubernetes `Ingress` for a `.localhost` hostname.
4. Add the hostname to `~/.config/mac-dev-setup/local-edge/caddy/sites.d/20-kind-services.caddy`.
5. Reload Caddy.

The repo includes `./scripts/bootstrap-local-edge.sh kind install-ingress-nginx` as a concrete example helper, but that controller choice stays explicit rather than being auto-enabled during setup.

Example Caddy block:

```caddyfile
preview-api.localhost {
	import localhost_site_defaults
	reverse_proxy http://127.0.0.1:8080 {
		header_up Host {host}
		header_up X-Forwarded-Host {host}
		header_up X-Forwarded-Proto {scheme}
	}
}
```

Example Kubernetes ingress host:

```yaml
spec:
  rules:
    - host: preview-api.localhost
```

## TLS And `.localhost`

- `.localhost` names resolve to loopback on modern macOS without editing `/etc/hosts`
- Caddy terminates TLS on `80` and `443`
- `tls internal` issues certificates from Caddy's local CA
- `./scripts/bootstrap-local-edge.sh caddy trust-certs` performs the explicit trust-store step
- kind ingress stays on `127.0.0.1:8080` and `127.0.0.1:8443`, behind Caddy

## kind And Caddy Together

- Caddy is the single front door and TLS terminator
- personal services stay on host loopback ports
- the kind cluster exposes ingress on alternate host ports so it does not compete for `80` and `443`
- Caddy proxies work hostnames to the kind ingress entrypoint and preserves the original `Host` header

## Reset And Troubleshooting

- `./scripts/bootstrap-local-edge.sh safe-reset` stops the managed pieces, archives the managed state, and restores the previous Homebrew `Caddyfile` when one was backed up
- [Architecture Notes](/Users/joe/src/personal/mac-dev-setup/local-edge/docs/architecture.md)
- [Troubleshooting](/Users/joe/src/personal/mac-dev-setup/local-edge/docs/troubleshooting.md)
