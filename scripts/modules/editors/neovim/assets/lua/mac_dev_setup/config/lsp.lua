local group = vim.api.nvim_create_augroup("mac-dev-setup-lsp", { clear = true })

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, {
        buffer = event.buf,
        desc = "LSP: " .. desc,
      })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gr", vim.lsp.buf.references, "Go to references")
    map("gI", vim.lsp.buf.implementation, "Go to implementation")
    map("gy", vim.lsp.buf.type_definition, "Go to type definition")
    map("K", vim.lsp.buf.hover, "Hover documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
    map("<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
    map("<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_group = vim.api.nvim_create_augroup("mac-dev-setup-lsp-highlight", { clear = false })

      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
      end, "Toggle inlay hints")
    end
  end,
})
