return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local on_attach = function(_, bufnr)
        local keymap = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        keymap("n", "gd", vim.lsp.buf.definition, "Go to definition")
        keymap("n", "gr", vim.lsp.buf.references, "References")
        keymap("n", "K", vim.lsp.buf.hover, "Hover")
        keymap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        keymap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local servers = {
        "gopls",
        "pyright",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "bashls",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          on_attach = on_attach,
          capabilities = capabilities,
        })
        vim.lsp.enable(server)
      end
    end,
  },
}
