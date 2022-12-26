local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)


require('lazy').setup({
  { 'tpope/vim-fugitive' },
  {
    'Shatur/neovim-ayu',
    config = function()
      local colors = require('ayu.colors')
      require("ayu").setup({
        mirage = true,
        overrides = {
          Wildmenu = { bg = colors.bg , fg = colors.markup },
          Comment = { fg = 'gray', italic = true, },
          LineNr = { fg = 'gray' }
        }
      })
    end
  },
  { 'TimUntersberger/neogit', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Octo',
    config = function() require("octo").setup() end
  },
  { 'ludovicchabant/vim-gutentags', config = function() require('pynappo/plugins/gutentags') end },
  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },
  { 'ggandor/leap.nvim', config = function() require('leap').add_default_mappings() end },
  { 'ggandor/leap-spooky.nvim', config = function() require('leap-spooky').setup() end },
  { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end } ,
  { 'nvim-telescope/telescope-fzf-native.nvim', build = "make"},
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    config = function() require('pynappo/plugins/telescope') end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('pynappo/autocmds').create_autocmd('ColorScheme',
        {
          callback = function()
            local hl_list = {}
            for i, color in pairs({ '#782121', '#6a6a21', '#216631', '#325f5f', '#324b7b', '#563155' }) do
              local name = 'IndentBlanklineIndent' .. i
              vim.api.nvim_set_hl(0, name, { fg = color, nocombine = true })
              table.insert(hl_list, name);
            end
            vim.cmd.highlight('IndentBlanklineContextChar guifg=#888888 gui=bold,nocombine')
            require('indent_blankline').setup({
              filetype_exclude = { 'help', 'terminal', 'dashboard', 'packer', 'text' },
              show_trailing_blankline_indent = false,
              space_char_blankline = ' ',
              char_highlight_list = hl_list,
              use_treesitter = true,
              use_treesitter_scope = true,
              show_current_context = true
            })
          end
        }
      )
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('pynappo/plugins/treesitter') end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'p00f/nvim-ts-rainbow',
      'windwp/nvim-ts-autotag',
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/playground',
    }
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({use_default_keymaps = false})
      require('pynappo/keymaps').setup.treesj()
    end
  },
  {
    'L3MON4D3/LuaSnip',
    config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
    dependencies = { 'rafamadriz/friendly-snippets' }
  },
  {
    'hrsh7th/nvim-cmp',
    config = function() require('pynappo/plugins/cmp') end,
    dependencies = {
      'onsails/lspkind.nvim',
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      'dmitmel/cmp-cmdline-history',
      {
        'zbirenbaum/copilot.lua',
        dependencies = {
          {
            "zbirenbaum/copilot-cmp",
            config = function() require("copilot_cmp").setup() end,
          }
        },
        config = function () vim.defer_fn(function() require("copilot").setup() end, 100) end,
      },
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "octaltree/cmp-look",
      "saadparwaiz1/cmp_luasnip",
      'hrsh7th/cmp-nvim-lsp-signature-help',
      { 'saecki/crates.nvim', event = "BufRead Cargo.toml", dependencies = { 'nvim-lua/plenary.nvim' }, config = function() require('crates').setup() end },
      { "petertriho/cmp-git", dependencies = { "nvim-lua/plenary.nvim" }, config = function() require('cmp_git').setup() end},
      'davidsierradz/cmp-conventionalcommits',
    },
  },
  { 'windwp/nvim-autopairs', config = function() require('pynappo/plugins/autopairs') end },
  { 'folke/which-key.nvim', config = function() require('which-key').setup({window = {border = "single"}}) end },
  { 'folke/trouble.nvim', config = function() require('trouble').setup{} end, },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('todo-comments').setup{highlight = {keyword = "fg"}} end
  },
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        cmdline = { enabled = false },
        messages = { enabled = false },
        lsp = {
          progress = {
            enabled = false,
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          }
        },
        views = {
          hover = {
            border = { style = "rounded" },
            position = { row = 2 }
          },
        },
        presets = {
          inc_rename = true,
          long_message_to_split = true,
          lsp_doc_border = true
        }
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      { "rcarriga/nvim-notify", config = function() require("notify").setup({background_colour = '#000000'}) end },
      {
        "smjonas/inc-rename.nvim",
        requirements = {
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
          },
        },
        config = function()
          require("inc_rename").setup { input_buffer_type = "dressing" }
          require("pynappo/keymaps").setup.incremental_rename()
        end
      },
    }
  },
  {
    'goolord/alpha-nvim',
    config = function() require('alpha').setup(require('alpha.themes.startify').config) end,
  },
  { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = function() vim.g.startuptime_tries = 3 end },
  {
    'andymass/vim-matchup',
    init = function()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute = 1
      vim.g.matchup_matchparen_deferred = 1
    end,
  },
  { 'nmac427/guess-indent.nvim', config = function() require('guess-indent').setup{} end, },
  'tpope/vim-repeat',
  {
    'NvChad/nvim-colorizer.lua',
    config = function() require('colorizer').setup({
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = "foreground", -- Set the display mode.
        tailwind = true, -- Enable tailwind colors
      },
    })
    end
  },
  { 'kyazdani42/nvim-web-devicons' },
  { 'simrat39/symbols-outline.nvim', config = function() require('symbols-outline').setup() end },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      {
        's1n7ax/nvim-window-picker',
        config = function()
          require('window-picker').setup({
            fg_color = '#ededed',
            other_win_hl_color = '#226622',
          })
        end
      }
    },
    config = function() require('pynappo/plugins/neo-tree') end
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup {
        open_mapping = require("pynappo/keymaps").toggleterm.open_mapping,
        winbar = {
          enabled = true,
          name_formatter = function(term) return term.name end
        },
        highlights = { StatusLine = { guibg = 'StatusLine' } },
      }
    end
  },
  {
    'karb94/neoscroll.nvim',
    config = function ()
      require("neoscroll").setup({ easing_function = "quadratic"})
      require("neoscroll.config").set_mappings(require("pynappo/keymaps").neoscroll)
    end
  },
  { 'sindrets/diffview.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  'simnalamburt/vim-mundo',
  { 'nacro90/numb.nvim', config = function() require('numb').setup() end },
  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup({
        mapping = {"jk", "kj"},
        keys = function() return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>' end
      })
    end
  },
  { 'nyngwang/murmur.lua', config = function () require('pynappo/plugins/murmur') end },

  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require('hlslens').setup()
      require('pynappo/keymaps').setup.hlslens()
    end
  },
  {
    'nvim-neorg/neorg',
    -- tag = 'latest',
    ft = 'norg',
    after = 'nvim-treesitter', -- You may want to specify Telescope here as well
    config = function() require('neorg').setup {['core.defaults'] = {}} end
  },
  {
    'rebelot/heirline.nvim',
    config = function() require('pynappo/plugins/heirline') end,
    dependencies = {
      {
        'SmiteshP/nvim-navic',
        dependencies = { 'neovim/nvim-lspconfig' },
        config = function() require('pynappo/plugins/navic') end,
      },
      {
        'lewis6991/gitsigns.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require('pynappo/plugins/gitsigns') end,
      },
    }
  },
  { "tiagovla/scope.nvim", config = function() require('scope').setup() end },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'folke/neodev.nvim',
      'mfussenegger/nvim-jdtls',
      'simrat39/rust-tools.nvim',
      'jose-elias-alvarez/null-ls.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim'
    },
    config = function()
      require('mason').setup({ ui = { border = "single" }})
      require('pynappo/plugins/lsp')
    end
  },
  {
    'nvim-neotest/neotest',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter', },
  },
  'rouge8/neotest-rust',
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      { "mfussenegger/nvim-dap" },
      {
        'theHamsta/nvim-dap-virtual-text',
        config = function() require("nvim-dap-virtual-text").setup({commented = true}) end,
      },
    },
    config = function() require('pynappo/plugins/dap') end
  },
  { "monaqa/dial.nvim", config = function() require("pynappo/plugins/dial") end },
  {
    'kosayoda/nvim-lightbulb',
    config = function ()
      require('nvim-lightbulb').setup({
        sign = { enabled = false },
        virtual_text = { enabled = true, text = "💡", hl_mode = "replace", },
      })
    end
  },
  {
    'toppair/peek.nvim',
    build = function() vim.fn.system('deno task --quiet build:fast') end,
    config = function()
      require('peek').setup({
        auto_load = true,         -- whether to automatically load preview when
        -- entering another markdown buffer
        close_on_bdelete = true,  -- close preview window on buffer delete
        syntax = true,            -- enable syntax highlighting, affects performance
        theme = 'dark',           -- 'dark' or 'light'
      })
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end
  },
  { 'glacambre/firenvim', build = function() vim.fn['firenvim#install'](0) end },
  { 'AckslD/nvim-FeMaco.lua', config = function() require("femaco").setup() end },
  {
    'levouh/tint.nvim',
    config = function()
      require('tint').setup({
        window_ignore_function = function(winid)
          local buftype = vim.bo[vim.api.nvim_win_get_buf(winid)].buftype
          local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
          return vim.tbl_contains({'terminal', 'nofile'}, buftype) or floating
        end
      })
    end
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    config = function()
      require('colorful-winsep').setup({ highlight = { fg = "#202521"} })
    end,
  },
  {
    'xeluxee/competitest.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function() require('competitest').setup({runner_ui = {interface = "popup"}}) end
  },
  { 'anuvyklack/hydra.nvim', config = function() require('pynappo/plugins/hydra') end },
  { 'ggandor/flit.nvim', config = function() require('flit').setup({ labeled_modes = 'v' }) end },
  {
    'dstein64/nvim-scrollview',
    config = function() require('scrollview').setup({
      excluded_filetypes = {'neo-tree'},
      winblend = 75,
      base = 'right',
    })
    end
  },
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      require('smart-splits').setup({})
      require('pynappo/keymaps').setup.smart_splits()
    end
  },
  { 'alaviss/nim.nvim' },
  {
    'melkster/modicator.nvim',
    init = function()
      vim.o.number = true
      vim.o.cursorline = true
    end,
    config = function() require('modicator').setup() end,
  },
})
