vim.g.mapleader = ' ' -- leader is space

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
}
local opts = {}
require('lazy').setup(plugins, opts)
require('catppuccin').setup()
vim.cmd.colorscheme('catppuccin')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.find_files, {}) -- this is for telescope keybinding
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {}) -- this is for live greping space+fg
