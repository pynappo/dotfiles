local keymaps = require('pynappo.keymaps')
return {
  'tpope/vim-fugitive',
  {
    'Shatur/neovim-ayu',
    priority = 100,
    config = function()
      local colors = require('ayu.colors')
      local mirage = true
      colors.generate(mirage)
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
  {
    'ludovicchabant/vim-gutentags',
    cond = false,
    init = function() vim.g.gutentags_cache_dir = vim.fn.expand('~/.cache/nvim/ctags/') end,
    config = function() vim.api.nvim_create_user_command('GutentagsClearCache', function() vim.fn.system('rm', vim.g.gutentags_cache_dir .. '/*') end, {}) end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    config = function()
      local hl_list = {}
      local colors = { '#4b2121', '#464421', '#21492a', '#284043', '#223b4b', '#463145' }
      for i, color in pairs(colors) do
        local name = 'IndentBlanklineIndent' .. i
        vim.api.nvim_set_hl(0, name, { fg = color, nocombine = true })
        table.insert(hl_list, name)
      end
      vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { fg='#777777', bold = true, nocombine = true })
      require('pynappo/autocmds').create('ColorScheme', {
        callback = function()
          for i, color in pairs(colors) do
            vim.api.nvim_set_hl(0, 'IndentBlanklineIndent' .. i, { fg = color, nocombine = true })
          end
          vim.api.nvim_set_hl(0, 'IndentBlanklineContextChar', { fg='#777777', bold = true, nocombine = true })
        end,
        desc = 'Persist rainbow indent lines across colorschemes'
      })
      require('indent_blankline').setup({
        filetype_exclude = { 'help', 'terminal', 'dashboard', 'packer', 'text' },
        show_trailing_blankline_indent = true,
        space_char_blankline = ' ',
        char_highlight_list = hl_list,
        use_treesitter = true,
        use_treesitter_scope = true,
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
      vim.g.matchup_matchparen_offscreen = {}
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
    'nvim-neorg/neorg',
    ft = 'norg',
    cmd = 'Neorg',
    priority = 30,
    config = function() require('neorg').setup({ load = { ['core.defaults'] = {} } }) end,
  },
    { 'tiagovla/scope.nvim', config = function() require('scope').setup() end },
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
}
