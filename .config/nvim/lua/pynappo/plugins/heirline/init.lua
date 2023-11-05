return {
  {
    'rebelot/heirline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      {
        'pynappo/tabnames.nvim',
        opts = {
          session_support = true,
        },
      },
      {
        'Bekaboo/dropbar.nvim',
        opts = {
          general = { enable = false },
          icons = {
            ui = {
              bar = {
                separator = '  ',
                extends = '…',
              },
            },
          },
          bar = {
            sources = function()
              local sources = require('dropbar.sources')
              return {
                -- sources.path,
                {
                  get_symbols = function(buf, win, cursor)
                    if vim.bo[buf].ft == 'markdown' then return sources.markdown.get_symbols(buf, win, cursor) end
                    for _, source in ipairs({ sources.lsp, sources.treesitter }) do
                      local symbols = source.get_symbols(buf, win, cursor)
                      if not vim.tbl_isempty(symbols) then return symbols end
                    end
                    return {}
                  end,
                },
              }
            end,
            truncate = true,
          },
        },
      },
    },
    init = require('pynappo.keymaps').setup.heirline,
    config = function()
      local utils = require('heirline.utils')
      local conditions = require('heirline.conditions')

      local get_hl = function(...) return utils.get_highlight(...) or {} end -- makes usage a bit simpler
      local function heirline_colors()
        local colors = {
          string = get_hl('String').fg,
          normal = get_hl('Normal').fg,
          func = get_hl('Function').fg,
          type = get_hl('Type').fg,
          debug = get_hl('Debug').fg,
          comment = get_hl('Comment').fg,
          directory = get_hl('Directory').fg,
          constant = get_hl('Constant').fg,
          statement = get_hl('Statement').fg,
          special = get_hl('Special').fg,
          diag_warn = get_hl('DiagnosticWarn').fg,
          diag_error = get_hl('DiagnosticError').fg,
          diag_hint = get_hl('DiagnosticHint').fg,
          diag_info = get_hl('DiagnosticInfo').fg,
          git_del = get_hl('GitsignsDelete').fg or get_hl('DiffRemoved').fg or get_hl('DiffDelete').bg,
          git_add = get_hl('GitsignsAdd').fg or get_hl('DiffAdded').fg or get_hl('DiffAdded').bg,
          git_change = get_hl('GitsignsChange').fg or get_hl('DiffChange').fg or get_hl('DiffChange').bg,
          tabline_sel = get_hl('TabLineSel').bg or get_hl('Visual').bg,
          tabline = get_hl('TabLine').bg,
        }
        return colors
      end
      local heirline_augroup = vim.api.nvim_create_augroup('Heirline', { clear = true })

      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function() utils.on_colorscheme(heirline_colors()) end,
        group = heirline_augroup,
      })

      local mode_colors = {
        n = 'type',
        i = 'string',
        v = 'func',
        V = 'func',
        ['\22'] = '',
        c = 'debug',
        s = 'constant',
        S = 'constant',
        ['\19'] = 'constant',
        R = 'diag_error',
        r = 'diag_error',
        ['!'] = 'diag_error',
        t = 'normal',
      }
      local get_mode_color = function(self) return self.mode_colors[conditions.is_active() and vim.fn.mode() or 'n'] end

      local c = require('pynappo.plugins.heirline.components.base')
      local u = require('pynappo.plugins.heirline.components.utils')
      c.vi_mode_block = utils.surround({ '', ' ' }, get_mode_color, { c.vi_mode, hl = { fg = 'black' } })
      c.lsp_block = {
        flexible = 2,
        utils.surround({ 'LSP: ', '' }, 'string', { c.lsp_icons, hl = { fg = 'black' } }),
        utils.surround({ '', '' }, 'string', { c.lsp_icons, hl = { fg = 'black' } }),
      }
      c.ruler_block = utils.surround({ '', '' }, get_mode_color, { c.ruler, hl = { fg = 'black' } })
      c.lazy_block = {
        flexible = 4,
        utils.surround({ 'Plugin updates: ', '' }, 'diag_info', { c.lazy, hl = { fg = 'black' } }),
        utils.surround({ '', '' }, 'diag_info', { c.lazy, hl = { fg = 'black' } }),
      }
      c.conform_block = {
        flexible = 4,
        utils.surround({ 'Conform: ', '' }, 'diag_info', { c.conform, hl = { fg = 'black' } }),
        utils.surround({ '', '' }, 'diag_info', { c.conform, hl = { fg = 'black' } }),
      }

      local t = require('pynappo.plugins.heirline.components.tabline')
      require('heirline').setup({
        ---@diagnostic disable-next-line: missing-fields
        statusline = {
          hl = function() return not conditions.buffer_matches({ buftype = { 'terminal' } }) and 'StatusLine' or nil end,
          static = {
            mode_colors = mode_colors,
            get_mode_color = get_mode_color,
          },
          { c.vi_mode_block },
          u.align,
          {
            fallthrough = false,
            {
              condition = function()
                return conditions.buffer_matches({
                  buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
                  filetype = { '^git.*', 'fugitive' },
                })
              end,
              c.cwd,
              c.filetype,
              u.space,
              c.help_filename,
            },
            {
              condition = function() return conditions.buffer_matches({ buftype = { 'terminal' } }) end,
              c.file_icon,
              u.space,
              c.termname,
            },
            { c.cwd, c.file_info },
          },
          u.align,
          {
            condition = function() return conditions.buffer_matches({ filetype = { 'alpha' } }) end,
            c.lazy_block,
            u.space,
          },
          { c.dap, c.lsp_block, u.space, c.conform_block, u.space, c.ruler_block },
        },
        winbar = {
          fallthrough = false,
          init = function(self) self.winbar = true end,
          hl = function() return conditions.is_active() and 'WinBar' or 'WinBarNC' end,
          {
            condition = function() return conditions.buffer_matches({ buftype = { 'terminal' } }) end,
            u.align,
            c.file_icon,
            u.space,
            c.termname,
          },
          { c.dropbar, u.align, c.diagnostics, c.gitsigns, u.space, c.file_info },
        },
        tabline = { t.offset, t.bufferline, u.align, t.tabpages },
        statuscolumn = {
          condition = function()
            return not conditions.buffer_matches({ buftype = { 'nofile', 'prompt', 'quickfix', 'help' } })
          end,
          { provider = [[%s]] },
          {
            init = function(self) self.current_line = vim.api.nvim_win_get_cursor(0)[1] end,
            fallthrough = false,
            { condition = function() return vim.v.virtnum ~= 0 end },
            {
              condition = function(self) return vim.v.lnum == self.current_line end,
              { provider = function() return vim.v.lnum end },
              u.align,
            },
            { u.align, { provider = function() return vim.v.relnum end } },
          },
          { provider = [[%1(%C%)]] },
        },
        opts = {
          disable_winbar_cb = function(args)
            return conditions.buffer_matches({
              buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
              filetype = { '^git.*', 'fugitive', 'Trouble', 'dashboard' },
            }, args.buf)
          end,
          colors = heirline_colors(),
        },
      })
      -- need to ensure this happens after tint.nvim sets up
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function() require('pynappo.autocmds').heirline_mode_cursorline(mode_colors) end,
      })
    end,
  },
}
