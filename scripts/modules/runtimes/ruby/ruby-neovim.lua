return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("user.config.tooling").extend_servers(opts, {
        ruby_lsp = {},
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("user.config.tooling").extend_formatters(opts, {
        ruby = { "rubocop" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("user.config.tooling").extend_linters(opts, {
        ruby = { "rubocop" },
      })
    end,
  },
}
