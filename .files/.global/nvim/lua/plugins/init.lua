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
  use { 'Shatur/neovim-ayu', config = [[require('theme')]] }
  use { 'numToStr/Comment.nvim', config = [[require('Comment').setup()]] }
  use 'ludovicchabant/vim-gutentags'
  use({
    { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', config = [[require('telescope').load_extension('fzf')]] },
    {
      'nvim-telescope/telescope-frecency.nvim',
      after = 'telescope.nvim',
      requires = 'tami5/sqlite.lua',
    }
  })
  use { 'nvim-lualine/lualine.nvim',
    config = function() require('lualine').setup {
        options = {
          theme = 'ayu',
          extensions = { 'nvim-tree', 'fugitive' },
          section_separators = '',
          component_separators = ''
        }
      }
    end
  }
  use { 'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    config = function()
      for i, color in pairs({ '#662121', '#666021', '#216631', '#224a5e', '#223b6b', '#662165' }) do
        vim.api.nvim_set_hl(0, 'IndentBlanklineIndent' .. i, { fg = color })
      end
      require('indent_blankline').setup {
        show_trailing_blankline_indent = false,
        space_char_blankline = " ",
        char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
          "IndentBlanklineIndent3",
          "IndentBlanklineIndent4",
          "IndentBlanklineIndent5",
          "IndentBlanklineIndent6",
        }
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
      config = [[require('plugins/treesitter')]],
    },
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'p00f/nvim-ts-rainbow' }
  })
  use({
    "williamboman/nvim-lsp-installer",
    {
      "neovim/nvim-lspconfig",
      config = function()
        require('nvim-lsp-installer').setup {}
        require('plugins/lsp')
      end
    }
  })
  use({
    {
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
      },
      config = [[require('plugins/cmp')]]
    },
    { 'L3MON4D3/LuaSnip' }
  })
  use { 'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview' }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = [[require('nvim-tree').setup {}]],
    cmd = 'NvimTreeToggle'
  }
  use { "folke/which-key.nvim", config = [[require('which-key').setup {} ]], cmd = 'WhichKey' }
  use { 'goolord/alpha-nvim', config = [[require('alpha').setup(require('alpha.themes.startify').config)]] }
  use 'lewis6991/impatient.nvim'
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 3]] }
  use 'andymass/vim-matchup'
  use {
    'nmac427/guess-indent.nvim',
    config = [[require('guess-indent').setup{}]],
  }
  use {
    'wfxr/minimap.vim',
    config = function()
      vim.g.minimap_width = 10
      vim.g.minimap_highlight_range = 1
      vim.g.minimap_git_colors = 1
      vim.g.minimap_block_filetypes = { 'fugitive', 'nerdtree', 'tagbar', 'fzf', 'nvimtree' }
      vim.g.minimap_highlight_search = 1
    end,
    cmd = 'MinimapToggle'
  }
  use {
    'ggandor/leap.nvim',
    config = [[require('leap').set_default_keymaps()]]
  }
  use 'tpope/vim-repeat'
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require("trouble").setup{}]],
    cmd = 'TroubleToggle'
  }
  use {
    'norcalli/nvim-colorizer.lua',
    cmd = "ColorizerToggle",
    config = [[require('colorizer').setup()]]
  }
  use {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
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
