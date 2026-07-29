vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Line movement
map("n", "<A-Up>", ":m .-2<CR>==", opts)
map("n", "<A-Down>", ":m .+1<CR>==", opts)
map("x", "<A-Up>", ":m '<-2<CR>gv=gv", opts)
map("x", "<A-Down>", ":m '>+1<CR>gv=gv", opts)

-- Clear search highlights
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Buffer navigation
map("n", "<leader><Tab>", ":bnext<CR>", opts)
map("n", "<leader><S-Tab>", ":bprevious<CR>", opts)
map("n", "<leader>q", ":q<CR>", opts)
map("n", "<leader>Q", ":qa<CR>", opts)
map("n", "<leader>w", ":bd<CR>", opts)
