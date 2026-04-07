return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("user.config.tooling").extend_servers(opts, {
        regal = {
          cmd = { "regal", "language-server" },
          filetypes = { "rego" },
          settings = {
            regal = {
              formatting = {
                command = "opa fmt --rego-v1",
              },
            },
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("user.config.tooling").extend_linters(opts, {
        rego = { "regal" },
      })
    end,
  },
}
