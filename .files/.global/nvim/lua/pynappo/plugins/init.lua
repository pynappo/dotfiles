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
      requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
      config = [[require('pynappo/plugins/telescope')]],
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    { 'nvim-telescope/telescope-frecency.nvim', after = 'telescope.nvim', requires = 'tami5/sqlite.lua' },
    'nvim-telescope/telescope-file-browser.nvim',
  })
  use { 'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    requires = 'nvim-treesitter/nvim-treesitter',
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
        char_highlight_list = hl_list,
        use_treesitter = true,
        use_treesitter_scope = true,
        show_current_context = true,
        show_current_context_start = true,
      }
    end
  }
  use ({
    { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = [[require('pynappo/plugins/treesitter')]] },
    'nvim-treesitter/nvim-treesitter-textobjects',
    'p00f/nvim-ts-rainbow',
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/nvim-treesitter-context'
  })
  use ({
    { 'zbirenbaum/copilot.lua', event = 'InsertEnter', config = [[require('copilot').setup()]] },
    {
      'L3MON4D3/LuaSnip',
      config = [[require('luasnip.loaders.from_vscode').lazy_load()]],
      event = { 'InsertEnter', 'CmdlineEnter' },
      requires = { 'rafamadriz/friendly-snippets', event = 'InsertEnter' }
    },
    {
      'hrsh7th/nvim-cmp',
      config = [[require('pynappo/plugins/cmp')]],
      after = 'LuaSnip',
      requires = {
        { 'onsails/lspkind.nvim'},
        { "hrsh7th/cmp-buffer", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-calc", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-path", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-cmdline", after = "nvim-cmp", opt = true },
        { 'dmitmel/cmp-cmdline-history', after = "nvim-cmp" },
        { 'zbirenbaum/copilot-cmp', module = 'copilot_cmp', opt = true },
        { "hrsh7th/cmp-emoji", after = "nvim-cmp", opt = true },
        { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", opt = true },
        { "f3fora/cmp-spell", after = "nvim-cmp", opt = true },
        { "octaltree/cmp-look", after = "nvim-cmp", opt = true },
        { "saadparwaiz1/cmp_luasnip", after = { "nvim-cmp", "LuaSnip" } },
        { 'hrsh7th/cmp-nvim-lsp-signature-help', after = "nvim-cmp"},
        {
          'saecki/crates.nvim',
          after = 'nvim-cmp',
          event = "BufRead Cargo.toml",
          requires = 'nvim-lua/plenary.nvim',
          config = [[require('crates').setup()]]
        },
        { "petertriho/cmp-git", after = "nvim-cmp", requires = "nvim-lua/plenary.nvim", config = [[require("cmp_git").setup()]] },
      },
    },
    { 'windwp/nvim-autopairs', after = 'nvim-cmp', config = [[require('pynappo/plugins/autopairs')]]},
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
    config = function()
      require('window-picker').setup()
      require('pynappo/plugins/neo-tree')
    end
  }
  use { 'folke/which-key.nvim', config = [[require('which-key').setup {} ]] }
  use { 'goolord/alpha-nvim', config = [[require('alpha').setup(require('alpha.themes.startify').config)]] }
  use 'lewis6991/impatient.nvim'
  use { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 3]] }
  use {
    'andymass/vim-matchup',
    opt = true,
    event = { "CursorHold", "CursorHoldI" },
    cmd = { "MatchupWhereAmI?" },
    config = function()
      vim.g.matchup_enabled = 1
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute_enabled = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      require('pynappo/keymaps').setup('matchup')
    end,
  }
  use { 'nmac427/guess-indent.nvim', config = [[require('guess-indent').setup{}]], }
  use { 'ggandor/leap.nvim', config = [[require('leap').set_default_keymaps()]] }
  use 'tpope/vim-repeat'
  use {
    'folke/trouble.nvim',
    cmd = {'Trouble', 'TroubleEnter'},
    requires = 'kyazdani42/nvim-web-devicons',
    config = [[require('trouble').setup{}]],
  }
  use {
    'karb94/neoscroll.nvim',
    config = function ()
      require("neoscroll").setup({ easing_function = "quadratic"})
      require("neoscroll.config").set_mappings(require("pynappo/keymaps").neoscroll)
    end
  }
  use {
    'stevearc/dressing.nvim',
    config = require("dressing").setup{
      input = {
        override = function(conf)
          conf.col = -1
          conf.row = 0
          return conf
        end,
      },
    }
  }
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
  use { 'max397574/better-escape.nvim', config = function()
    require('better_escape').setup({
      mapping = {"jk", "kj"},
      keys = function ()
        return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
      end
    })
  end }
  use {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup({ background_colour = '#000000' })
      vim.notify = require('notify')
    end
  }
  use {
    "kevinhwang91/nvim-hlslens",
    config = [[require('pynappo/keymaps').setup('hlslens')]]
  }
  -- use({
  --   "folke/noice.nvim",
  --   event = "VimEnter",
  --   config = function()
  --     require("noice").setup({
  --       cmdline = { view = "cmdline", },
  --       popupmenu = {
  --         enabled = false,
  --       }
  --     })
  --   end,
  --   requires = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     "rcarriga/nvim-notify",
  --     "hrsh7th/nvim-cmp",
  --   }
  -- })
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
  use { 'j-hui/fidget.nvim', config = [[require("fidget").setup { window = { blend = 0 }}]] }
  use { 'levouh/tint.nvim', config = [[require('tint').setup()]] }
  use ({
    {
      'nvim-neotest/neotest',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
      },
    },
    'rouge8/neotest-rust'
  })
  use { 'folke/todo-comments.nvim', requires = 'nvim-lua/plenary.nvim', config = [[require('todo-comments').setup({})]] }
  use { 'Akianonymus/nvim-colorizer.lua', config = [[require('colorizer').setup()]] }
  use { 'simrat39/symbols-outline.nvim', config = [[require('symbols-outline').setup()]] }
  use { 'akinsho/toggleterm.nvim', tag = '*', config = [[require('pynappo/plugins/toggleterm')]] }
  use ({
    "mfussenegger/nvim-dap",
    {
      "rcarriga/nvim-dap-ui",
      requires = {"mfussenegger/nvim-dap"},
      config = [[require("dapui").setup()]]
    },
    {
      'theHamsta/nvim-dap-virtual-text',
      requires = {"mfussenegger/nvim-dap"},
      config = [[require("nvim-dap-virtual-text").setup()]]
    },
  })
  use {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup { input_buffer_type = "dressing" }
      require("pynappo/keymaps").setup('incremental_rename')
    end
  }
  use { "monaqa/dial.nvim", config = [[require("pynappo/plugins/dial")]] }
  use {
    'kosayoda/nvim-lightbulb',
    config = function ()
      require('nvim-lightbulb').setup({
        sign = { enabled = false },
        virtual_text = {
          enabled = true,
          text = "💡",
          hl_mode = "replace",
        },
      })
    end
  }
end,
  config = {
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
})
