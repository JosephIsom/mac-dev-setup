return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({
        extension = {
          cue = "cue",
        },
      })
    end,
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_servers(opts, {
        cue_lsp = {
          cmd = { "cue", "lsp", "serve" },
          filetypes = { "cue" },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.cue_fmt = {
        inherit = false,
        command = "cue",
        args = { "fmt", "$FILENAME" },
        stdin = false,
      }

      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        cue = { "cue_fmt" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        cue = { "cue" },
      })
    end,
  },
}
