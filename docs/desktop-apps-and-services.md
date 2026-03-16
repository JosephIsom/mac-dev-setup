# Desktop Apps And Services

This page covers macOS defaults, identity modules, secrets, remote access, browsers, SQL clients, REST clients, and other optional apps.

## macOS Defaults

| Module | Default | What it changes | Why it is included | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `macos/finder/finder.sh` | On | Shows all filename extensions, path bar, status bar, folder-first sorting, list view, and disables `.DS_Store` writes on network/USB volumes. | These are common developer-friendly Finder defaults. | [defaults(1)](https://ss64.com/mac/defaults.html) | None. |
| `macos/dock/dock.sh` | On | Enables Dock auto-hide, minimizes into app, hides recents, disables automatic Space reordering. | Keeps the Dock less noisy and Spaces more predictable. | [Mission Control and Dock settings](https://support.apple.com/guide/mac-help/mh35859/mac) | None. |
| `macos/input/input.sh` | On | Faster key repeat, disables “smart” text substitutions, enables tap-to-click, shows battery percentage. | Better default typing and trackpad behavior for development. | [Keyboard settings](https://support.apple.com/guide/mac-help/change-keyboard-settings-mchlp2886/mac) | None. |
| `macos/screenshots/screenshots.sh` | On | Sends screenshots to `~/Pictures/Screenshots`, keeps PNG, disables shadows. | Keeps screenshots organized and clean. | [Screenshot settings](https://support.apple.com/guide/mac-help/take-a-screenshot-mh26782/mac) | None. |

## Accounts And Identity

| Module | Default | What it does | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `accounts/github/github-ssh.sh` | On | Writes the GitHub SSH host config. | Use SSH-based Git remotes with GitHub. | [GitHub SSH](https://docs.github.com/authentication/connecting-to-github-with-ssh) | Your key still needs to be present in `~/.ssh`. |

## Secrets Managers

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `secrets/1password/1password-app.sh` | Optional | Installs 1Password and writes follow-up notes. | Use the app for passwords, secrets, and optional SSH agent support. | [1Password](https://1password.com/) | Sign in, optionally enable Touch ID, and enable the SSH agent only if you want that workflow. |
| `secrets/1password/1password-cli.sh` | Optional | Installs `op` and zsh completion. | Use `op signin`, `op item get`, `op run`. | [1Password CLI](https://developer.1password.com/docs/cli/) | The desktop app integration is optional but useful. |
| `secrets/bitwarden/bitwarden-app.sh` | Optional | Installs Bitwarden and writes follow-up notes. | Use the app for vault access and secure local storage. | [Bitwarden](https://bitwarden.com/) | Sign in after first launch. |
| `secrets/bitwarden/bitwarden-cli.sh` | Optional | Installs `bw` and zsh completion. | Use `bw login`, `bw sync`, `bw get`. | [Bitwarden CLI](https://bitwarden.com/help/cli/) | Authenticate using your preferred Bitwarden method. |

## Remote Access And Tunnels

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `remote-access/tailscale/tailscale.sh` | Optional | Installs Tailscale app, CLI, completion, and notes. | Use the app for login and `tailscale up` from the terminal if desired. | [Tailscale](https://tailscale.com/) | Launch the app, sign in, and approve macOS VPN/system-extension prompts. |
| `remote-access/ngrok/ngrok.sh` | Optional | Installs ngrok, CLI completion, and notes. | Use `ngrok config add-authtoken <token>` then `ngrok http 3000`. | [ngrok](https://ngrok.com/) | Add your authtoken after install. |

## Browsers, Git GUI, And General Desktop Apps

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `desktop/browsers/google-chrome/google-chrome.sh` | Optional | Installs Google Chrome. | Use it as a general browser or for Chrome-specific dev tools. | [Google Chrome](https://www.google.com/chrome/) | Optional sign-in. |
| `desktop/browsers/firefox/firefox.sh` | Optional | Installs Firefox. | Useful for cross-browser testing. | [Firefox](https://www.mozilla.org/firefox/) | Optional sign-in. |
| `desktop/browsers/duckduckgo/duckduckgo.sh` | Optional | Installs DuckDuckGo Browser. | Privacy-oriented alternative browser. | [DuckDuckGo Browser](https://duckduckgo.com/mac) | Optional. |
| `desktop/git-gui/github-desktop/github-desktop.sh` | Optional | Installs GitHub Desktop. | Use it if you want a visual Git workflow. | [GitHub Desktop](https://desktop.github.com/) | Sign in if you use it. |
| `desktop/cloud-storage/dropbox/dropbox.sh` | Optional | Installs Dropbox. | Use it for synced files. | [Dropbox](https://www.dropbox.com/) | Sign in after install. |
| `desktop/media/spotify/spotify.sh` | Optional | Installs Spotify. | General desktop media app. | [Spotify](https://www.spotify.com/) | Sign in after install. |

## SQL Clients

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `desktop/sql-clients/tableplus/tableplus.sh` | Optional | SQL client for many database engines. | Use it to connect to local or remote databases. | [TablePlus](https://tableplus.com/) | Add your own connections. |
| `desktop/sql-clients/sequel-ace/sequel-ace.sh` | Optional | Native MySQL/MariaDB client. | Use it for MySQL-family databases. | [Sequel Ace](https://sequel-ace.com/) | Add your own connections. |
| `desktop/sql-clients/datagrip/datagrip.sh` | Optional | JetBrains SQL IDE. | Use it if you want a full-featured IDE experience for databases. | [DataGrip](https://www.jetbrains.com/datagrip/) | Sign in with JetBrains if needed. |
| `desktop/sql-clients/dbeaver/dbeaver.sh` | Optional | Cross-database SQL client. | Use it for broad database support. | [DBeaver](https://dbeaver.io/) | Add your own drivers/connections. |
| `desktop/sql-clients/beekeeper-studio/beekeeper-studio.sh` | Optional | Friendly database client. | Use it for quick SQL work. | [Beekeeper Studio](https://www.beekeeperstudio.io/) | Add your own connections. |
| `desktop/sql-clients/postico/postico.sh` | Optional | Postgres-focused macOS client. | Use it for PostgreSQL. | [Postico](https://eggerapps.at/postico2/) | Add your own connections. |
| `desktop/sql-clients/pgadmin4/pgadmin4.sh` | Optional | PostgreSQL administration GUI. | Use it for heavier PostgreSQL admin tasks. | [pgAdmin 4](https://www.pgadmin.org/) | Add your own servers. |
| `desktop/sql-clients/tablepro/tablepro.sh` | Optional | Modern native database client. | Use it for general SQL client work. | [TablePro](https://tablepro.app/) | Add your own connections. |

## REST And API Clients

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `desktop/rest-clients/bruno/bruno.sh` | Optional | Git-friendly API client. | Use it for REST collections stored in your repo. | [Bruno](https://www.usebruno.com/) | Import or create collections. |
| `desktop/rest-clients/hoppscotch/hoppscotch.sh` | Optional | API client with local and hosted workflows. | Use it for HTTP, WebSocket, and related API testing. | [Hoppscotch](https://hoppscotch.com/) | Sign in only if you want cloud sync. |
| `desktop/rest-clients/httpie-desktop/httpie-desktop.sh` | Optional | GUI companion to HTTPie. | Use it for API exploration. | [HTTPie Desktop](https://httpie.io/product) | Optional sign-in. |
| `desktop/rest-clients/insomnia/insomnia.sh` | Optional | API client and collection runner. | Use it for REST, GraphQL, and plugin-driven API work. | [Insomnia](https://insomnia.rest/) | Optional sign-in. |
| `desktop/rest-clients/postman/postman.sh` | Optional | Popular API client platform. | Use it for shared collections, testing, and monitoring. | [Postman](https://www.postman.com/) | Sign in if you want sync/workspaces. |
