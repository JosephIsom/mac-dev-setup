return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = require("user.config.tooling").extend_servers(opts, {
        graphql = {},
      })

      return require("user.config.tooling").extend_formatters(opts, {
        graphql = { "prettier" },
      })
    end,
  },
}
