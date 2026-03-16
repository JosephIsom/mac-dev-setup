return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
      })
    end,
  },
}
