-- LazyNvim Setup
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

vim.opt.laststatus = 0
vim.go.laststatus = 0

-- some nice-to-have settings
vim.cmd.colorscheme('habamax')
local o = vim.opt
local g = vim.g
o.smartcase = true
o.cursorline = true
o.vartabstop = '2'
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true
o.timeoutlen = 2000
o.list = true
o.listchars = {
  lead = '.',
  eol = '󱞣',
}
g.mapleader = ' '
o.relativenumber = true
o.number = true
vim.keymap.set('n', '<leader>cc', 'gcc', { remap = true })
vim.on_key(function(...) vim.print({ ... }) end)
require('lazy').setup({
  {
    {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
    },
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
  },
})

vim.opt.laststatus = 0
vim.go.laststatus = 0
