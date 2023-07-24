local keymaps = require('pynappo/keymaps')
local theme = require('pynappo.theme')
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    config = function()
      local colors = { '#3b2727', '#464431', '#31493a', '#273b4b', '#303053', '#403040' }
      local hl_list = theme.set_rainbow_colors('IndentBlanklineContextChar', colors, 'Set rainbow indent lines')
      require('indent_blankline').setup({
        filetype_exclude = { 'help', 'terminal', 'dashboard', 'packer', 'text' },
        show_trailing_blankline_indent = true,
        space_char_blankline = ' ',
        char_highlight_list = vim.tbl_map(function(table) return table[1] end, hl_list),
        use_treesitter = true,
        use_treesitter_scope = true,
      })
      theme.overrides.all_themes.nvim_highlights['IndentBlanklineContextChar'] = { fg='#777777', bold = true, nocombine = true }
    end,
  },
  { 'folke/which-key.nvim', event = 'VeryLazy', opts = {window = {border = 'single'}} },
  { 'folke/trouble.nvim', config = true, cmd = 'Trouble', keys = keymaps.setup.trouble({lazy = true})},
  { 'folke/todo-comments.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { highlight = { keyword = 'fg', after = '' } } },
  {
    'folke/noice.nvim',
    opts = {
      cmdline = {
        enabled = false,
        view = "cmdline"
      },
      messages = { enabled = false },
      lsp = {
        progress = {
          enabled = true,
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
        mini = {
          position = { row = -1 - vim.o.cmdheight } -- better default
        }
      },
      routes = {
        {
          filter = {
            event = 'lsp',
            kind = 'progress',
            cond = function(message)
              local client = vim.tbl_get(message.opts, 'progress', 'client')
              return client == 'null-ls'
            end
          },
          opts = {skip = true}
        },
        {
          filter = { find = 'No information available' },
          opts = { stop = true },
        },
        {
          filter = { find = 'bytes$' },
          opts = { skip = true },
        },
      },
      presets = {
        inc_rename = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
      {
        'smjonas/inc-rename.nvim',
        dependencies = {
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
            }
          },
        },
        init = keymaps.setup.incremental_rename,
        config = true
      },
    },
  },
  {
    'RRethy/vim-illuminate',
    event = 'BufRead',
    config = function()
      require('illuminate').configure({
        filetypes_denylist = {
          'dropbar_menu'
        }
      })
    end
  },
  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup({
        override_lens = function(render, pos_list, nearest, idx, rel_idx)
          local sfw = vim.v.searchforward == 1
          local indicator, text, chunks
          local abs_rel_idx = math.abs(rel_idx)
          if abs_rel_idx > 1 then
            indicator = ('%d %s'):format(abs_rel_idx, sfw ~= (rel_idx > 1) and '' or '')
          elseif abs_rel_idx == 1 then
            indicator = sfw ~= (rel_idx == 1) and '' or ''
          end

          local lnum, col = unpack(pos_list[idx])
          if nearest then
            local cnt = #pos_list
            if indicator then
              text = ('%s %d'):format(indicator, idx)
            else
              text = ('%d/%d'):format(idx, cnt)
            end
            chunks = {{' ', 'Ignore'}, {' ', 'HlSearchLensNearSurround'}, {text, 'HlSearchLensNear'}, {'', 'HlSearchLensNearSurround'}, }
          else
            text = indicator
            chunks = {{' ', 'Ignore'}, {'', 'HlSearchLensSurround'}, {text, 'HlSearchLens'}, {'', 'HlSearchLensSurround'}, }
          end
          render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
        end
      })

      for _, hl in ipairs({'HlSearchLensNear', 'HlSearchLens'}) do
        require('pynappo.theme').overrides.all_themes.nvim_highlights[hl .. 'Surround'] = {fg = require('pynappo.utils').nvim_get_hl_hex(0, {name = hl, link = false}).bg}
      end
    end,
    event = 'CmdlineEnter',
    cmd = { 'HlSearchLensEnable', 'HlSearchLensDisable', 'HlSearchLensToggle' },
    keys = keymaps.setup.hlslens({ lazy = true }),
  },
  {
    'dstein64/nvim-scrollview',
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
      require('pynappo.theme').overrides.all_themes.vim_highlights.ScrollViewMarks = 'guibg=NONE'
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    config = function()
      require('nvim-lightbulb').setup({
        sign = { enabled = false},
        virtual_text = {
          enabled = true
        }
      })
      vim.api.nvim_create_autocmd({'CursorHold, CursorHoldI'}, {
        callback = function() require('nvim-lightbulb').update_lightbulb() end
      })
    end,
  },
  {
    'NvChad/nvim-colorizer.lua',
    opts = {
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
    }
  },
}
