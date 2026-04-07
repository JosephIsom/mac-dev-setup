return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = require("user.config.tooling").extend_servers(opts, {
        svelte = {},
      })

      return require("user.config.tooling").extend_formatters(opts, {
        svelte = { "prettier" },
      })
    end,
  },
}
