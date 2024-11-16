return {
  conform = {
    update = { 'BufEnter', 'BufNewFile', 'CmdlineLeave' },
    provider = function(self)
      local ok, conform = pcall(require, 'conform')
      if not ok then return 'no conform' end
      self.formatters = conform.list_formatters(0)
      return self.formatters and table.concat(vim.tbl_map(function(f) return f.name end, self.formatters), ' ') or 'N/A'
    end,
  },
  lazy = {
    condition = function()
      local ok, lazy_status = pcall(require, 'lazy.status')
      return ok and lazy_status.has_updates()
    end,
    provider = function() return require('lazy.status').updates() end,
    on_click = {
      callback = function() require('lazy').check() end,
      name = 'heirline_plugin_updates',
    },
  },
  lint = {
    condition = function(self)
      local ok, lint = pcall(require, 'lint')
      self.lint = lint
      return ok
    end,
    provider = function(self)
      local linters = self.lint.linters_by_ft[vim.bo.filetype] or {}
      if #linters == 0 then return 'N/A' end
      local str = ''
      for i, linter in ipairs(linters) do
        if vim.tbl_contains(self.lint.get_running(), linter) then linter = '*' .. linter end
        if i < #linters then linter = linter .. ', ' end
        str = str .. linter
      end
      return str
    end,
  },
  dap = {
    {
      condition = function()
        local ok, dap = pcall(require, 'dap')
        return ok and dap.session()
      end,
      provider = function() return ' ' .. require('dap').status() .. ' ' end,
      hl = 'Debug',
      {
        provider = '󰆹',
        on_click = {
          callback = function() require('dap').step_into() end,
          name = 'heirline_dap_step_into',
        },
      },
      { provider = ' ' },
      {
        provider = '󰆸',
        on_click = {
          callback = function() require('dap').step_out() end,
          name = 'heirline_dap_step_out',
        },
      },
      { provider = ' ' },
      {
        provider = '󰆷',
        on_click = {
          callback = function() require('dap').step_over() end,
          name = 'heirline_dap_step_over',
        },
      },
      { provider = ' ' },
      {
        provider = '󰜉',
        on_click = {
          callback = function() require('dap').run_last() end,
          name = 'heirline_dap_run_last',
        },
      },
      { provider = ' ' },
      {
        provider = '󰅖',
        on_click = {
          callback = function()
            require('dap').terminate()
            require('dapui').close({})
          end,
          name = 'heirline_dap_close',
        },
      },
    },
    update = { 'CursorHold' },
  },
  dropbar = {
    condition = function(self)
      self.data = vim.tbl_get(dropbar.bars or {}, vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win())
      return self.data
    end,
    static = { dropbar_on_click_string = 'v:lua.dropbar.callbacks.buf%s.win%s.fn%s' },
    init = function(self)
      local components = self.data.components
      local children = {}
      for i, c in ipairs(components) do
        local child = {
          {
            hl = c.icon_hl,
            provider = c.icon:gsub('%%', '%%%%'),
          },
          {
            hl = c.name_hl,
            provider = c.name:gsub('%%', '%%%%'),
          },
          on_click = {
            callback = self.dropbar_on_click_string:format(self.data.buf, self.data.win, i),
            name = 'heirline_dropbar',
          },
        }
        if i < #components then
          local sep = self.data.separator
          table.insert(child, {
            provider = sep.icon,
            hl = sep.icon_hl,
            on_click = {
              callback = self.dropbar_on_click_string:format(self.data.buf, self.data.win, i + 1),
            },
          })
        end
        table.insert(children, child)
      end
      self.child = self:new(children, 1)
    end,
    provider = function(self) return self.child:eval() end,
  },
}
