vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.headless = #vim.api.nvim_list_uis() == 0

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 400
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 6
opt.sidescrolloff = 6
opt.wrap = false
opt.cursorline = true
opt.undofile = true

local keymap = vim.keymap.set

keymap("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
keymap("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
keymap("n", "<leader>e", "<cmd>Ex<cr>", { desc = "File explorer" })
keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight on yank",
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
  },
  filename = {
    ["go.work"] = "gowork",
  },
  pattern = {
    [".*/docker%-compose[^/]*%.ya?ml"] = "yaml.docker-compose",
    [".*/gitlab[^/]*%.ya?ml"] = "yaml.gitlab",
    [".*/helm[^/]*values[^/]*%.ya?ml"] = "yaml.helm-values",
  },
})
