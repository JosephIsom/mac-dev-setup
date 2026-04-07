return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("user.config.tooling").extend_servers(opts, {
        pyright = {},
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("user.config.tooling").extend_formatters(opts, {
        python = { "ruff_fix", "ruff_format" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("user.config.tooling").extend_linters(opts, {
        python = { "ruff", "mypy" },
      })
    end,
  },
}
