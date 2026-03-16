return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        bashls = {
          filetypes = { "bash", "sh", "zsh" },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        bash = { "shfmt" },
        sh = { "shfmt" },
        zsh = { "shfmt" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        bash = { "shellcheck" },
        sh = { "shellcheck" },
        zsh = { "shellcheck" },
      })
    end,
  },
}
