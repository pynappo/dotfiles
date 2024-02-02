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
  'easymotion/vim-easymotion',
  -- {
  --   'hrsh7th/nvim-cmp',
  --   event = 'InsertEnter',
  --   dependencies = {
  --     'L3MON4D3/LuaSnip', -- snippet engine
  --     'onsails/lspkind.nvim', -- vs-code like pictograms
  --     'hrsh7th/cmp-nvim-lsp',
  --   },
  --   config = function()
  --     local cmp = require('cmp')
  --     local luasnip = require('luasnip')
  --     local lspkind = require('lspkind')
  --
  --     -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
  --     require('luasnip.loaders.from_vscode').lazy_load()
  --
  --     cmp.setup({
  --       completion = {
  --         completeopt = vim.o.completeopt,
  --       },
  --       snippet = { -- configure how nvim-cmp interacts with snippet engine
  --         expand = function(args) luasnip.lsp_expand(args.body) end,
  --       },
  --       mapping = cmp.mapping.preset.insert({
  --         ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
  --         ['<C-e>'] = cmp.mapping.abort(), -- close completion window
  --         ['<CR>'] = cmp.mapping.confirm({ select = false }),
  --       }),
  --       sources = cmp.config.sources({
  --         { name = 'nvim_lsp' },
  --       }),
  --       formatting = {
  --         format = lspkind.cmp_format({
  --           maxwidth = 50,
  --           ellipsis_char = '...',
  --         }),
  --       },
  --     })
  --   end,
  -- },
  -- {
  --   'nvim-treesitter/nvim-treesitter',
  --   'neovim/nvim-lspconfig',
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
