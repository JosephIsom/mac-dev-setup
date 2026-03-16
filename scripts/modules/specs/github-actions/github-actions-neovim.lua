return {
  {
    "mfussenegger/nvim-lint",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/%.github/workflows/.*%.ya?ml"] = "yaml.ghaction",
        },
      })
    end,
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        ghaction = { "actionlint" },
        ["yaml.ghaction"] = { "actionlint" },
      })
    end,
  },
}
