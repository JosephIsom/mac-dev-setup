return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("user.config.tooling").extend_servers(opts, {
        sqls = {
          cmd = { "sql-language-server", "up", "--method", "stdio" },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("user.config.tooling").extend_formatters(opts, {
        sql = { "sqlfluff" },
      })
    end,
  },
}
