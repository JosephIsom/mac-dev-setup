return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("user.config.tooling").extend_servers(opts, {
        kotlin_language_server = {
          cmd = { "kotlin-language-server" },
          filetypes = { "kotlin" },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("user.config.tooling").extend_formatters(opts, {
        kotlin = { "ktfmt" },
      })
    end,
  },
}
