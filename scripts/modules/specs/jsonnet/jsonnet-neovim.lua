return {
  {
    name = "mac-dev-setup-jsonnet",
    lazy = false,
    init = function()
      vim.filetype.add({
        extension = {
          jsonnet = "jsonnet",
          libsonnet = "jsonnet",
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        jsonnet = { "jsonnetfmt" },
      })
    end,
  },
}
