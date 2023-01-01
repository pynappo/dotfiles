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

local lazy_opts = {
  root = vim.fn.stdpath('data') .. '/lazy', -- directory where plugins will be installed
  defaults = {
    lazy = false, -- should plugins be lazy-loaded?
  },
  lockfile = vim.fn.stdpath('config') .. '/lazy-lock.json', -- lockfile generated after running update.
  concurrency = nil, ---@type number limit the maximum amount of concurrent tasks
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
      paths = {}, -- add any custom paths here that you want to indluce in the rtp
      ---@type string[] list any plugins you want to disable here
      -- disabled_plugins = require('init').disabled_plugins,
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
  { 'tpope/vim-fugitive' },
  {
    'Shatur/neovim-ayu',
    priority = 100,
    config = function()
      local colors = require('ayu.colors')
      require('ayu').setup({
        mirage = true,
        overrides = {
          Wildmenu = { bg = colors.bg, fg = colors.markup },
          Comment = { fg = 'gray', italic = true },
          LineNr = { fg = 'gray' },
        },
      })
    end,
  },
  { 'TimUntersberger/neogit', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Octo',
    config = function() require('octo').setup() end,
  },
  { 'ludovicchabant/vim-gutentags', config = function() require('pynappo/plugins/gutentags') end },
  { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end },
  { 'ggandor/leap.nvim', config = function() require('leap').add_default_mappings() end },
  { 'ggandor/leap-spooky.nvim', config = function() require('leap-spooky').setup() end },
  { 'kylechui/nvim-surround', config = function() require('nvim-surround').setup() end },
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    init = function()
      vim.api.nvim_create_autocmd('VimEnter', {
        pattern = '*',
        once = true,
        callback = function() pcall(vim.api.nvim_clear_autocmds, { group = 'FileExplorer' }) end,
      })
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
    keys = require('pynappo/keymaps').setup.telescope({ lazy = true }),
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('pynappo/autocmds').create_autocmd('ColorScheme', {
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
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('pynappo/plugins/treesitter') end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      -- 'p00f/nvim-ts-rainbow', breaks too much
      'windwp/nvim-ts-autotag',
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
          require('treesitter-context').setup({
            min_window_height = 30,
          })
        end,
      },
      'nvim-treesitter/playground',
      'RRethy/nvim-treesitter-textsubjects',
    },
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    cmd = "TSJToggle",
    config = function()
      require('treesj').setup({ use_default_keymaps = false })
      require('pynappo/keymaps').setup.treesj()
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    config = function() require('luasnip.loaders.from_vscode').lazy_load() end,
    dependencies = { 'rafamadriz/friendly-snippets' },
  },
  {
    'hrsh7th/nvim-cmp',
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
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'davidsierradz/cmp-conventionalcommits',
    },
  },
  {
    'zbirenbaum/copilot-cmp',
    event = 'BufRead',
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
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true,
        ts_config = {},
        ignored_next_char = '[%w%.]',
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '"', "'" },
          pattern = [=[[%"%"%)%>%]%)%}%,]]=],
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'Search',
          highlight_grey = 'Comment',
        },
      })
    end,
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
          require('pynappo/keymaps').setup.incremental_rename()
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
    keys = require('pynappo/keymaps').setup.neo_tree({ lazy = true }),
  },
  {
    'akinsho/toggleterm.nvim',
    config = function()
      require('toggleterm').setup({
        open_mapping = require('pynappo/keymaps').toggleterm.open_mapping,
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
      require('neoscroll.config').set_mappings(require('pynappo/keymaps').neoscroll)
    end,
  },
  { 'sindrets/diffview.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'simnalamburt/vim-mundo',
    cmd = { 'MundoToggle', 'MundoShow', 'MundoHide' },
  },
  { 'nacro90/numb.nvim', config = function() require('numb').setup() end },
  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup({
        mapping = { 'jk', 'kj' },
        keys = function() return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>' end,
      })
    end,
  },
  { 'nyngwang/murmur.lua', config = function() require('pynappo/plugins/murmur') end },
  {
    'kevinhwang91/nvim-hlslens',
    config = function() require('hlslens').setup() end,
    event = 'CmdlineEnter',
    cmd = { 'HlSearchLensEnable', 'HlSearchLensDisable', 'HlSearchLensToggle' },
    keys = require('pynappo/keymaps').setup.hlslens({ lazy = true }),
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
    dependencies = {
      {
        'SmiteshP/nvim-navic',
        dependencies = { 'neovim/nvim-lspconfig' },
        config = function() require('pynappo/plugins/navic') end,
      },
      { 'lewis6991/gitsigns.nvim' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('pynappo/plugins/gitsigns') end,
  },
  { 'tiagovla/scope.nvim', config = function() require('scope').setup() end },
  {
    'neovim/nvim-lspconfig',
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
    init = function() require('pynappo/keymaps').setup.diagnostics() end,
    config = function()
      require('mason').setup({ ui = { border = 'single' } })
      require('pynappo/plugins/lsp')
    end,
  },
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
    init = function() require('pynappo/keymaps').setup.dial() end,
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
  {
    'levouh/tint.nvim',
    config = function()
      require('tint').setup({
        window_ignore_function = function(winid)
          local buftype = vim.bo[vim.api.nvim_win_get_buf(winid)].buftype
          local floating = vim.api.nvim_win_get_config(winid).relative ~= ''
          return vim.tbl_contains({ 'terminal', 'nofile' }, buftype) or floating
        end,
      })
    end,
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    config = function() require('colorful-winsep').setup({ highlight = { fg = '#373751' } }) end,
  },
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
  { 'ggandor/flit.nvim', config = function() require('flit').setup({ labeled_modes = 'v' }) end },
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
    init = function() require('pynappo/keymaps').setup.smart_splits() end,
    config = function() require('smart-splits').setup({}) end,
  },
  {
    'melkster/modicator.nvim',
    init = function()
      vim.o.number = true
      vim.o.cursorline = true
    end,
    config = function() require('modicator').setup() end,
  },
}, lazy_opts)
