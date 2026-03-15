-- Install lazy.nvim Plugin Manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazyrepo = "https://github.com/folke/lazy.nvim.git"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    lazyrepo,
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Movement Bindings
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Misc Bindings
vim.keymap.set("n", "<Leader>n", ":noh<CR>")

-- Reverse Splitting because I'm quirky
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Clipboard setup
vim.api.nvim_set_option("clipboard", "unnamedplus")

-- Source plugins
local plugins = require("config.plugins")
require("lazy").setup({
  spec = plugins,
  install = { colorscheme = { "gruvbox-material" } },
  checker = { enabled = false },
})

-- Plugin Bindings
vim.keymap.set("n", "<Leader>o", ":Oil<CR>")
vim.keymap.set("n", "<Leader>t", ":CommandTRipgrep<CR>")

vim.cmd([[colorscheme gruvbox-material]])

