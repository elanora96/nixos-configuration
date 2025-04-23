---@diagnostic disable: undefined-global
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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.api.nvim_set_option("clipboard", "unnamedplus")

local plugins = require("config.plugins")
require("lazy").setup({
  spec = plugins,
  install = { colorscheme = { "gruvbox-material" } },
  checker = { enabled = false },
})

vim.cmd([[colorscheme gruvbox-material]])
