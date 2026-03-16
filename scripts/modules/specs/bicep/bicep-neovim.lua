return {
  {
    name = "mac-dev-setup-bicep",
    lazy = false,
    init = function()
      vim.filetype.add({
        extension = {
          bicep = "bicep",
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        bicep = { "bicep" },
      })
    end,
  },
}
