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
      return require("user.config.tooling").extend_formatters(opts, {
        jsonnet = { "jsonnetfmt" },
      })
    end,
  },
}
