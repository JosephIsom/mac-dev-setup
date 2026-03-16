return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.buf_format = {
        inherit = false,
        command = "buf",
        args = { "format", "$FILENAME" },
        stdin = false,
      }

      return require("mac_dev_setup.config.tooling").extend_formatters(opts, {
        proto = { "buf_format" },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      return require("mac_dev_setup.config.tooling").extend_linters(opts, {
        proto = { "buf_lint" },
      })
    end,
  },
}
