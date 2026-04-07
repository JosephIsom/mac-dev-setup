-- managed Neovim baseline
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Terminal fonts are configured by Ghostty/iTerm2/WezTerm; Neovim just assumes
-- a Nerd Font is available so icon-capable plugins can render correctly.
vim.g.have_nerd_font = true

require("user.config.options")
require("user.theme").apply()
require("user.config.keymaps")
require("user.config.autocmds")
require("user.config.lsp")
require("user.config.lazy")

pcall(require, "user.local")
