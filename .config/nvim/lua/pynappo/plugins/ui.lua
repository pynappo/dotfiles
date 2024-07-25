local keymaps, theme = require('pynappo.keymaps'), require('pynappo.theme')
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufNewFile', 'BufReadPre' },
    config = function()
      local colors = {
        { 'Red', '#3b2727' },
        { 'Yellow', '#464431' },
        { 'Green', '#31493a' },
        { 'Blue', '#273b4b' },
        { 'Indigo', '#303053' },
        { 'Violet', '#403040' },
      }
      require('ibl').setup({
        exclude = {
          filetypes = { 'help', 'terminal', 'dashboard', 'packer', 'text' },
        },
        indent = {
          highlight = theme.set_rainbow_colors('IndentBlanklineLevel', colors),
        },
        scope = {
          enabled = false,
          show_start = true,
        },
      })
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  {
    'folke/trouble.nvim',
    config = true,
    cmd = 'Trouble',
    keys = keymaps.setup.trouble({
      lazy = true,
    }),
  },
  -- {
  --   'folke/todo-comments.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   opts = { highlight = { keyword = 'fg', after = '' } },
  -- },
  {
    'RRethy/vim-illuminate',
    event = { 'BufNewFile', 'BufRead' },
    config = function()
      require('illuminate').configure({
        filetypes_denylist = {
          'dropbar_menu',
        },
      })
    end,
  },
  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup({
        override_lens = function(render, pos_list, nearest, idx, rel_idx)
          local sfw = vim.v.searchforward == 1
          local indicator, text, chunks
          local abs_rel_idx = math.abs(rel_idx)
          if abs_rel_idx > 0 then indicator = ('%d %s'):format(abs_rel_idx, sfw ~= (rel_idx > 1) and '' or '') end

          local lnum, col = unpack(pos_list[idx])
          if nearest then
            local cnt = #pos_list
            if indicator then
              text = ('%s %d'):format(indicator, idx)
            else
              text = ('%d/%d'):format(idx, cnt)
            end
            chunks = {
              { '            ', 'HlSearchLensNearIcon' },
              { ' ', 'Ignore' },
              { '', 'HlSearchLensNearSurround' },
              { text, 'HlSearchLensNear' },
              { ' ', 'HlSearchLensNearSurround' },
            }
          else
            text = indicator
            chunks = {
              { '        ', 'Ignore' },
              { '', 'HlSearchLensSurround' },
              { text, 'HlSearchLens' },
              { '', 'HlSearchLensSurround' },
            }
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end,
      })

      local nvim_get_hl_hex = require('pynappo.utils').nvim_get_hl_hex
      local overrides = require('pynappo.theme').overrides
      for _, hl in ipairs({ 'HlSearchLensNear', 'HlSearchLens' }) do
        overrides.all.nvim_highlights[hl .. 'Surround'] = { fg = nvim_get_hl_hex(0, { name = hl, link = false }).bg }
        overrides.all.nvim_highlights[hl .. 'Icon'] =
          { fg = nvim_get_hl_hex(0, { name = hl, link = false }).fg, bold = true }
      end
    end,
    event = 'CmdlineEnter',
    cmd = { 'HlSearchLensEnable', 'HlSearchLensDisable', 'HlSearchLensToggle' },
    keys = keymaps.setup.hlslens({ lazy = true }),
  },
  {
    'dstein64/nvim-scrollview',
    enabled = true,
    config = function()
      require('scrollview').setup({
        excluded_filetypes = { 'neo-tree' },
        winblend = 75,
        signs_on_startup = {
          'conflicts',
          'spell',
          'marks',
          'loclist',
          'diagnostics',
          'search',
          'quickfix',
          'trail',
        },
        base = 'right',
      })
      theme.overrides.all.vim_highlights.ScrollViewMarks = 'guibg=NONE'
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        sign = { enabled = false },
        virtual_text = {
          enabled = true,
        },
      })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        callback = function() require('nvim-lightbulb').update_lightbulb() end,
      })
    end,
  },
  {
    'folke/noice.nvim',
    lazy = false,
    keys = {
      {
        '<S-Enter>',
        function() require('noice').redirect(vim.fn.getcmdline()) end,
        mode = 'c',
        desc = 'Redirect Cmdline',
      },
    },
    opts = {
      cmdline = {
        enabled = false,
        view = 'cmdline',
      },
      messages = { enabled = false },
      lsp = {
        progress = {
          enabled = false,
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = false,
          ['vim.lsp.util.stylize_markdown'] = false,
          ['cmp.entry.get_documentation'] = false,
        },
      },
      views = {
        hover = {
          border = { style = 'rounded' },
          position = { row = 2 },
        },
        mini = {
          position = { row = -1 - vim.o.cmdheight }, -- better default
        },
      },
      routes = {
        {
          filter = {
            event = 'lsp',
            kind = 'progress',
            cond = function(message)
              local client = vim.tbl_get(message.opts, 'progress', 'client')
              return client == 'null-ls'
            end,
          },
          opts = { skip = true },
        },
        {
          filter = { find = 'No information' },
          opts = { skip = true },
        },
        {
          filter = { find = 'bytes$' },
          opts = { skip = true },
        },
      },
      presets = {
        inc_rename = false,
        long_message_to_split = false,
        lsp_doc_border = true,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      {
        'rcarriga/nvim-notify',
        opts = {
          render = 'wrapped-compact',
        },
      },
      {
        'smjonas/inc-rename.nvim',
        dependencies = 'stevearc/dressing.nvim',
        init = keymaps.setup.incremental_rename,
        opts = {
          input_buffer_type = 'dressing',
        },
      },
    },
  },
  {
    'stevearc/dressing.nvim',
    opts = {
      input = {
        override = function(conf)
          conf.col = -1
          conf.row = 0
          return conf
        end,
      },
      select = {
        backend = { 'fzf_lua', 'telescope', 'nui', 'builtin' },
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'nvim-zh/colorful-winsep.nvim',
    config = function()
      require('colorful-winsep').setup({
        -- highlight for Window separator
        hi = {
          bg = '#16161E',
          fg = '#1F3442',
        },
        -- This plugin will not be activated for filetype in the following table.
        no_exec_files = { 'packer', 'TelescopePrompt', 'mason', 'CompetiTest', 'NvimTree' },
        -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
        symbols = { '━', '┃', '┏', '┓', '┗', '┛' },
        anchor = {
          left = { height = 1, x = -1, y = -1 },
          right = { height = 1, x = -1, y = 0 },
          up = { width = 0, x = -1, y = 0 },
          bottom = { width = 0, x = 1, y = 0 },
        },
      })
    end,
    event = { 'WinNew' },
  },
  {
    'bennypowers/nvim-regexplainer',
    cmd = {
      'RegexplainerHide',
      'RegexplainerToggle',
      'RegexplainerDebug',
      'RegexplainerYank',
      'RegexplainerShowSplit',
      'RegexplainerShowPopup',
      'RegexplainerShow',
    },
    config = function() require('regexplainer').setup() end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'MunifTanjim/nui.nvim',
    },
  },
}
