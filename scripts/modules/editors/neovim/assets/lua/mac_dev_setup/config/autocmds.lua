local group = vim.api.nvim_create_augroup("mac-dev-setup", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore cursor to the last known position",
  group = group,
  callback = function(event)
    local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(event.buf)

    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Close transient windows with q",
  group = group,
  pattern = { "help", "man", "qf", "checkhealth", "lspinfo" },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<CR>", {
      buffer = event.buf,
      silent = true,
      desc = "Close window",
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Use prose-friendly settings where appropriate",
  group = group,
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Avoid comment continuation on new lines",
  group = group,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})
