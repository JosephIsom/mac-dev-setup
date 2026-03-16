return {
  {
    "mfussenegger/nvim-lint",
    init = function()
      vim.filetype.add({
        pattern = {
          [".*/%.env"] = "dotenv",
          [".*/%.env%..+"] = "dotenv",
        },
      })
    end,
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        dotenv = { "dotenv_linter" },
      })
    end,
  },
}
