-- install lazy.nvim, a plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
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

-- some nice-to-have settings
vim.cmd.colorscheme('habamax')
local o = vim.o
local opt = vim.opt
o.smartcase = true
o.vartabstop = '2'
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true
o.timeoutlen = 2000
o.list = true
opt.listchars = {
  lead = '.',
  eol = '󱞣',
}
vim.g.mapleader = ' '
vim.opt.relativenumber = true
vim.opt.number = true
-- setup plugins
require('lazy').setup({
  {
    'nvim-lualine/lualine.nvim',
  },
  config = 'asdf',
  MAIN = 'hi',
  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   event = { 'BufNewFile', 'BufReadPost' },
  --   build = function()
  --     if not vim.env.GIT_WORK_TREE then vim.cmd('TSUpdate') end
  --   end,
  --   cmd = 'TSUpdate',
  --   config = function()
  --     require('nvim-treesitter.configs').setup({
  --       auto_install = true,
  --       ensure_installed = {
  --         'lua',
  --         'astro',
  --         'typescript',
  --         'javascript',
  --         'tsx',
  --         'html',
  --       },
  --       highlight = {
  --         enable = true,
  --       },
  --       textsubjects = {
  --         enable = true,
  --       },
  --       indent = {
  --         enable = true,
  --       },
  --     })
  --   end,
  -- },
})
