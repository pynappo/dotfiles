-- install lazy.nvim, a plugin manager
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

-- some settings
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
  eol = '󱞣'
}

-- setup plugins
vim.keymap.set('n', '<leader>h', function() vim.print('hi') end)
require('lazy').setup({
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        diagnostics = {
          enable = true,
          icons = {
            hint = '',
            info = '',
            warning = '',
            error = '',
          },
          show_on_dirs = true,
        },
        view = {
          signcolumn = 'yes',
        },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      },
    },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
        },
        handlers = {
          function(ls) require('lspconfig')[ls].setup({}) end,
        },
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = { ui = { border = 'single' } },
  },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufNewFile', 'BufReadPre' },
    config = function()
      local colors = {
        { 'Red', '#3b2727' },
        { 'Yellow', '#464431' },
        { 'Green', '#31493a' },
        { 'Blue', '#273b4b' },
        { 'Indigo', '#303053' },
        { 'Violet', '#403040' },
      }
      require('ibl').setup({
        exclude = {
          filetypes = { 'help', 'terminal', 'dashboard', 'packer', 'text' },
        },
        indent = {
          highlight = require('pynappo.theme').set_rainbow_colors('IndentBlanklineLevel', colors),
        },
        scope = {
          enabled = false,
          show_start = true,
        },
      })
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
})
