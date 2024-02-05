---@diagnostic disable: missing-fields
return {
  {
    'rebelot/heirline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      {
        'pynappo/tabnames.nvim',
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

      local hl = function(...) return utils.get_highlight(...) or {} end -- makes usage a bit simpler
      local function heirline_colors()
        local colors = {
          string = hl('String').fg or hl('Normal').fg,
          normal = hl('Normal').fg,
          func = hl('Function').fg or hl('Normal').fg,
          type = hl('Type').fg or hl('Normal').fg,
          debug = hl('Debug').fg or hl('Normal').fg,
          comment = hl('Comment').fg or hl('Normal').fg,
          directory = hl('Directory').fg or hl('Normal').fg,
          constant = hl('Constant').fg or hl('Normal').fg,
          statement = hl('Statement').fg or hl('Normal').fg,
          special = hl('Special').fg or hl('Normal').fg,
          diag_warn = hl('DiagnosticWarn').fg or hl('Normal').fg,
          diag_error = hl('DiagnosticError').fg or hl('Normal').fg,
          diag_hint = hl('DiagnosticHint').fg or hl('Normal').fg,
          diag_info = hl('DiagnosticInfo').fg or hl('Normal').fg,
          git_del = hl('GitsignsDelete').fg or hl('DiffRemoved').fg or hl('DiffDelete').bg,
          git_add = hl('GitsignsAdd').fg or hl('DiffAdded').fg or hl('DiffAdded').bg,
          git_change = hl('GitsignsChange').fg or hl('DiffChange').fg or hl('DiffChange').bg,
          tabline_sel = hl('TabLineSel').bg or hl('Visual').bg,
          tabline = hl('TabLine').bg,
          statusline = hl('StatusLine').bg,
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
      local p = require('pynappo.plugins.heirline.components.plugins')
      local function surround_label(label, delimiters, color, component)
        return utils.surround({ label .. delimiters[1], delimiters[2] }, color, component),
          utils.surround(delimiters, color, component)
      end
      local vi_mode_block = utils.surround({ '', ' ' }, get_mode_color, { c.vi_mode, hl = { fg = 'black' } })
      local ruler_block = utils.surround({ '', '' }, get_mode_color, { c.ruler, hl = { fg = 'black' } })
      local tools_block = {
        flexible = 5,
        surround_label('Tools: ', { '', '' }, 'diag_info', {
          u.space,
          { c.lsp_icons, hl = { fg = 'debug' } },
          u.comma,
          u.space,
          {
            p.conform,
            hl = { fg = 'string' },
          },
          u.comma,
          u.space,
          {
            p.lint,
            hl = { fg = 'diag_info' },
          },
          u.space,
          hl = { bg = 'statusline' },
        }),
      }
      local t = require('pynappo.plugins.heirline.components.tabline')
      require('heirline').setup({
        statusline = {
          hl = function() return not conditions.buffer_matches({ buftype = { 'terminal' } }) and 'StatusLine' or nil end,
          static = {
            mode_colors = mode_colors,
            get_mode_color = get_mode_color,
          },
          { vi_mode_block },
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
            condition = function() return conditions.buffer_matches({ filetype = { 'alpha', 'starter' } }) end,
            lazy_block,
            u.space,
          },
          { p.dap, tools_block, u.space, ruler_block },
        },
        winbar = {
          fallthrough = false,
          init = function(self) self.winbar = true end,
          hl = function() return conditions.is_active() and 'WinBar' or 'WinBarNC' end,
          {
            condition = function() return conditions.buffer_matches({ buftype = { 'help' } }) end,
            c.filetype,
            u.align,
            c.filename,
          },
          {
            condition = function() return conditions.buffer_matches({ buftype = { 'terminal' } }) end,
            u.align,
            c.file_icon,
            u.space,
            c.termname,
          },
          { p.dropbar, u.align, c.diagnostics, c.gitsigns, u.space, c.file_info },
        },
        tabline = { t.offset, t.bufferline, u.align, t.tabpages },
        statuscolumn = {
          condition = function()
            return not conditions.buffer_matches({ buftype = { 'nofile', 'prompt', 'quickfix', 'help' } })
          end,
          init = function(self)
            self.marks = {}
            for _, mark in pairs(vim.fn.getmarklist(vim.api.nvim_get_current_buf())) do
              self.marks[mark.pos[2]] = mark
            end
            self.current_line = vim.api.nvim_win_get_cursor(0)[1]
          end,
          {
            provider = function(self)
              if self.marks[vim.v.lnum] then return self.marks[vim.v.lnum].mark:sub(2) end
            end,
            hl = '@comment.note',
          },
          { provider = [[%s]] },
          {
            fallthrough = false,
            { condition = function() return vim.v.virtnum ~= 0 end },
            {
              condition = function(self) return vim.v.lnum == self.current_line end,
              u.align,
              { provider = function() return vim.v.lnum end },
            },
            { u.align, { provider = function() return vim.v.relnum end } },
          },
          { provider = [[%1(%C%)]] },
        },
        opts = {
          disable_winbar_cb = function(args)
            return conditions.buffer_matches({
              buftype = { 'nofile', 'prompt', 'quickfix' },
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
