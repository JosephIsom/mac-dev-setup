local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write buffer" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

map("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window" })

map("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize window shorter" })
map("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize window taller" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize window narrower" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize window wider" })

map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>ld", vim.diagnostic.setloclist, { desc = "Diagnostics list" })
