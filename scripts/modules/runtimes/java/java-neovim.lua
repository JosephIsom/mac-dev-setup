return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      if not vim.tbl_contains(opts.ensure_installed, "java") then
        table.insert(opts.ensure_installed, "java")
      end

      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        jdtls = {
          cmd = { "jdtls" },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        java = { "google-java-format" },
      })
    end,
  },
}
