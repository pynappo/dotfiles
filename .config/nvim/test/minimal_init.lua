-- LazyNvim Setup
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
vim.opt.clipboard = 'unnamedplus'
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
require('lazy').setup({
  -- {
  --   'nvim-lualine/lualine.nvim',
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  --   config = function()
  --     require('lualine').setup({
  --       sections = {},
  --       winbar = {},
  --       inactive_winbar = {},
  --       extensions = {},
  --       tabline = {
  --         lualine_a = { 'mode' },
  --         lualine_b = { 'branch', 'diff', 'diagnostics' },
  --         lualine_c = { 'filename' },
  --         lualine_x = { 'encoding', 'fileformat', 'filetype' },
  --         lualine_y = { 'progress' },
  --         lualine_z = { 'location' },
  --       },
  --     })
  --     o.laststatus = 0
  --   end,
  -- },
})

vim.opt.laststatus = 0
vim.go.laststatus = 0
