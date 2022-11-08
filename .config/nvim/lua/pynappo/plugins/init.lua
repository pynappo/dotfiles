local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup({function(use)
  use 'wbthomason/packer.nvim'
  use ({
    { 'tpope/vim-fugitive' },
    { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }, config = [[require('pynappo/plugins/gitsigns')]] },
    { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' },
    {
      'pwntester/octo.nvim',
      requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons', },
      config = [[require("octo").setup()]]
    }
  })
  use ({
    { 'catppuccin/nvim', as = 'catppuccin' },
    'Shatur/neovim-ayu'
  })
  use ({
    { 'numToStr/Comment.nvim', config = [[require('Comment').setup()]] },
    { 'ggandor/leap.nvim', config = [[require('leap').set_default_keymaps()]] },
    { 'kylechui/nvim-surround', config = [[require('nvim-surround').setup()]] }
  })
  use ({
    {
      'nvim-telescope/telescope.nvim',
      requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
      config = [[require('pynappo/plugins/telescope')]],
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    'nvim-telescope/telescope-file-browser.nvim',
  })
  use {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufEnter',
    config = function()
      local hl_list = {}
      for i, color in pairs({ '#862121', '#6a6a21', '#216631', '#325f5f', '#324b7b', '#562155' }) do
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
      }
      vim.cmd.highlight('IndentBlanklineContextChar guifg=#999999 gui=bold')
    end
  }
  use ({
    { 'nvim-treesitter/nvim-treesitter', config = [[require('pynappo/plugins/treesitter')]] },
    'nvim-treesitter/nvim-treesitter-textobjects',
    'p00f/nvim-ts-rainbow',
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/playground'
  })
  use ({
    {
      'zbirenbaum/copilot.lua', event = "VimEnter",
      config = function()
        vim.defer_fn(function() require("copilot").setup() end, 100)
      end,
    },
    {
      'L3MON4D3/LuaSnip',
      config = [[require('luasnip.loaders.from_vscode').lazy_load()]],
      requires = 'rafamadriz/friendly-snippets'
    },
    {
      'hrsh7th/nvim-cmp',
      config = [[require('pynappo/plugins/cmp')]],
      requires = {
        'onsails/lspkind.nvim',
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        'dmitmel/cmp-cmdline-history',
        { "zbirenbaum/copilot-cmp", after = "copilot.lua", config = [[require("copilot_cmp").setup()]] },
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-nvim-lsp",
        "f3fora/cmp-spell",
        "octaltree/cmp-look",
        "saadparwaiz1/cmp_luasnip",
        'hrsh7th/cmp-nvim-lsp-signature-help',
        { 'saecki/crates.nvim', event = "BufRead Cargo.toml", requires = 'nvim-lua/plenary.nvim', config = [[require('crates').setup()]] },
        { "petertriho/cmp-git", requires = "nvim-lua/plenary.nvim", config = [[require("cmp_git").setup()]] },
      },
    },
    { 'windwp/nvim-autopairs', config = [[require('pynappo/plugins/autopairs')]] },
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
  use ({
    { 'folke/which-key.nvim', config = [[require('which-key').setup({window = {border = "single"}})]] },
    { 'folke/trouble.nvim', requires = 'kyazdani4/nvim-web-devicons', config = [[require('trouble').setup{}]], },
    {
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = [[require('todo-comments').setup{highlight = {keyword = "fg"}}]]
    },
    {
      "folke/noice.nvim",
      config = function()
        require("notify").setup({background_colour = '#000000'})
        require("noice").setup({
          cmdline = { enabled = false },
          messages = { enabled = false },
          lsp = {
            progress = { enabled = false, },
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
          },
          views = {
            hover = {
              border = { style = "rounded" },
              position = { row = 2 }
            },
          }
        })
      end,
      requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }
    }
  })
  use { 'goolord/alpha-nvim', config = [[require('alpha').setup(require('alpha.themes.startify').config)]] }
  use ({
    {'lewis6991/impatient.nvim'},
    { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 3]] }
  })
  use {
    'andymass/vim-matchup',
    config = function()
      for _, option in pairs({'enabled', 'surround_enabled', 'transmute_enabled', 'matchparen_deferred'}) do
        vim.g['matchup_' .. option] = 1
      end
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      require('pynappo/keymaps').setup('matchup')
    end,
  }
  use { 'nmac427/guess-indent.nvim', config = [[require('guess-indent').setup{}]], }
  use 'tpope/vim-repeat'
  use { 'Akianonymus/nvim-colorizer.lua', config = [[require('colorizer').setup()]] }
  use ({
    'simrat39/symbols-outline.nvim', config = [[require('symbols-outline').setup()]],
    'ludovicchabant/vim-gutentags', config = [[require('pynappo/plugins/gutentags')]]
  })
  use {
    'karb94/neoscroll.nvim',
    config = function ()
      require("neoscroll").setup({ easing_function = "quadratic"})
      require("neoscroll.config").set_mappings(require("pynappo/keymaps").neoscroll)
    end
  }
  use ({
    {
      "smjonas/inc-rename.nvim",
      config = function()
        require("inc_rename").setup { input_buffer_type = "dressing" }
        require("pynappo/keymaps").setup('incremental_rename')
      end,
      requires = "stevearc/dressing.nvim"
    },
    {
      'stevearc/dressing.nvim',
      config = function()
        require("dressing").setup{
          input = {
            override = function(conf)
              conf.col = -1
              conf.row = 0
              return conf
            end,
          },
        }
      end
    }
  })
  use ({
    { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' },
    'simnalamburt/vim-mundo'
  })
  use { 'nacro90/numb.nvim', config = [[require('numb').setup()]] }

  use {
    'max397574/better-escape.nvim', config = function()
      require('better_escape').setup({
        mapping = {"jk", "kj"},
        keys = function () return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>' end
      })
    end
  }
  use {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require('hlslens').setup()
      require('pynappo/keymaps').setup('hlslens')
    end
  }
  -- use { 'j-hui/fidget.nvim', config = [[require("fidget").setup { window = { blend = 0 }}]] }
  use {
    'nvim-neorg/neorg',
    -- tag = 'latest',
    ft = 'norg',
    after = 'nvim-treesitter', -- You may want to specify Telescope here as well
    config = [[require('neorg').setup {['core.defaults'] = {}}]]
  }
  use ({
    {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', 'WhoIsSethDaniel/lualine-lsp-progress.nvim' },
      config = [[require('pynappo/plugins/lualine')]]
    },
    { 'SmiteshP/nvim-navic', requires = 'neovim/nvim-lspconfig', config = [[require('pynappo/plugins/navic')]] },
    { 'nanozuki/tabby.nvim', after = 'lualine.nvim', config = [[require('pynappo/plugins/tabby')]] }
  })
  use { 'AckslD/nvim-neoclip.lua', requires = 'nvim-telescope/telescope.nvim', config = [[require('neoclip').setup()]] }
  use ({
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'folke/neodev.nvim',
    'simrat39/rust-tools.nvim',
    'jose-elias-alvarez/null-ls.nvim',
    {
      'neovim/nvim-lspconfig',
      config = function()
        require('mason').setup({ ui = { border = "single" }})
        require('pynappo/plugins/lsp')
      end
    }
  })
  use ({
    {
      'nvim-neotest/neotest',
      requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter', },
    },
    'rouge8/neotest-rust'
  })
  use { 'akinsho/toggleterm.nvim', tag = '*', config = [[require('pynappo/plugins/toggleterm')]] }
  use ({
    "mfussenegger/nvim-dap",
    { "rcarriga/nvim-dap-ui", config = [[require("dapui").setup()]] },
    { 'theHamsta/nvim-dap-virtual-text', config = [[require("nvim-dap-virtual-text").setup()]] },
  })
  use { "monaqa/dial.nvim", config = [[require("pynappo/plugins/dial")]] }
  use {
    'kosayoda/nvim-lightbulb',
    config = function ()
      require('nvim-lightbulb').setup({
        sign = { enabled = false },
        virtual_text = { enabled = true, text = "💡", hl_mode = "replace", },
      })
    end
  }
  use { 'toppair/peek.nvim', run = 'deno task --quiet build:fast' }
  use { 'echasnovski/mini.nvim', config = [[require('pynappo/plugins/mini')]] }
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

  use { 'AckslD/nvim-FeMaco.lua', config = [[require("femaco").setup()]] }
  -- use { "nvim-zh/colorful-winsep.nvim", config = [[require('colorful-winsep').setup({highlight = { guifg = '#999999'}})]] },
  use { 'levouh/tint.nvim', config = [[require('tint').setup()]] }
  use {
    'xeluxee/competitest.nvim',
    requires = 'MunifTanjim/nui.nvim',
    config = [[require('competitest').setup({runner_ui = {interface = "popup"}})]]
  }
  if packer_bootstrap then
    require('packer').sync()
  end
end,
  config = {
    max_jobs = 12,
    display = {
      prompt_border = 'single',
    },
  }
})

