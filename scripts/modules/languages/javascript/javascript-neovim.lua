return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("user.config.tooling").extend_linters(opts, {
        javascript = { "eslint" },
        javascriptreact = { "eslint" },
      })
    end,
  },
}
