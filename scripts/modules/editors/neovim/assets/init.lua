-- mac-dev-setup managed Neovim baseline
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Terminal fonts are configured by Ghostty/iTerm2/WezTerm; Neovim just assumes
-- a Nerd Font is available so icon-capable plugins can render correctly.
vim.g.have_nerd_font = true

require("mac_dev_setup.config.options")
require("mac_dev_setup.config.keymaps")
require("mac_dev_setup.config.autocmds")
require("mac_dev_setup.config.lsp")
require("mac_dev_setup.config.lazy")

pcall(require, "mac_dev_setup.local")
