return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        groovy = { "npm-groovy-lint" },
        jenkinsfile = { "npm-groovy-lint" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        groovy = { "npm-groovy-lint" },
        jenkinsfile = { "npm-groovy-lint" },
      })
    end,
  },
}
