# local-edge templates

These are the repo-owned source templates for the optional local-edge environment.

`./scripts/bootstrap-local-edge.sh setup` renders them into the managed working state under `~/.config/mac-dev-setup/local-edge/`.

After rendering, the working copies become operator-owned. Setup will not overwrite a changed working copy; it logs a warning instead.
