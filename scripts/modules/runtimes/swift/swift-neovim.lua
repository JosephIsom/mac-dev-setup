return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("user.config.tooling").extend_servers(opts, {
        sourcekit = {
          cmd = { "xcrun", "sourcekit-lsp" },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("user.config.tooling").extend_formatters(opts, {
        swift = { "swiftformat" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("user.config.tooling").extend_linters(opts, {
        swift = { "swiftlint" },
      })
    end,
  },
}
