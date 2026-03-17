return {
  {
    "stevearc/conform.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          jsonnet = "jsonnet",
          libsonnet = "jsonnet",
        },
      })
    end,
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        jsonnet = { "jsonnetfmt" },
      })
    end,
  },
}
