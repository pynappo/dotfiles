-- install lazy.nvim, a plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- some settings
vim.cmd.colorscheme('habamax')
local o = vim.o
o.smartcase = true
o.vartabstop = '2'
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true
o.timeoutlen = 2000

-- setup plugins
require("lazy").setup({
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        diagnostics = {
          enable = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
          show_on_dirs = true,
        },
        view = {
          signcolumn = 'yes'
        }
      })
    end
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
          "lua_ls",
        },
        handlers = {
          function(ls) require('lspconfig')[ls].setup({}) end,
        }
      })
    end,
  },
  {
    'williamboman/mason.nvim',
    opts = { ui = { border = 'single' } }
  },
  { 'numToStr/Comment.nvim', opts = {} },
  {
    'folke/which-key.nvim',
    config = function()
      require('which-key').setup({
        triggers_nowait = {'<c-w>', 'z'},
        triggers = "auto"
      })
    end
  },
})

