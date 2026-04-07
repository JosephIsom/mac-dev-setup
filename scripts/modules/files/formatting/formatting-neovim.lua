return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      return require("user.config.tooling").extend_formatters(opts, {
        css = { "prettier" },
        graphql = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
      })
    end,
  },
}
