return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("user.config.tooling").extend_servers(opts, {
        cssls = {},
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("user.config.tooling").extend_linters(opts, {
        css = { "stylelint" },
        scss = { "stylelint" },
      })
    end,
  },
}
