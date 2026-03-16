return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}

      if not vim.tbl_contains(opts.ensure_installed, "php") then
        table.insert(opts.ensure_installed, "php")
      end

      return opts
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        phpactor = {
          cmd = { "phpactor", "language-server" },
          filetypes = { "php" },
          workspace_required = true,
          init_options = {
            ["language_server_phpstan.enabled"] = false,
            ["language_server_psalm.enabled"] = false,
          },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        php = { "php_cs_fixer" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        php = { "phpstan" },
      })
    end,
  },
}
