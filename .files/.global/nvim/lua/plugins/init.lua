local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', { command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' })

require('packer').startup({ function(use)
  use 'wbthomason/packer.nvim'
  use { 'tpope/vim-fugitive', cmd = { 'Git', 'Gstatus', 'Gblame', 'Gpush', 'Gpull' } }
  use { 'Shatur/neovim-ayu', config = function() require('theme') end }
  use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }
  use 'ludovicchabant/vim-gutentags'
  use({
    { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', config = [[require('telescope').load_extension('fzf')]] }
  })
  use { 'nvim-lualine/lualine.nvim',
    config = function() require('lualine').setup {
        options = {
          theme = 'ayu',
          extensions = { 'nvim-tree' },
          section_separators = ''
        }
      }
    end
  }
  use { 'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    config = function() require('indent_blankline').setup {
        char = '┊',
        show_trailing_blankline_indent = false,
      }
    end
  }
  use { 'lewis6991/gitsigns.nvim',

    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        }
      }
    end
  }
  use({
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function() require('plugins/treesitter') end,
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'p00f/nvim-ts-rainbow' }
  })
  use({
    "williamboman/nvim-lsp-installer",
    {
      "neovim/nvim-lspconfig",
      config = function()
        require("nvim-lsp-installer").setup {}
        require('plugins/lsp')
      end
    }
  })
  use({
    { 'hrsh7th/nvim-cmp', config = [[require('plugins/cmp')]] },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'L3MON4D3/LuaSnip' }
  })
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = [[require('nvim-tree').setup {}]]
  }
  use { "folke/which-key.nvim", config = [[require('which-key').setup {} ]] }
  use { 'goolord/alpha-nvim', config = [[require('alpha').setup(require 'alpha.themes.dashboard'.config)]] }
  use 'lewis6991/impatient.nvim'
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 10]] }
  use 'andymass/vim-matchup'
  use 'Darazaki/indent-o-matic'
  use { 'wfxr/minimap.vim', config = function()
    vim.g.minimap_auto_start = 1
    vim.g.minimap_width = 10
    vim.g.minimap_highlight_range = 1
  end
  }
  if packer_bootstrap then
    require('packer').sync()
  end
end,
config = {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
} })
