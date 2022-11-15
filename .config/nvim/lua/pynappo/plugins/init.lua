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
    { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' }, config = function() require('pynappo/plugins/gitsigns') end },
    { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' },
    {
      'pwntester/octo.nvim',
      requires = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', 'kyazdani42/nvim-web-devicons', },
      cmd = 'Octo',
      config = function() require("octo").setup() end
    }
  })
  use ({
    { 'catppuccin/nvim', as = 'catppuccin' },
    'Shatur/neovim-ayu'
  })
  use ({
    { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },
    { 'ggandor/leap.nvim', config = function() require('leap').set_default_keymaps() end },
    { 'ggandor/leap-spooky.nvim', config = function() require('leap-spooky').setup() end },
    { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end }
  })
  use ({
    {
      'nvim-telescope/telescope.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function() require('pynappo/plugins/telescope') end,
      cmd = 'Telescope'
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    'nvim-telescope/telescope-file-browser.nvim',
  })
  -- use ({
  --   '~/code/nvim/fzf-lua',
  --   requires = { 'kyazdani42/nvim-web-devicons' },
  --   config = function() require('pynappo/plugins/fzf') end
  -- })
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      local hl_list = {}
      for i, color in pairs({ '#782121', '#6a6a21', '#216631', '#325f5f', '#324b7b', '#563155' }) do
        local name = 'IndentBlanklineIndent' .. i
        vim.api.nvim_set_hl(0, name, { fg = color, nocombine = true })
        table.insert(hl_list, name);
      end
      vim.cmd.highlight('IndentBlanklineContextChar guifg=#999999 gui=bold,nocombine')
      require('indent_blankline').setup {
        show_trailing_blankline_indent = false,
        space_char_blankline = ' ',
        char_highlight_list = hl_list,
        use_treesitter = true,
        use_treesitter_scope = true,
        show_current_context = true,
      }
    end
  }
  use ({
    { 'nvim-treesitter/nvim-treesitter', config = function() require('pynappo/plugins/treesitter') end },
    'nvim-treesitter/nvim-treesitter-textobjects',
    'p00f/nvim-ts-rainbow',
    'windwp/nvim-ts-autotag',
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/playground'
  })
  use ({
    { 'zbirenbaum/copilot.lua', config = require("copilot").setup() },
    {
      'L3MON4D3/LuaSnip',
      config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
      requires = 'rafamadriz/friendly-snippets'
    },
    {
      'hrsh7th/nvim-cmp',
      config = function() require('pynappo/plugins/cmp') end,
      requires = {
        'onsails/lspkind.nvim',
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        'dmitmel/cmp-cmdline-history',
        { "zbirenbaum/copilot-cmp", after = "copilot.lua", config = function() require("copilot_cmp").setup() end },
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-nvim-lsp",
        "f3fora/cmp-spell",
        "octaltree/cmp-look",
        "saadparwaiz1/cmp_luasnip",
        'hrsh7th/cmp-nvim-lsp-signature-help',
        { 'saecki/crates.nvim', event = "BufRead Cargo.toml", requires = 'nvim-lua/plenary.nvim', config = function() require('crates').setup() end },
        { "petertriho/cmp-git", requires = "nvim-lua/plenary.nvim", config = function() require('cmp_git').setup() end},
        'davidsierradz/cmp-conventionalcommits',
      },
    },
    { 'windwp/nvim-autopairs', config = function() require('pynappo/plugins/autopairs') end },
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
    { 'folke/which-key.nvim', config = function() require('which-key').setup({window = {border = "single"}}) end },
    { 'folke/trouble.nvim', requires = 'kyazdani4/nvim-web-devicons', config = function() require('trouble').setup{} end, },
    {
      'folke/todo-comments.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function() require('todo-comments').setup{highlight = {keyword = "fg"}} end
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
  use { 'goolord/alpha-nvim', config = function() require('alpha').setup(require('alpha.themes.startify').config) end }
  use ({
    {'lewis6991/impatient.nvim'},
    { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = function() vim.g.startuptime_tries = 3 end }
  })
  use {
    'andymass/vim-matchup',
    config = function()
      for _, option in pairs({'enabled', 'surround_enabled', 'transmute_enabled', 'matchparen_deferdiag_error'}) do
        vim.g['matchup_' .. option] = 1
      end
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      require('pynappo/keymaps').setup.matchup()
    end,
  }
  use { 'nmac427/guess-indent.nvim', config = function() require('guess-indent').setup{} end, }
  use 'tpope/vim-repeat'
  use { 'Akianonymus/nvim-colorizer.lua', config = function() require('colorizer').setup() end }
  use ({
    { 'simrat39/symbols-outline.nvim', config = function() require('symbols-outline').setup() end },
    { 'ludovicchabant/vim-gutentags', config = function() require('pynappo/plugins/gutentags') end }
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
        require("pynappo/keymaps").setup.incremental_rename()
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
  use { 'nacro90/numb.nvim', config = function() require('numb').setup() end }

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
      require('pynappo/keymaps').setup.hlslens()
    end
  }
  use {
    'nvim-neorg/neorg',
    -- tag = 'latest',
    ft = 'norg',
    after = 'nvim-treesitter', -- You may want to specify Telescope here as well
    config = function() require('neorg').setup {['core.defaults'] = {}} end
  }
  use ({
    {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', 'WhoIsSethDaniel/lualine-lsp-progress.nvim' },
      config = function() require('pynappo/plugins/lualine') end
    },
    { 'rebelot/heirline.nvim', config = function() require('pynappo/plugins/heirline') end },
    { 'SmiteshP/nvim-navic', requires = 'neovim/nvim-lspconfig', config = function() require('pynappo/plugins/navic') end },
    { 'nanozuki/tabby.nvim', config = function() require('pynappo/plugins/tabby') end }
  })
  use { 'AckslD/nvim-neoclip.lua', requires = 'nvim-telescope/telescope.nvim', config = function() require('neoclip').setup() end }
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
  use { 'akinsho/toggleterm.nvim', tag = '*', config = function() require('pynappo/plugins/toggleterm') end }
  use ({
    "mfussenegger/nvim-dap",
    { "rcarriga/nvim-dap-ui", config = function() require("dapui").setup() end },
    { 'theHamsta/nvim-dap-virtual-text', config = function() require("nvim-dap-virtual-text").setup() end },
  })
  use { "monaqa/dial.nvim", config = function() require("pynappo/plugins/dial") end }
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
  use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }
  use 'RRethy/vim-illuminate'
  use { 'AckslD/nvim-FeMaco.lua', config = function() require("femaco").setup() end }
  use (
    { 'levouh/tint.nvim', config = function() require('tint').setup() end },
    { 'nvim-zh/colorful-winsep.nvim', config = function() require('colorful-winsep').setup() end}
  )
  use {
    'xeluxee/competitest.nvim',
    requires = 'MunifTanjim/nui.nvim',
    config = function() require('competitest').setup({runner_ui = {interface = "popup"}}) end
  }
  use {
    'anuvyklack/hydra.nvim',
    config = function() require('pynappo/plugins/hydra') end
  }
  use { 'ggandor/flit.nvim', config = function() require('flit').setup({labeled_modes = 'nvo'}) end }
  use {
    'dstein64/nvim-scrollview',
    config = function() require('scrollview').setup({
      excluded_filetypes = {'neo-tree'},
      winblend = 75,
      base = 'right',
    })
    end
  }
  use 'mrjones2014/smart-splits.nvim'
  if packer_bootstrap then
    require('packer').sync()
  end
end,
  config = {
    max_jobs = 10,
    display = {
      prompt_border = 'single',
    },
  }
})
