" mac-dev-setup managed Neovim loader (XDG: ~/.config/nvim)

let s:nvim_config = expand('~/.config/nvim')

if isdirectory(s:nvim_config)
  execute 'set runtimepath^=' . fnameescape(s:nvim_config)
endif

if filereadable(expand('~/.config/nvim/plugin/fzf.vim'))
  source ~/.config/nvim/plugin/fzf.vim
endif

if filereadable(expand('~/.config/nvim/plugin/core.vim'))
  source ~/.config/nvim/plugin/core.vim
endif

lua << EOF_LUA
local local_lua = vim.fn.expand("~/.config/nvim/local.lua")
if vim.fn.filereadable(local_lua) == 1 then
  dofile(local_lua)
end
EOF_LUA
