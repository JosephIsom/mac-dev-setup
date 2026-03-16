return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts = require("mac_dev_setup.config.tooling").extend_servers(opts, {
        svelte = {},
      })

      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        svelte = { "prettier" },
      })
    end,
  },
}
