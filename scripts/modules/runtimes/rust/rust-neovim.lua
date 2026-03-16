return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
              },
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        rust = { "rustfmt" },
      })
    end,
  },
}
