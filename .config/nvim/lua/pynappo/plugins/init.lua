local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

local keymaps = require('pynappo/keymaps')
local lazy_opts = {
  git = {
    -- defaults for the `Lazy log` command
    -- log = { "-10" }, -- show the last 10 commits
    log = { '--since=3 days ago' }, -- show commits from the last 3 days
    timeout = 90, -- seconds
    url_format = 'https://github.com/%s.git',
  },
  dev = {
    -- directory where you store your local plugin projects
    path = '~/code/nvim',
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {}, -- For example {"folke"}
  },
  install = {
    -- install missing plugins on startup. This doesn't increase startup time.
    missing = true,
    -- try to load one of these colorschemes when starting an installation during startup
    colorscheme = { 'habamax' },
  },
  ui = {
    size = { width = 0.8, height = 0.8 },
    border = 'none',
    icons = {
      loaded = '●',
      not_loaded = '○',
      cmd = ' ',
      config = '',
      event = '',
      ft = ' ',
      init = ' ',
      keys = ' ',
      plugin = ' ',
      runtime = ' ',
      source = ' ',
      start = '',
      task = '✔ ',
      lazy = '鈴 ',
      list = {
        '●',
        '➜',
        '★',
        '‒',
      },
    },
    custom_keys = {
      -- you can define custom key maps here.
      -- To disable one of the defaults, set it to false

      -- open lazygit log
      ['<localleader>l'] = function(plugin)
        require('lazy.util').open_cmd({ 'lazygit', 'log' }, {
          cwd = plugin.dir,
          terminal = true,
          close_on_exit = true,
          enter = true,
        })
      end,

      -- open a terminal for the plugin dir
      ['<localleader>t'] = function(plugin)
        require('lazy.util').open_cmd({ vim.go.shell }, {
          cwd = plugin.dir,
          terminal = true,
          close_on_exit = true,
          enter = true,
        })
      end,
    },
  },
  diff = { cmd = 'diffview.nvim' },
  checker = {
    -- automatically check for plugin updates
    enabled = false,
    concurrency = nil, ---@type number? set to 1 to check for updates very slowly
    notify = true, -- get a notification when new updates are found
    frequency = 3600, -- check for updates every hour
  },
  change_detection = {
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
  performance = {
    cache = {
      enabled = true,
      path = vim.fn.stdpath('cache') .. '/lazy/cache',
      disable_events = { 'VimEnter', 'BufReadPre' },
      ttl = 3600 * 24 * 5, -- keep unused modules for up to 5 days
    },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
      ---@type string[]
      paths = {}, -- add any custom paths here that you want to incluce in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        "matchit",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "gzip",
        "zip",
        "zipPlugin",
        "tar",
        "tarPlugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        -- "2html_plugin",
        "logipat",
        "rrhelper",
        "matchparen"
      },
    },
  },
  readme = {
    root = vim.fn.stdpath('state') .. '/lazy/readme',
    files = { 'README.md' },
    -- only generate markdown helptags for plugins that dont have docs
    skip_if_doc_exists = true,
  },
}

