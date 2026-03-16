# Runtimes And Tooling

This page covers runtimes, build tools, language tooling, file-format tooling, and editor integrations.

## Runtime Modules

| Module | Default | Runtime / tools | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `runtimes/python/python-runtime.sh` | On | Python runtime via `mise`. | Use `python`, `python3`, and project-local virtual environments or `uv`. | [Python](https://www.python.org/), [mise Python](https://mise.jdx.dev/lang/python.html) | Set `PYTHON_VERSION` if you do not want `latest`. |
| `runtimes/python/uv.sh` | On | `uv` for Python package, tool, and environment management. | Use `uv init`, `uv sync`, `uv tool install`. | [uv](https://docs.astral.sh/uv/) | None. |
| `runtimes/python/linters.sh` | On | Python quality and editor stack through `pyright`, `ruff`, `mypy`, `pytest`, and `debugpy`, plus VS Code and Neovim assets. | Use the CLIs directly or rely on the staged editor integration. | [Pyright](https://github.com/microsoft/pyright), [Ruff](https://docs.astral.sh/ruff/), [mypy](https://mypy-lang.org/), [pytest](https://docs.pytest.org/), [debugpy](https://github.com/microsoft/debugpy) | None. |
| `runtimes/node/node-runtime.sh` | On | Node.js via `mise`, plus npm and Corepack. | Use `node`, `npm`, and Corepack-managed package managers. | [Node.js](https://nodejs.org/), [Corepack](https://nodejs.org/api/corepack.html) | Set `NODE_VERSION` if needed. |
| `runtimes/node/npm-completion.sh` | On | Adds shell completion for npm. | Use tab completion for npm commands and scripts. | [npm CLI](https://docs.npmjs.com/cli/) | None. |
| `runtimes/node/pnpm.sh` | On | `pnpm` via Corepack. | Use `pnpm install`, `pnpm dev`, and `pnpm dlx`. | [pnpm](https://pnpm.io/) | None. |
| `runtimes/node/yarn.sh` | On | `yarn` via Corepack. | Use `yarn install`, `yarn test`, and workspaces if needed. | [Yarn](https://yarnpkg.com/) | None. |
| `runtimes/node/typescript.sh` | On | Base TypeScript runtime tools: `tsc`, `tsx`. | Use `tsc` and `tsx` outside editor-specific tooling. | [TypeScript](https://www.typescriptlang.org/), [tsx](https://tsx.is/) | None. |
| `runtimes/go/go-runtime.sh` | On | Go runtime via `mise`. | Use `go mod`, `go test`, `go run`, `go work`. | [Go](https://go.dev/) | Set `GO_VERSION` if needed. |
| `runtimes/go/dev-tools.sh` | On | Go formatter, linter, debugger, imports, static analysis, and VS Code/Neovim assets through `gopls`, `golangci-lint`, `dlv`, `goimports`, and `staticcheck`. | Use the CLIs directly or rely on editor integration. | [gopls](https://pkg.go.dev/golang.org/x/tools/gopls), [golangci-lint](https://golangci-lint.run/), [Delve](https://github.com/go-delve/delve) | None. |
| `runtimes/java/java-runtime.sh` | On | Java runtime via `mise`. | Use `java`, `javac`, and JVM build tools. | [OpenJDK](https://openjdk.org/), [mise Java](https://mise.jdx.dev/lang/java.html) | Set `JAVA_VERSION` if needed. |
| `runtimes/java/java-tooling.sh` | On | Java LSP, formatter, and editor integration through `jdtls`, `google-java-format`, VS Code, and Neovim. | Use the tools directly or rely on your editor integrations. | [JDTLS](https://github.com/eclipse/eclipse.jdt.ls), [google-java-format](https://github.com/google/google-java-format) | None. |
| `runtimes/lua/lua-runtime.sh` | On | Lua runtime via `mise`. | Use `lua` and Lua-based tools. | [Lua](https://www.lua.org/) | Set `LUA_VERSION` if needed. |
| `runtimes/lua/lua-tooling.sh` | On | Lua language server, formatter, and linter through `lua-language-server`, `stylua`, and `luacheck`. | Use the CLIs directly or rely on editor integration. | [Lua Language Server](https://luals.github.io/), [StyLua](https://github.com/JohnnyMorganz/StyLua), [Luacheck](https://github.com/lunarmodules/luacheck) | None. |
| `runtimes/swift/swift-tooling.sh` | On | Swift formatter, linter, and LSP support. | Use `swiftlint`, `swiftformat`, and SourceKit-LSP-backed editors. | [Swift](https://www.swift.org/), [SwiftLint](https://github.com/realm/SwiftLint), [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) | Full Xcode app is still manual if you need full Apple IDE support. |
| `runtimes/powershell/powershell-runtime.sh` | Optional | PowerShell runtime. | Use `pwsh`. | [PowerShell](https://learn.microsoft.com/powershell/) | Optional. |
| `runtimes/powershell/powershell-tooling.sh` | Optional | PowerShell analysis tooling. | Use `PSScriptAnalyzer` in scripts and editors. | [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) | Optional. |
| `runtimes/rust/rust-runtime.sh` | Optional | Rust runtime. | Use `cargo`, `rustc`, `cargo test`. | [Rust](https://www.rust-lang.org/) | Set `RUST_VERSION` if needed. |
| `runtimes/rust/rust-tooling.sh` | Optional | Rust analyzer, formatter, lints, and cargo utilities. | Use `rust-analyzer`, `rustfmt`, `clippy`, `cargo-audit`, `cargo-nextest`, `bacon`. | [rust-analyzer](https://rust-analyzer.github.io/), [Cargo](https://doc.rust-lang.org/cargo/) | Optional. |
| `runtimes/bun/bun-runtime.sh` | Optional | Bun runtime. | Use `bun install`, `bun run`, `bun test`. | [Bun](https://bun.sh/) | Optional. |
| `runtimes/dotnet/dotnet-runtime.sh` | Optional | .NET SDK plus completions and formatter support. | Use `dotnet`, `dotnet new`, `dotnet test`, `dotnet format`. | [.NET](https://dotnet.microsoft.com/), [CLI completion](https://learn.microsoft.com/dotnet/core/tools/enable-tab-autocomplete) | Optional. |
| `runtimes/groovy/groovy-runtime.sh` | Optional | Groovy runtime. | Use `groovy` and `groovyc`. | [Groovy](https://groovy-lang.org/) | Optional. |
| `runtimes/groovy/groovy-tooling.sh` | Optional | Groovy linting and editor support. | Use `npm-groovy-lint` and the editor integrations. | [npm-groovy-lint](https://github.com/nvuillam/npm-groovy-lint) | Optional. |
| `runtimes/kotlin/kotlin-runtime.sh` | Optional | Kotlin runtime. | Use `kotlin`, `kotlinc`, and Gradle/Maven projects. | [Kotlin](https://kotlinlang.org/) | Optional. |
| `runtimes/kotlin/kotlin-tooling.sh` | Optional | Kotlin LSP, formatter, and linter. | Use `kotlin-language-server`, `ktfmt`, and `detekt`. | [Kotlin](https://kotlinlang.org/), [detekt](https://detekt.dev/) | Optional. |
| `runtimes/java/spring-boot.sh` | Optional | Spring Boot CLI plus completion. | Use `spring init`, `spring run`, and shell completion. | [Spring Boot CLI](https://docs.spring.io/spring-boot/installing.html) | Optional. |
| `runtimes/php/php-runtime.sh` | Optional | PHP runtime via `mise`. | Use `php`, `php -S`, and Composer-based projects. | [PHP](https://www.php.net/) | Optional. |
| `runtimes/php/php-tooling.sh` | Optional | Composer, PHPStan, PHP CS Fixer, and PHPActor. | Use the tools directly and through editors. | [Composer](https://getcomposer.org/), [PHPStan](https://phpstan.org/), [PHP CS Fixer](https://cs.symfony.com/), [PHPActor](https://phpactor.readthedocs.io/) | Optional. |
| `runtimes/ruby/ruby-runtime.sh` | Optional | Ruby runtime via `mise`. | Use `ruby`, `gem`, `bundle`, `rake`. | [Ruby](https://www.ruby-lang.org/), [Bundler](https://bundler.io/) | Optional. |
| `runtimes/ruby/ruby-tooling.sh` | Optional | RuboCop and Ruby LSP. | Use `rubocop` and editor LSP support. | [RuboCop](https://rubocop.org/), [Ruby LSP](https://shopify.github.io/ruby-lsp/) | Optional. |
| `runtimes/zig/zig-runtime.sh` | Optional | Zig runtime. | Use `zig build`, `zig run`, `zig test`. | [Zig](https://ziglang.org/) | Optional. |
| `runtimes/zig/zig-tooling.sh` | Optional | Zig language server. | Use `zls` through editors. | [ZLS](https://github.com/zigtools/zls) | Optional. |

## Build Tooling

| Module | Default | What / why | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `build/jvm/maven.sh` | On | Maven for JVM projects. | Use `mvn clean test package`. | [Maven](https://maven.apache.org/) | None. |
| `build/jvm/gradle.sh` | On | Gradle for JVM projects. | Use `gradle build` or the project wrapper `./gradlew`. | [Gradle](https://gradle.org/) | None. |

## Language And File Tooling

| Module | Default | Formatter / linter / LSP coverage | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `languages/javascript/javascript-tooling.sh` | On | ESLint plus VS Code/Neovim settings and tasks. | Use `eslint`, editor fix-on-save, and the staged VS Code tasks. | [ESLint](https://eslint.org/) | None. |
| `languages/typescript/typescript-tooling.sh` | On | `typescript`, `typescript-language-server`, VS Code tasks/launch config, Neovim LSP. | Use `tsc`, `typescript-language-server`, and editor integration. | [TypeScript](https://www.typescriptlang.org/), [typescript-language-server](https://github.com/typescript-language-server/typescript-language-server) | None. |
| `languages/sql/sql-tooling.sh` | On | `sqlfluff`, `sql-language-server`, VS Code, Neovim. | Use `sqlfluff lint/fix` and your editor for SQL completion. | [SQLFluff](https://sqlfluff.com/), [sql-language-server](https://github.com/joe-re/sql-language-server) | None. |
| `languages/protobuf/protobuf-tooling.sh` | On | `protoc`, `buf`, Neovim. | Use `buf lint`, `buf format`, `protoc`. | [Protocol Buffers](https://protobuf.dev/), [Buf](https://buf.build/) | None. |
| `languages/vue/vue-tooling.sh` | Optional | `vue-language-server`, `vue-tsc`, VS Code, Neovim. | Use Volar-based editor support and `vue-tsc`. | [Vue](https://vuejs.org/), [Volar](https://github.com/vuejs/language-tools) | Optional. |
| `languages/svelte/svelte-tooling.sh` | Optional | Svelte language server, VS Code, Neovim. | Use Svelte editor tooling and project package scripts. | [Svelte](https://svelte.dev/), [Svelte for VS Code](https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode) | Optional. |
| `languages/graphql/graphql-tooling.sh` | Optional | GraphQL language server, VS Code, Neovim. | Use GraphQL editor validation and schema-aware completion. | [GraphQL](https://graphql.org/), [GraphQL LSP](https://the-guild.dev/graphql/eslint/docs/commands/graphql-language-service-cli) | Optional. |
| `languages/gradle-groovy/gradle-groovy-tooling.sh` | Optional | Groovy language server built from source, Neovim. | Use the managed `groovy-language-server` wrapper in editors. | [Groovy Language Server](https://github.com/GroovyLanguageServer/groovy-language-server) | This upstream project does not publish stable tags/branches, so the repo intentionally treats it as an exception. |
| `files/formatting/formatting-tooling.sh` | On | Shared `prettier` baseline and editor settings. | Use `prettier` directly or through editor format-on-save. | [Prettier](https://prettier.io/) | None. |
| `files/html/html-tooling.sh` | On | HTML language server and Neovim support. | Use editor formatting and HTML language features. | [VS Code HTML Language Features](https://github.com/microsoft/vscode-html-languageservice) | None. |
| `files/css/css-tooling.sh` | On | Stylelint and CSS language server. | Use `stylelint` and editor CSS validation. | [Stylelint](https://stylelint.io/), [VS Code CSS Language Features](https://github.com/microsoft/vscode-css-languageservice) | None. |
| `files/json/json-tooling.sh` | On | JSON language server support. | Use editor validation and schema-backed editing. | [VS Code JSON Language Service](https://github.com/microsoft/vscode-json-languageservice) | None. |
| `files/markdown/markdown-tooling.sh` | On | `marksman`, `markdownlint`, editor support. | Use `markdownlint` and editor Markdown features. | [Marksman](https://github.com/artempyanykh/marksman), [markdownlint-cli](https://github.com/igorshubovych/markdownlint-cli) | None. |
| `files/yaml/yaml-tooling.sh` | On | `yamllint`, `yaml-language-server`, VS Code, Neovim. | Use `yamllint` and schema-aware YAML editing. | [YAML Language Server](https://github.com/redhat-developer/yaml-language-server), [yamllint](https://yamllint.readthedocs.io/) | None. |
| `files/dotenv/dotenv-tooling.sh` | On | `.env` syntax support in Neovim. | Use editor highlighting and completion. | [dotenv](https://github.com/motdotla/dotenv) | None. |
| `files/ini-editorconfig/ini-editorconfig-tooling.sh` | On | EditorConfig and INI support helpers. | Use editor support for `.editorconfig` and INI-style files. | [EditorConfig](https://editorconfig.org/) | None. |
| `files/shell-scripts/shell-scripts-tooling.sh` | On | `shellcheck`, `shfmt`, `bash-language-server`, Neovim. | Use `shellcheck`, `shfmt`, and shell LSP in editors. | [ShellCheck](https://www.shellcheck.net/), [shfmt](https://github.com/mvdan/sh), [bash-language-server](https://github.com/bash-lsp/bash-language-server) | None. |
| `files/taskfile/taskfile-tooling.sh` | On | `task` plus completion and editor support. | Use `task` in Taskfile-based repos. | [Task](https://taskfile.dev/) | None. |
| `files/justfile/justfile-tooling.sh` | On | `just` support. | Use `just` in Justfile-based repos. | [just](https://just.systems/) | None. |
| `files/toml/toml-tooling.sh` | On | TOML support with editor integration. | Use editor validation for TOML files. | [Taplo](https://taplo.tamasfe.dev/) | None. |
| `files/mermaid/mermaid-tooling.sh` | Optional | Mermaid CLI. | Use `mmdc` to render diagrams. | [Mermaid](https://mermaid.js.org/) | Optional. |
| `files/asciidoc/asciidoc-tooling.sh` | Optional | Asciidoctor, Vale, Neovim. | Use `asciidoctor` for rendering and `vale` for prose linting. | [Asciidoctor](https://asciidoctor.org/), [Vale](https://vale.sh/) | Optional. |
| `files/plantuml/plantuml-tooling.sh` | Optional | PlantUML tooling. | Use PlantUML in docs and diagrams. | [PlantUML](https://plantuml.com/) | Optional. |

## Specs, Infra, And Config Languages

| Module | Default | Coverage | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `specs/openapi/openapi-tooling.sh` | On | Redocly CLI and editor support. | Use `redocly lint` and editor integrations for OpenAPI specs. | [OpenAPI](https://www.openapis.org/), [Redocly CLI](https://redocly.com/docs/cli/) | None. |
| `specs/asyncapi/asyncapi-tooling.sh` | On | AsyncAPI CLI and Neovim support. | Use AsyncAPI validation tooling in spec repos. | [AsyncAPI](https://www.asyncapi.com/) | None. |
| `specs/json-schema/json-schema-tooling.sh` | On | `ajv` validation and Neovim support. | Use `ajv` to validate schemas and instances. | [JSON Schema](https://json-schema.org/), [Ajv](https://ajv.js.org/) | None. |
| `specs/terraform-hcl/terraform-hcl-tooling.sh` | On | Terraform, `tflint`, `terraform-ls`, completion, VS Code, Neovim. | Use `terraform fmt/plan/apply`, `tflint`, and editor integrations. | [Terraform](https://developer.hashicorp.com/terraform), [TFLint](https://github.com/terraform-linters/tflint), [terraform-ls](https://github.com/hashicorp/terraform-ls) | None. |
| `specs/dockerfile/dockerfile-tooling.sh` | On | `hadolint`, Dockerfile language server, Neovim. | Use `hadolint` and editor Dockerfile features. | [hadolint](https://github.com/hadolint/hadolint), [dockerfile-language-server](https://github.com/rcjsuen/dockerfile-language-server-nodejs) | None. |
| `specs/compose/compose-tooling.sh` | On | Docker Compose language server and Neovim. | Use editor validation for Compose files. | [Docker Compose](https://docs.docker.com/compose/) | None. |
| `specs/github-actions/github-actions-tooling.sh` | On | GitHub Actions editor support. | Use editor validation and Actions-specific YAML features. | [GitHub Actions](https://docs.github.com/actions) | None. |
| `specs/cue/cue-tooling.sh` | Optional | `cue` tooling, LSP, Neovim. | Use `cue fmt`, `cue vet`, and editor support. | [CUE](https://cuelang.org/) | Optional. |
| `specs/rego-opa/rego-opa-tooling.sh` | Optional | `opa`, `regal`, Neovim. | Use `opa fmt`, `opa test`, and `regal`. | [OPA](https://www.openpolicyagent.org/), [Regal](https://github.com/styrainc/regal) | Optional. |
| `specs/helm/helm-tooling.sh` | Optional | Helm chart authoring support for editors. | Use it when you write Helm charts, not just run Helm CLI commands. | [Helm](https://helm.sh/) | Optional. |
| `specs/ansible/ansible-tooling.sh` | Optional | `ansible-lint`, `ansible-playbook`, Neovim. | Use it in playbook-driven repos. | [Ansible](https://www.ansible.com/), [ansible-lint](https://ansible.readthedocs.io/projects/lint/) | Optional. |
| `specs/jsonnet/jsonnet-tooling.sh` | Optional | Jsonnet tooling and Neovim support. | Use `jsonnet` and related tooling in config repos. | [Jsonnet](https://jsonnet.org/) | Optional. |
| `specs/bicep/bicep-tooling.sh` | Optional | Bicep tooling and Neovim support. | Use it for Azure IaC repos. | [Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/) | Optional. |

## Notebook Support

| Module | Default | What it adds | How to use it | Links | Follow-up |
| --- | --- | --- | --- | --- | --- |
| `runtimes/python/python-notebook-tooling.sh` | Optional | JupyterLab, `nbqa`, `jupytext`, Neovim, and VS Code notebook assets. | Use JupyterLab for notebooks, `jupytext` for text pairing, and `nbqa` to run code quality tools against notebooks. | [JupyterLab](https://jupyterlab.readthedocs.io/), [nbQA](https://nbqa.readthedocs.io/), [Jupytext](https://jupytext.readthedocs.io/) | Optional. |

## Editor Integration Model

For many languages, the repo stages three kinds of assets automatically:

- Neovim plugin specs
- VS Code extension manifests and settings fragments
- VS Code reusable task, launch, or workspace templates where they help

That means language modules are not only “install the CLI”; they also make the editor setup consistent with the machine tooling.
