return {
  {
    "stevearc/conform.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          bicep = "bicep",
        },
      })
    end,
    opts = function(_, opts)
      return require("user.config.tooling").extend_formatters(opts, {
        bicep = { "bicep" },
      })
    end,
  },
}