require('lazy').setup({
  'tpope/vim-fugitive',
  {
    'Shatur/neovim-ayu',
    priority = 100,
    config = function()
      local colors = require('ayu.colors')
      local mirage = true
      colors.generate(mirage)
      vim.pretty_print(colors)
      require('ayu').setup({
        mirage = mirage,
        overrides = {
          Wildmenu = { bg = colors.bg, fg = colors.markup },
          Comment = { fg = colors.fg_idle, italic = true },
          Search = { bg = '', underline = true },
          LineNr = { fg = colors.fg_idle },
        },
      })
    end,
  },
  { 'folke/tokyonight.nvim' },
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Octo',
    config = function() require('octo').setup() end,
  },
  {
    'ludovicchabant/vim-gutentags',
    cond = false,
    init = function() vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/nvim/ctags/') end,
    config = function() vim.api.nvim_create_user_command('GutentagsClearCache', function() vim.fn.system('rm', vim.g.gutentags_cache_dir .. '/*') end, {}) end,
  },
  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },
  {
    'ggandor/leap.nvim',
    dependencies = {
      { 'ggandor/leap-spooky.nvim', config = function() require('leap-spooky').setup() end },
      { 'ggandor/flit.nvim', config = function() require('flit').setup({ labeled_modes = 'v' }) end },
    },
    config = function() require('leap').add_default_mappings() end,
  },
  { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end },
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'debugloop/telescope-undo.nvim',
      'nvim-telescope/telescope-ui-select.nvim'
    },
    init = function()
      vim.api.nvim_create_autocmd('BufEnter', {
        group = vim.api.nvim_create_augroup('telescope-file-browser.nvim', { clear = true }),
        pattern = '*',
        callback = function()
          vim.schedule(function()
            local netrw_bufname, _
            if vim.bo[0].filetype == 'netrw' then return end
            local bufname = vim.api.nvim_buf_get_name(0)
            if vim.fn.isdirectory(bufname) == 0 then
              _, netrw_bufname = pcall(vim.fn.expand, '#:p:h')
              return
            end

            -- prevents reopening of file-browser if exiting without selecting a file
            if netrw_bufname == bufname then
              netrw_bufname = nil
              return
            else
              netrw_bufname = bufname
            end
            vim.bo[0].bufhidden = 'wipe'
            require('telescope').extensions.file_browser.file_browser({
              cwd = vim.fn.expand('%:p:h'),
            })
          end)
        end,
        once = true,
        desc = 'lazy-loaded telescope-file-browser.nvimw',
      })
    end,
    config = function() require('pynappo/plugins/telescope') end,
    keys = keymaps.setup.telescope({ lazy = true }),
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    config = function()
      require('pynappo/autocmds').create('ColorScheme', {
        callback = function()
          local hl_list = {}
          for i, color in pairs({ '#4b2121', '#464421', '#21492a', '#284043', '#223b4b', '#463145' }) do
            local name = 'IndentBlanklineIndent' .. i
            vim.api.nvim_set_hl(0, name, { fg = color, nocombine = true })
            table.insert(hl_list, name)
          end
          vim.cmd.highlight('IndentBlanklineContextChar guifg=#777777 gui=bold,nocombine')
          require('indent_blankline').setup({
            filetype_exclude = { 'help', 'terminal', 'dashboard', 'packer', 'text' },
            show_trailing_blankline_indent = false,
            space_char_blankline = ' ',
            char_highlight_list = hl_list,
            use_treesitter = true,
            use_treesitter_scope = true,
            show_current_context = true,
          })
        end,
        desc = 'Persist rainbow indent lines across colorschemes'
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'BufReadPost',
    config = function() require('pynappo/plugins/treesitter') end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function() require('treesitter-context').setup({ min_window_height = 30 }) end,
      },
      'nvim-treesitter/playground',
      'RRethy/nvim-treesitter-textsubjects',
    },
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = "TSJToggle",
    config = function() require('treesj').setup({ use_default_keymaps = false }) end,
    keys = keymaps.setup.treesj({ lazy = true }),
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function() require('pynappo/plugins/cmp') end,
    dependencies = {
      'onsails/lspkind.nvim',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-nvim-lsp',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'octaltree/cmp-look',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'davidsierradz/cmp-conventionalcommits',
      {
        'L3MON4D3/LuaSnip',
        config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
        dependencies = {
          'rafamadriz/friendly-snippets',
          'saadparwaiz1/cmp_luasnip',
        },
      },
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    event = { 'BufRead', 'BufNewFile' },
    dependencies = {
      { 'zbirenbaum/copilot.lua', config = function() require('copilot').setup() end },
    },
    config = function() require('copilot_cmp').setup() end,
  },
  {
    'petertriho/cmp-git',
    ft = { 'gitcommit', 'gitrebase', 'octo' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('cmp_git').setup() end,
  },
  {
    'saecki/crates.nvim',
    event = 'BufRead Cargo.toml',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('crates').setup() end,
  },
  { 'folke/which-key.nvim', config = function() require('which-key').setup({ window = { border = 'single' } }) end },
  { 'folke/trouble.nvim', config = function() require('trouble').setup({}) end },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('todo-comments').setup({ highlight = { keyword = 'fg' } }) end,
  },
  {
    'folke/noice.nvim',
    cond = false,
    config = function()
      require('noice').setup({
        cmdline = { enabled = false },
        messages = { enabled = false },
        lsp = {
          progress = {
            enabled = false,
          },
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        views = {
          hover = {
            border = { style = 'rounded' },
            position = { row = 2 },
          },
        },
        presets = {
          inc_rename = true,
          long_message_to_split = true,
          lsp_doc_border = true,
        },
      })
    end,
    dependencies = {
      'MunifTanjim/nui.nvim',
      { 'rcarriga/nvim-notify', config = function() require('notify').setup({ background_colour = '#000000' }) end },
      {
        'smjonas/inc-rename.nvim',
        dependencies = {
          {
            'stevearc/dressing.nvim',
            config = function()
              require('dressing').setup({
                input = {
                  override = function(conf)
                    conf.col = -1
                    conf.row = 0
                    return conf
                  end,
                },
              })
            end,
          },
        },
        config = function()
          require('inc_rename').setup({ input_buffer_type = 'dressing' })
          keymaps.setup.incremental_rename()
        end,
      },
    },
  },
  {
    'goolord/alpha-nvim',
    config = function() require('alpha').setup(require('alpha.themes.startify').config) end,
  },
  { 'dstein64/vim-startuptime', cmd = 'StartupTime', config = function() vim.g.startuptime_tries = 3 end },
  {
    'andymass/vim-matchup',
    event = 'BufRead',
    init = function()
      vim.g.matchup_surround_enabled = 1
      vim.g.matchup_transmute = 1
      vim.g.matchup_matchparen_deferred = 1
    end,
  },
  { 'nmac427/guess-indent.nvim', config = function() require('guess-indent').setup({}) end },
  'tpope/vim-repeat',
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup({
        user_default_options = {
          RGB = false, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" codes like Blue or blue
          RRGGBBAA = true, -- #RRGGBBAA hex codes
          AARRGGBB = true, -- 0xAARRGGBB hex codes
          css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          mode = 'foreground', -- Set the display mode.
          tailwind = true, -- Enable tailwind colors
        },
      })
    end,
  },
  { 'kyazdani42/nvim-web-devicons' },
  { 'simrat39/symbols-outline.nvim', config = function() require('symbols-outline').setup() end },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    cmd = 'Neotree',
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
        end,
      },
    },
    init = function() vim.g.neo_tree_remove_legacy_commands = 1 end,
    config = function() require('pynappo/plugins/neo-tree') end,
    keys = keymaps.setup.neotree({ lazy = true }),
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        open_mapping = keymaps.toggleterm.open_mapping,
        winbar = {
          enabled = true,
          name_formatter = function(term) return term.name end,
        },
        highlights = { StatusLine = { guibg = 'StatusLine' } }, -- Hack for global heirline to work
      })
    end,
  },
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup({ easing_function = 'quadratic' })
      require('neoscroll.config').set_mappings(keymaps.neoscroll)
    end,
  },
  { 'sindrets/diffview.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nacro90/numb.nvim', config = function() require('numb').setup() end, event = 'CmdlineEnter' },
  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup({
        mapping = { 'jk', 'kj' },
        keys = function() return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>' end,
      })
    end,
  },
  { 'RRethy/vim-illuminate' },
  -- {
  --   'nyngwang/murmur.lua',
  --   config = function()
  --     local augroup = vim.api.nvim_create_augroup('murmur', { clear = true })
  --     require('murmur').setup {
  --       max_len = 80, -- maximum word-length to highlight
  --       exclude_filetypes = {},
  --       callbacks = {
  --         function ()
  --           vim.cmd.doautocmd('InsertEnter')
  --           vim.w.diag_shown = false
  --         end,
  --       }
  --     }
  --     vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  --       group = augroup,
  --       pattern = '*',
  --       callback = function ()
  --         if not vim.w.diag_shown and vim.w.cursor_word ~= '' then
  --           vim.diagnostic.open_float()
  --           vim.w.diag_shown = true
  --         end
  --       end
  --     })
  --   end,
  -- },
  {
    'kevinhwang91/nvim-hlslens',
    config = function() require('hlslens').setup() end,
    event = 'CmdlineEnter',
    cmd = { 'HlSearchLensEnable', 'HlSearchLensDisable', 'HlSearchLensToggle' },
    keys = keymaps.setup.hlslens({ lazy = true }),
  },
  {
    'nvim-neorg/neorg',
    ft = 'norg',
    cmd = 'Neorg',
    priority = 30,
    config = function() require('neorg').setup({ load = { ['core.defaults'] = {} } }) end,
  },
  {
    'rebelot/heirline.nvim',
    config = function() require('pynappo/plugins/heirline') end,
    event = 'ColorScheme', -- helps prevent colorscheme errors and stuff
    dependencies = {
      {
        'SmiteshP/nvim-navic',
        -- dependencies = { 'neovim/nvim-lspconfig' },
        config = function() require('pynappo/plugins/navic') end,
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = "BufReadPre",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
          change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
          delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
          changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        },
        signcolumn = false,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true
        },
        attach_to_untracked = true,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
      }
    end,
  },
  { 'tiagovla/scope.nvim', config = function() require('scope').setup() end },
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    dependencies = {
      'folke/neodev.nvim',
      'mfussenegger/nvim-jdtls',
      'simrat39/rust-tools.nvim',
      'jose-elias-alvarez/null-ls.nvim',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'alaviss/nim.nvim',
    },
    init = function() keymaps.setup.diagnostics() end,
    config = function()
      require('mason').setup({ ui = { border = 'single' } })
      require('pynappo/plugins/lsp')
    end,
  },
  -- { url = 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', config = function() require("lsp_lines").setup() end, },
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'rouge8/neotest-rust',
    },
    lazy = true
  },
  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = {
      { 'mfussenegger/nvim-dap' },
      {
        'theHamsta/nvim-dap-virtual-text',
        config = function() require('nvim-dap-virtual-text').setup({ commented = true }) end,
      },
    },
    config = function() require('pynappo/plugins/dap') end,
  },
  {
    'monaqa/dial.nvim',
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.hexcolor.new({ case = 'lower' }),
          augend.constant.alias.bool,
        },
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
          augend.constant.alias.bool,
        },
      })
    end,
    keys = keymaps.setup.dial({lazy=true})
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        sign = { enabled = false },
        virtual_text = { enabled = true, text = '💡', hl_mode = 'replace' },
      })
    end,
  },
  'ellisonleao/glow.nvim',
  -- { 'glacambre/firenvim', build = function() vim.fn['firenvim#install'](0) end },
  { 'AckslD/nvim-FeMaco.lua', config = function() require('femaco').setup() end },
  -- {
  --   'levouh/tint.nvim',
  --   cond = false,
  --   config = function()
  --     require('tint').setup({
  --       tint_background_colors = false,
  --       window_ignore_function = function(winid)
  --         local buftype = vim.bo[vim.api.nvim_win_get_buf(winid)].buftype
  --         local floating = vim.api.nvim_win_get_config(winid).relative ~= ''
  --         return vim.tbl_contains({ 'terminal', 'nofile' }, buftype) or floating
  --       end,
  --     })
  --   end,
  -- },
  -- {
  --   'nvim-zh/colorful-winsep.nvim',
  --   config = function() require('colorful-winsep').setup({ highlight = { fg = '#373751' } }) end,
  -- },
  {
    'xeluxee/competitest.nvim',
    cmd = {
      'CompetiTestAdd',
      'CompetiTestRun',
      'CompetiTestEdit',
      'CompetiTestDelete',
      'CompetiTestReceive',
      'CompetiTestRunNE',
      'CompetiTestRunNC',
      'CompetiTestConvert',
    },
    dependencies = { 'MunifTanjim/nui.nvim' },
    config = function() require('competitest').setup({ runner_ui = { interface = 'popup' } }) end,
  },
  {
    'dstein64/nvim-scrollview',
    config = function()
      require('scrollview').setup({
        excluded_filetypes = { 'neo-tree' },
        winblend = 75,
        base = 'right',
      })
    end,
  },
  {
    'mrjones2014/smart-splits.nvim',
    init = function() keymaps.setup.smart_splits() end,
    config = function() require('smart-splits').setup({}) end,
  },
  {
    'chentoast/marks.nvim',
    config = function() require('marks').setup() end,
    keys = keymaps.setup.marks({lazy=true})
  },
  {
    "gbprod/yanky.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    config = function()
      require("yanky").setup({
        picker = {
          select = {
            action = nil, -- nil to use default put action
          },
          telescope = {
            mappings = nil, -- nil to use default mappings
          },
        },
      })
      keymaps.setup.yanky()
    end
  },
  {
    'echasnovski/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.pairs').setup()
      require('mini.ai').setup()
    end
  }
}, lazy_opts)
