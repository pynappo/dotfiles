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
 {'edluffy/specs.nvim', config = function() require('specs').setup{ 
    show_jumps  = true,
    min_jump = 30,
    popup = {
        delay_ms = 0, -- delay before popup displays
        inc_ms = 10, -- time increments used for fade/resize effects 
        blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
        width = 10,
        winhl = "PMenu",
        fader = require('specs').linear_fader,
        resizer = require('specs').shrink_resizer
    },
    ignore_filetypes = {},
    ignore_buftypes = {
        nofile = true,
    },
}end}
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
