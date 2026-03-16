return {
  {
    "mfussenegger/nvim-lint",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/openapi%.json"] = "json.openapi",
          [".*/openapi%.ya?ml"] = "yaml.openapi",
        },
      })
    end,
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        openapi = { "redocly" },
        ["json.openapi"] = { "redocly" },
        ["yaml.openapi"] = { "redocly" },
      })
    end,
  },
}
