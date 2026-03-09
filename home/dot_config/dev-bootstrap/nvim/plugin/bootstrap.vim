" dev-bootstrap managed Neovim loader

let s:dev_bootstrap_root = expand('~/.config/dev-bootstrap/nvim')

if isdirectory(s:dev_bootstrap_root)
  execute 'set runtimepath^=' . fnameescape(s:dev_bootstrap_root)
endif

if filereadable(expand('~/.config/dev-bootstrap/nvim/plugin/fzf.vim'))
  source ~/.config/dev-bootstrap/nvim/plugin/fzf.vim
endif

if filereadable(expand('~/.config/dev-bootstrap/nvim/plugin/core.vim'))
  source ~/.config/dev-bootstrap/nvim/plugin/core.vim
endif

lua << EOF_LUA
local local_lua = vim.fn.expand("~/.config/dev-bootstrap/nvim/local.lua")
if vim.fn.filereadable(local_lua) == 1 then
  dofile(local_lua)
end
EOF_LUA
