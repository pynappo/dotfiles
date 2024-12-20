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
  {
    'williamboman/mason.nvim',
    opts = {
      ui = { border = 'single' },
      PATH = 'append',
    },
    config = function(_, opts) require('mason').setup(opts) end,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- { 'folke/neodev.nvim', config = true },
      'mfussenegger/nvim-jdtls',
      'mrcjkb/rustaceanvim',
      'nvimtools/none-ls.nvim',
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
      },
      {
        'yioneko/nvim-vtsls',
      },
      {
        'mrcjkb/haskell-tools.nvim',
        version = '^3', -- Recommended
        lazy = false, -- This plugin is already lazy
      },
      {
        'https://git.sr.ht/~p00f/clangd_extensions.nvim',
      },
    },
    config = function()
      local lspconfig = require('lspconfig')
      require('lspconfig.configs').vtsls = require('vtsls').lspconfig
      local handlers = {
        function(ls) lspconfig[ls].setup(require('pynappo/lsp/configs')[ls]) end,
        rust_analyzer = function() end, -- use rustaceanvim
        jdtls = function() end, -- use nvim-jdtls
        hls = function() end, -- use haskell-tools
      }
      -- if vim.fn.executable('ccls') == 1 then
      --   handlers.clangd = function() end
      --   require('lspconfig').ccls.setup({})
      -- end
      require('mason-lspconfig').setup({
        ensure_installed = {
          'clangd',
          'lua_ls',
          'rust_analyzer',
          'marksman',
          'jdtls',
          'powershell_es',
          'ltex',
          'clangd',
        },
        handlers = handlers,
      })
      require('lspconfig').gdscript.setup(require('pynappo/lsp/configs').gdscript)
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.gitrebase,
          null_ls.builtins.hover.dictionary,
          null_ls.builtins.hover.printenv,
        },
      })
    end,
  },
  {
    'saghen/blink.cmp',
    opts = {
      keymap = {
        preset = 'super-tab',
      },
      -- readme also notes: 'you may want to set `completion.trigger.show_in_snippet = false`
      -- or use `completion.list.selection = "manual" | "auto_insert"`'
      completion = {
        list = {
          selection = 'auto_insert',
        },
      },
    },
  },
})
