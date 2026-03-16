local capabilities = vim.lsp.protocol.make_client_capabilities()

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      servers = {},
    },
    config = function(_, opts)
      for server, server_opts in pairs(opts.servers or {}) do
        vim.lsp.config(server, vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, server_opts))
        vim.lsp.enable(server)
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function()
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
        }
      end,
      formatters_by_ft = {},
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      linters_by_ft = {},
    },
    config = function(_, opts)
      local lint = require("lint")

      lint.linters_by_ft = opts.linters_by_ft or {}

      local group = vim.api.nvim_create_augroup("mac-dev-setup-lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
        group = group,
        callback = function(args)
          if vim.bo[args.buf].buftype ~= "" then
            return
          end

          lint.try_lint()
        end,
      })
    end,
  },
}
