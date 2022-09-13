local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.glob(install_path) == '' then
  Packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end
require('packer').startup({ function(use)
  use 'wbthomason/packer.nvim'
  use {
    { 'tpope/vim-fugitive' },
    {
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = [[require('pynappo/plugins/gitsigns')]]
    },
    { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }
  }
  use { 'ludovicchabant/vim-gutentags' }
  use { 'catppuccin/nvim', as = 'catppuccin' }
  use { 'Shatur/neovim-ayu' }
  use { 'numToStr/Comment.nvim', config = [[require('Comment').setup()]] }
  use ({
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-ui-select.nvim' }
      },
      config = [[require('pynappo/plugins/telescope')]]
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    {
      'nvim-telescope/telescope-frecency.nvim',
      after = 'telescope.nvim',
      requires = 'tami5/sqlite.lua',
    },
  })
  use { 'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    config = function()
      local hl_list = {}
      for i, color in pairs({ '#662121', '#767621', '#216631', '#325a5e', '#324b7b', '#562155' }) do
        local name = 'IndentBlanklineIndent' .. i
        vim.api.nvim_set_hl(0, name, { fg = color })
        table.insert(hl_list, name);
      end
      require('indent_blankline').setup {
        show_trailing_blankline_indent = false,
        space_char_blankline = ' ',
        char_highlight_list = hl_list
      }
    end
  }
  use ({
    {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = [[require('pynappo/plugins/treesitter')]]
    },
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-telescope/telescope-file-browser.nvim',
    'p00f/nvim-ts-rainbow',
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/nvim-treesitter-context'
  })
  use ({
    {
      'hrsh7th/nvim-cmp',
      config = [[require('pynappo/plugins/cmp')]]
    },
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp-signature-help',
    'onsails/lspkind.nvim',
    'dmitmel/cmp-cmdline-history',
    -- 'github/copilot.vim',
    {
      'zbirenbaum/copilot.lua',
      event = 'InsertEnter',
      config = [[require('copilot').setup()]]
    },
    { 'zbirenbaum/copilot-cmp', module = 'copilot_cmp' },
    {
      'L3MON4D3/LuaSnip',
      config = [[require('luasnip.loaders.from_vscode').lazy_load()]],
      requires = { 'rafamadriz/friendly-snippets' }
    },
    {
      'windwp/nvim-autopairs',
      requires = 'hrsh7th/nvim-cmp',
      config = [[require('pynappo/plugins/autopairs')]]
    }
  })
  use {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
      { 's1n7ax/nvim-window-picker', tag = "v1.*" }
    },
    config = [[require('pynappo/plugins/neo-tree')]]
  }
  use { 'folke/which-key.nvim', config = [[require('which-key').setup {} ]] }
  use { 'goolord/alpha-nvim', config = [[require('alpha').setup(require('alpha.themes.startify').config)]] }
  use 'lewis6991/impatient.nvim'
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 3]] }
  use 'andymass/vim-matchup'
  use { 'nmac427/guess-indent.nvim', config = [[require('guess-indent').setup{}]], }
  use { 'ggandor/leap.nvim', config = [[require('leap').set_default_keymaps()]] }
  use 'tpope/vim-repeat'
  use {
    'folke/trouble.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('trouble').setup{}]],
  }
  use 'andweeb/presence.nvim'
  use 'Djancyp/cheat-sheet'
  use { 'karb94/neoscroll.nvim', config = [[require('pynappo/plugins/neoscroll')]] }
  use 'stevearc/dressing.nvim'
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'nacro90/numb.nvim', config = [[require('numb').setup()]] }
  use { 'kylechui/nvim-surround', config = [[require('nvim-surround').setup()]] }
  use { 'glacambre/firenvim', run = [[vim.fn['firenvim#install'](0)]] }
  use {
    'akinsho/bufferline.nvim',
    tag = 'v2.*',
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('pynappo/plugins/bufferline')]]
  }
  use { 'max397574/better-escape.nvim', config = [[require('better_escape').setup({mapping = {"jk", "kj"}})]] }
  use { 'kevinhwang91/nvim-hlslens', config = [[require('pynappo/plugins/hlslens')]] }
  use {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup({ background_colour = '#000000' })
      vim.notify = require('notify')
    end
  }
  use { 'SmiteshP/nvim-navic', requires = 'neovim/nvim-lspconfig' }
  use {
    'nvim-neorg/neorg',
    -- tag = 'latest',
    ft = 'norg',
    after = 'nvim-treesitter', -- You may want to specify Telescope here as well
    config = [[require('neorg').setup {['core.defaults'] = {}}]]
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = [[require('pynappo/plugins/lualine')]]
  }
  use {
    'AckslD/nvim-neoclip.lua',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = [[require('neoclip').setup()]]
  }
  use ({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'folke/lua-dev.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    {
      'neovim/nvim-lspconfig',
      config = function()
        require('mason').setup()
        require('pynappo/plugins/lsp')
      end
    }
  })
  use { 'levouh/tint.nvim', config = [[require('tint').setup()]] }
  use ({
    {
      'nvim-neotest/neotest',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'antoinemadec/FixCursorHold.nvim',
      },
    },
    'rouge8/neotest-rust'
  })
  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = [[require('todo-comments').setup({})]]
  }
  use { 'Akianonymus/nvim-colorizer.lua', config = [[require('colorizer').setup()]] }
  use { 'simrat39/symbols-outline.nvim', config = [[require('symbols-outline').setup()]] }
  use {
    'akinsho/toggleterm.nvim',
    tag = '*',
    config = function()
      require("toggleterm").setup()
    end
  }
  use ({
    {
      "rcarriga/nvim-dap-ui",
      requires = {"mfussenegger/nvim-dap"},
      config = [[require("dapui").setup()]]
    },
    {
      "mfussenegger/nvim-dap",
    },
    {
      'theHamsta/nvim-dap-virtual-text',
      requires = {"mfussenegger/nvim-dap"},
      config = [[require("nvim-dap-virtual-text").setup()]]
    }
  })
end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})
if Packer_bootstrap then
  require('packer').sync()
end
